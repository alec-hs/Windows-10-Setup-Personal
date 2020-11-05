# Currently tested and working on WIN10 x64 v20H2

# Set execution policy to allow online PS scripts for this session
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Install NuGet Package Manager
Install-PackageProvider -Name 'NuGet' -Force

# Set MS Powershell Gallery to trusted source
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# Install and import Windows Update moduel
Install-Module 'PSWindowsUpdate'
Import-Module 'PSWindowsUpdate'

# Get updates and install
$updates = Get-WindowsUpdate
do {
    Install-WindowsUpdate -AcceptAll -IgnoreReboot
    $updates = Get-WindowsUpdate
} until ($updates.count -eq 0)

# Add open PS as admin to Shift + Right Click Menu
reg import './reg-files/Open-PS-As-Admin-Shift-Right-Click.reg'

# Set Start Menu Layout to Empty
Copy-Item './LayoutModification.xml' C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\Shell -Force
Remove-Item -Force -Recurse -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store'

# Set File Explorer Options
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key 'Hidden' 1                    # Show hidden file
Set-ItemProperty $key 'HideFileExt' 0               # Show file extensions
Set-ItemProperty $key 'ShowCortanaButton' 0         # Hide Cortana button on taskbar
Set-ItemProperty $key 'LaunchTo' 1                  # Launch Explorer to "This PC"
Set-ItemProperty $key 'AutoCheckSelect' 1           # Show check boxes in explorer

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key 'SearchbocxTaskbarMode' 0     # Hide search box on taskbar

Stop-Process -processname explorer