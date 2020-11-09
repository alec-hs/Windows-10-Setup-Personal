# Get and Set location of setup script from last script
Set-Location $args[0]

# Check if PS Profile exists and create one if not
Write-Host 'Checking for or creating PS Profile...' `n
if (!(Test-Path -Path $Profile)) {
    New-Item -ItemType File -Path $Profile -Force
}

# Reload profile
.$Profile

# Set MS Powershell Gallery to trusted source
Write-Host 'Trusting MS Powershell Gallery...' `n
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# Install and import Windows Update moduel
Write-Host 'Installing Windows Update Module...' `n
Install-Module 'PSWindowsUpdate'

# Setup next phase for after reboot
$path = 'C:\Users\' + $env:UserName + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\phase-2.ps1'
$currentPath = Get-Location
$newLine = 'Set-Location ' + $currentPath
New-Item -Path $path -ItemType File -Value $newLine -Force
Add-Content -Path $path -Value (Get-Content './phase-2.ps1')

#Check if Windows 10 is 'N' version
$version = (Get-WmiObject -class Win32_OperatingSystem).Caption

#Install missing media pack
if ($version -match ' N') {
    Get-WindowsCapability -Online | Where-Object -Property Name -like "*media*" | Add-WindowsCapability -Online
}

# Get updates and install
do {
    $updateChoice = Read-Host -Prompt 'Would you like to run updates now? (y|n)'
} until ($updateChoice -eq 'y' -Or $updateChoice -eq 'n')

if ($updateChoice -eq 'y') {
    Write-Host `n 'Installing Windows Updates...' `n
    $updates = Get-WindowsUpdate
    do {
        Install-WindowsUpdate -AcceptAll
        $updates = Get-WindowsUpdate
    } until ($updates.count -eq 0)
}

