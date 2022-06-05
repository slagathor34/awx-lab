$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -DisableBasicAuth -EnableCredSSP

New-SelfSignedCertificate -Subject 'CN=winlab.brainstormes.org' -TextExtension '2.5.29.37={text}1.3.6.1.5.5.7.3.1'
winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="winlab.brainstormes.org"; CertificateThumbprint="1ED978965ACCEA32C6587CA467D8BFAFFC27E8E6"}'
winrm 
New-NetFirewallRule –DisplayName "Windows Remote Management (HTTPS-In)" –Name "Windows Remote Management (HTTPS-In)" –Profile Any –LocalPort 5986 –Protocol TCP
New-NetFirewallRule –DisplayName "RemotePowerShell" –Direction Inbound –LocalPort 5985–5986 –Protocol TCP –Action Allow
Enable-WSManCredSSP -Role Server
winrm enumerate winrm/config/listener
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint "<thumbprint>" -Force
Get-Item -Path WSMan:\localhost\Listener
winrm quickconfig -transport:https
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
New-Item -Path WSMan:\localhost\Listener -Transport HTTP -Address * -Force 
