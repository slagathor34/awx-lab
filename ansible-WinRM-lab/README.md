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
- [ ] 

## Configuration Files