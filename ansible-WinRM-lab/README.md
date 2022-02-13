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
  subgraph ICS Handoff to Shared Services
    subgraph Foundations
      Node0[Common] --> Node1[ResourceGroup]
      Node1[ResourceGroup] --> Node2[VirtualNetwork]
      Node2[VirtualNetwork] --> Node3[Subnets]
      Node3[Subnets] --> Node4[NSG]
      Node4[NSG] --> Node5[StorageAccount]
    end
    
    subgraph Services
      Node5[StorageAccount] --> Node6[IaaS]
      Node5[StorageAccount] --> Node7[PaaS]
      Node6[IaaS] --> Node8[Services]
      Node7[PaaS] --> Node8[Services]
    end
  end
  
  subgraph Shared Services
    subgraph Applications 
      Node8[Services] -- CI/CD Pipeline --> Node9[Application]
      Node9[Application] --> Node10[Closeout]
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

## Configuration Files