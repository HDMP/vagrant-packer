#-----------------------------------------------------Configure Server-----------------------------------------------------#

Get-WmiObject -Class Win32_UserAccount -Filter "name = 'vagrant'" | Set-WmiInstance -Arguments @{PasswordExpires = 0} #Set Password never expires for User 'vagrant'
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64 #Disable UAC
Get-WindowsFeature | ? { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove #Remove unnecessary Windows Features
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase #Run the DISM cleanup
Optimize-Volume -DriveLetter C #Laufwerk optimieren

#-----------------------------------------------------Install Software-----------------------------------------------------#

#Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#choco install firefox -y

#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
#Install-Module PSWindowsUpdate -Force

#Get-WUInstall -MicrosoftUpdate -AcceptAll

#-------------------------------------------------------RDP & WINRM-------------------------------------------------------#

#Enable Remote Desktop
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled True

#Enable WINRM
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
netsh advfirewall firewall set rule group="remote administration" new enable=yes
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
Enable-WSManCredSSP -Force -Role Server

Read-Host
#winrm set winrm/config/service '@{AllowUnencrypted="true"}'
#winrm set winrm/config/service/auth '@{Basic="true"}'
#winrm set winrm/config/client/auth '@{Basic="true"}'