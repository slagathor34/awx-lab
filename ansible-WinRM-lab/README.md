# Ansible WinRM Lab

## WinRM Setup

### Insecure Lab Configuration

```
$selector_set = @{
    Address = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = $thumbprint
}

New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file

winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
```

## Secure WinRM configuration (Non-Domain)

1. Enable Windows Remote Management service (WinRM)

```
Set-Service -Name "WinRM" -StartupType Automatic
Start-Service -Name "WinRM"

if (-not (Get-PSSessionConfiguration) -or (-not (Get-ChildItem WSMan:\localhost\Listener))) {
    ## Use SkipNetworkProfileCheck to make available even on Windows Firewall public profiles
    ## Use Force to not be prompted if we're sure or not.
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
}
```

2. Enable Certificate Based Authentication

```
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
```

3. Create a local user account

```
$testUserAccountName = 'ansibletestuser'
$testUserAccountPassword = (ConvertTo-SecureString -String 'p@$$w0rd12' -AsPlainText -Force)
if (-not (Get-LocalUser -Name $testUserAccountName -ErrorAction Ignore)) {
    $newUserParams = @{
        Name                 = $testUserAccountName
        AccountNeverExpires  = $true
        PasswordNeverExpires = $true
        Password             = $testUserAccountPassword
    }
    $null = New-LocalUser @newUserParams
}

```

4. Create the Client Certificate

```
## This is the public key generated from the Ansible server using:
cat > openssl.conf << EOL
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:ansibletestuser@localhost
EOL
export OPENSSL_CONF=openssl.conf
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out cert.pem -outform PEM -keyout cert_key.pem -subj "/CN=ansibletestuser" -extensions v3_req_client
rm openssl.conf 
```

5. Import the Client Certificate

```
$pubKeyFilePath = 'C:\cert.pem'

## Import the public key into Trusted Root Certification Authorities and Trusted People
$null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\Root'
$null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\TrustedPeople'
```

6. Create the Server Certificate

```
$hostname = hostname
$serverCert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation 'Cert:\LocalMachine\My'
```

7. Create the Ansible WinRM Listener

```
## Find all HTTPS listners
$httpsListeners = Get-ChildItem -Path WSMan:\localhost\Listener\ | where-object { $_.Keys -match 'Transport=HTTPS' }

## If not listeners are defined at all or no listener is configured to work with
## the server cert created, create a new one with a Subject of the computer's host name
## and bound to the server certificate.
if ((-not $httpsListeners) -or -not (@($httpsListeners).where( { $_.CertificateThumbprint -ne $serverCert.Thumbprint }))) {
    $newWsmanParams = @{
        ResourceUri = 'winrm/config/Listener'
        SelectorSet = @{ Transport = "HTTPS"; Address = "*" }
        ValueSet    = @{ Hostname = $hostName; CertificateThumbprint = $serverCert.Thumbprint }
        # UseSSL = $true
    }
    $null = New-WSManInstance @newWsmanParams
}
```

8. Map the Client Certificate to the Local User Account

```
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $testUserAccountName, $testUserAccountPassword

## Find the cert thumbprint for the client certificate created on the Ansible host
$ansibleCert = Get-ChildItem -Path 'Cert:\LocalMachine\Root' | Where-Object {$_.Subject -eq 'CN=ansibletestuser'}

$params = @{
	Path = 'WSMan:\localhost\ClientCertificate'
	Subject = "$testUserAccountName@localhost"
	URI = '*'
	Issuer = $ansibleCert.Thumbprint
  Credential = $credential
	Force = $true
}
New-Item @params
```

9. Allow WinRm with User Account Control (UAC)

```
$newItemParams = @{
    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Name         = 'LocalAccountTokenFilterPolicy'
    Value        = 1
    PropertyType = 'DWORD'
    Force        = $true
}
$null = New-ItemProperty @newItemParams
```

10. Open Port 5986 on the Windows Firewall

```
 $ruleDisplayName = 'Windows Remote Management (HTTPS-In)'
 if (-not (Get-NetFirewallRule -DisplayName $ruleDisplayName -ErrorAction Ignore)) {
     $newRuleParams = @{
         DisplayName   = $ruleDisplayName
         Direction     = 'Inbound'
         LocalPort     = 5986
         RemoteAddress = 'Any'
         Protocol      = 'TCP'
         Action        = 'Allow'
         Enabled       = 'True'
         Group         = 'Windows Remote Management'
     }
     $null = New-NetFirewallRule @newRuleParams
 }
```

11. Add the local user to the administrators group

```
Get-LocalUser -Name $testUserAccountName | Add-LocalGroupMember -Group 'Administrators'
```

12. Wrap up

## OpenSSH for Windows

```
# Install OpenSSH with Chocolatey package manager
- name: Install the Win32-OpenSSH service
  win_chocolatey:
    name: openssh
    package_params: /SSHServerFeature
    state: present
```

```
# Make sure the role has been downloaded first
ansible-galaxy install jborean93.win_openssh

# main.yml
- name: Install Win32-OpenSSH service
  hosts: windows
  gather_facts: no
  roles:
  - role: jborean93.win_openssh
    opt_openssh_setup_service: True
```

```
- name: Set the default shell to PowerShell
  win_regedit:
    path: HKLM:\SOFTWARE\OpenSSH
    name: DefaultShell
    data: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    type: string
    state: present

# Or revert the settings back to the default, cmd
- name: Set the default shell to cmd
  win_regedit:
    path: HKLM:\SOFTWARE\OpenSSH
    name: DefaultShell
    state: absent
```
## Ansible Role Structure

``` mermaid
flowchart LR
  subgraph Role Workflow
    subgraph Foundations
      Node0[Common] --> Node1[WinDSC]
      Node1[WinDSC] --> Node2[WinModule]
      Node2[WinModule] --> Node3[Services]
      Node3[Services] --> Node4[Integration]
      Node4[Integrations] --> Node5[Application]
    end
  end

```

## Execution Workflow

## Ansible Tower Setup

## Desired State Attributes

- [ ] Install git
- [ ] Install chocolatey
- [ ] Install agents
- [ ] SMB1 removed
- [ ] Firewall defined
- [ ] Application installed and configured
- [ ] Remove extra software
- [ ] Setup scheduled updates

## WinModules

- [ ] Firewall rules
- [ ] Load Balancer Configured
- [ ] Windows cmd or PowerShell scripts ran
- [ ] PowerShell modules

## Configuration Files

## Services

## Application

## Closeout

