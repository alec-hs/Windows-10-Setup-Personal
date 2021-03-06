Function Install-LGHub {
    # Manually install Logitech Gaming Hub
    Write-Output "Installing Logitech G HUB..." `n
    $url = "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"
    $path = ".\app-files\lghub_installer.exe"
    Start-BitsTransfer $url $path
    Start-Process $path -Wait
}

Function Install-WaveLink {
    # Manually install Elgato Wave Link
    Write-Output "Installing Elgato Wave Link..." `n
    $url = "https://edge.elgato.com/egc/windows/wavelink/1.1.6/WaveLink_1.1.6.2239_x64.msi"
    $path = ".\app-files\WaveLink_1.1.6.2239_x64.msi"
    Start-BitsTransfer $url $path
    Start-Process $path -Wait
}
Function Install-Gyazo {
    # Manually install Gyazo
    Write-Output "Installing Gyazo..." `n
    $url = "https://files.gyazo.com/setup/Gyazo-4.1.5.exe"
    $path = ".\app-files\Gyazo-4.1.5.exe"
    Start-BitsTransfer $url $path
    Start-Process $path -Wait
}

Function Install-NordPass {
    # Manually install NordPass
    Write-Output "Installing NordPass..." `n
    $url = "https://downloads.npass.app/windows/NordPassSetup.exe"
    $path = ".\app-files\NordPassSetup.exe"
    Start-BitsTransfer $url $path
    Start-Process $path -Wait
}

Function Install-ChoEazyCopy {
    # Manually install ChoEazyCopy
    Write-Output "Installing ChoEazyCopy..." `n
    $url = "https://github.com/Cinchoo/ChoEazyCopy/releases/latest/download/ChoEazyCopy.zip"
    $path = ".\app-files\ChoEazyCopy.zip"
    Start-BitsTransfer $url $path
    $installPath = "C:\Tools\"
    if (!(Test-Path $installPath)) {
        New-Item -ItemType Directory -Path $installPath -Force
    }
    Expand-Archive -LiteralPath $path -DestinationPath "$installPath\ChoEazyCopy"
}

Function Install-RyzenMaster {
    # Manually install RyzenMaster
    Write-Output "Installing RyzenMaster..." `n
    $url = "https://download.amd.com/Desktop/AMD-Ryzen-Master.exe"
    $path = ".\app-files\AMD-Ryzen-Master.exe"
    Start-BitsTransfer $url $path
    Start-Process $path -Wait
}

Function Set-PS7Default {
    # Set Powershell 7 to Default
    Write-Output "Setting PS7 as Default..." `n
    $key = "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command"
    Set-ItemProperty $key '(Default)' '"C:\Program Files\PowerShell\7\pwsh.exe" "%1"'
}

Function Install-WinGet {
    # Insall Winget Package Manager
    Write-Output "Installing WinGet Package Manager..." `n
    Add-AppxPackage -Path ".\app-files\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx"
    $url = 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
    $path = ".\app-files\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
    Start-BitsTransfer $url $path
    Add-AppxPackage -Path $path
}

Function Install-Choco {
    # Setup Chocolatey Package Manager
    Write-Output "Installing Chocolatey Package Manager..." `n
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Function Install-MyAppsChoco {
    # Update Choco Packages
    Write-Output "Updating Chocolatey Package List..." `n
    choco upgrade all -y

    # Install Apps using Chocolatey
    # GUI Package Manager
    Write-Output "Installing Chocolatey GUI..." `n
    choco install chocolateygui -y

    # Utility Apps
    Write-Output "Installing Utility Apps..." `n
    choco install aida64-extreme -y
    choco install scrcpy -y
    choco install hcloud -y
    choco install evga-precision-x1 -y
    choco install amd-ryzen-chipset -y

    # MS Office Apps
    Write-Output "Installing MS Office..." `n
    choco install microsoft-office-deployment -y -params '"/64bit /product:HomeBusiness2019Retail /exclude:""Access OneNote Publisher""'
    choco pin add -n=microsoft-office-deployment

    # Upgrade Choco Packages
    Write-Output "Updating Chocolatey Packages..." `n
    choco upgrade all -y
}

Function Install-MyAppsWinget {
    # Install Autoupdating Apps with WinGet
    Write-Output "Installing desktop apps..." `n

    # Install Utility Apps
    # -i : interative install for setting options
    winget install 'Microsoft Edge'
    winget install 'PowerToys'
    winget install '7zip'
    winget install 'TreeSize Free'
    winget install 'PuTTY'
    winget install 'Link Shell Extension'
    winget install 'WinSCP'
    winget install 'CPU-Z'
    winget install 'zerotier'
    winget install 'CrystalDiskInfo'
    winget install 'CrystalDiskMark'
    winget install 'Powershell' -i
    winget install 'Windows Terminal'
    winget install 'Google Chrome'
    winget install 'NordVPN'
    winget install 'Dropbox'
    winget install 'Rufus'
    winget install 'Slack'

    # Install Gaming Apps
    winget install 'Nvidia GeForce Experience'
    winget install 'Steam'
    winget install 'Ubisoft Connect'
    winget install 'Streamdeck'

    # Install Comms Apps
    winget install 'Teamspeak Client'
    winget install 'Discord'

    # Install Dev Apps
    winget install 'Visual Studio Code (System Installer - x64)' -i
    winget install 'Visual Studio Community'
    winget install 'Git' -i
    winget install 'gpg4win'
    winget install 'GitHub Desktop'
    winget install 'Python' -i
    winget install 'AzureDataStudio'
    winget install 'Amazon.AWSCLI'

    # Install Media Apps
    winget install 'Plex For Windows'
    winget install 'OBS Studio'
    winget install 'Audacity'
    winget install 'VLC'
    winget install 'Adobe.AdobeAcrobatReaderDC'
}

Function Remove-BloatApps {
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\"
    Set-ItemProperty $key "PreInstalledAppsEnabled" 0       # Remove Pre-Installed Apps
    Set-ItemProperty $key "OemPreInstalledAppsEnabled" 0    # Remove OEM Pre-Installed Apps

    # Uninstall MS Apps
    Write-Output "Uninstalling default Microsoft applications..."
    Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.AppConnector" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingFoodAndDrink" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingHealthAndFitness" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingMaps" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingTranslator" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingTravel" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.CommsPhone" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.ConnectivityStore" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.FreshPaint" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.GetHelp" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.HelpAndTips" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Media.PlayReadyClient.2" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Messaging" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Microsoft3DViewer" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftPowerBIForWindows" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MinecraftUWP" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MixedReality.Portal" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MoCamera" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.MSPaint" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.NetworkSpeedTest" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.OfficeLens" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Office.OneNote" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Office.Sway" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.OneConnect" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.People" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Print3D" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Reader" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.RemoteDesktop" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Todos" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Wallet" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WebMediaExtensions" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Whiteboard" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsAlarms" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
    Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Windows.Photos" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsReadingList" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsScan" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WinJS.1.0" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.WinJS.2.0" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage
    Get-AppxPackage "Microsoft.Advertising.Xaml" | Remove-AppxPackage

    # Remove 3rd Party Applications
    Write-Output "Uninstalling default third party applications..."
    Get-AppxPackage "2414FC7A.Viber" | Remove-AppxPackage
    Get-AppxPackage "41038Axilesoft.ACGMediaPlayer" | Remove-AppxPackage
    Get-AppxPackage "46928bounde.EclipseManager" | Remove-AppxPackage
    Get-AppxPackage "4DF9E0F8.Netflix" | Remove-AppxPackage
    Get-AppxPackage "64885BlueEdge.OneCalendar" | Remove-AppxPackage
    Get-AppxPackage "7EE7776C.LinkedInforWindows" | Remove-AppxPackage
    Get-AppxPackage "828B5831.HiddenCityMysteryofShadows" | Remove-AppxPackage
    Get-AppxPackage "89006A2E.AutodeskSketchBook" | Remove-AppxPackage
    Get-AppxPackage "9E2F88E3.Twitter" | Remove-AppxPackage
    Get-AppxPackage "A278AB0D.DisneyMagicKingdoms" | Remove-AppxPackage
    Get-AppxPackage "A278AB0D.DragonManiaLegends" | Remove-AppxPackage
    Get-AppxPackage "A278AB0D.MarchofEmpires" | Remove-AppxPackage
    Get-AppxPackage "ActiproSoftwareLLC.562882FEEB491" | Remove-AppxPackage
    Get-AppxPackage "AD2F1837.GettingStartedwithWindows8" | Remove-AppxPackage
    Get-AppxPackage "AD2F1837.HPJumpStart" | Remove-AppxPackage
    Get-AppxPackage "AD2F1837.HPRegistration" | Remove-AppxPackage
    Get-AppxPackage "AdobeSystemsIncorporated.AdobePhotoshopExpress" | Remove-AppxPackage
    Get-AppxPackage "Amazon.com.Amazon" | Remove-AppxPackage
    Get-AppxPackage "C27EB4BA.DropboxOEM" | Remove-AppxPackage
    Get-AppxPackage "CAF9E577.Plex" | Remove-AppxPackage
    Get-AppxPackage "CyberLinkCorp.hs.PowerMediaPlayer14forHPConsumerPC" | Remove-AppxPackage
    Get-AppxPackage "D52A8D61.FarmVille2CountryEscape" | Remove-AppxPackage
    Get-AppxPackage "D5EA27B7.Duolingo-LearnLanguagesforFree" | Remove-AppxPackage
    Get-AppxPackage "DB6EA5DB.CyberLinkMediaSuiteEssentials" | Remove-AppxPackage
    Get-AppxPackage "DolbyLaboratories.DolbyAccess" | Remove-AppxPackage
    Get-AppxPackage "Drawboard.DrawboardPDF" | Remove-AppxPackage
    Get-AppxPackage "Facebook.Facebook" | Remove-AppxPackage
    Get-AppxPackage "Fitbit.FitbitCoach" | Remove-AppxPackage
    Get-AppxPackage "flaregamesGmbH.RoyalRevolt2" | Remove-AppxPackage
    Get-AppxPackage "GAMELOFTSA.Asphalt8Airborne" | Remove-AppxPackage
    Get-AppxPackage "KeeperSecurityInc.Keeper" | Remove-AppxPackage
    Get-AppxPackage "king.com.BubbleWitch3Saga" | Remove-AppxPackage
    Get-AppxPackage "king.com.CandyCrushFriends" | Remove-AppxPackage
    Get-AppxPackage "king.com.CandyCrushSaga" | Remove-AppxPackage
    Get-AppxPackage "king.com.CandyCrushSodaSaga" | Remove-AppxPackage
    Get-AppxPackage "king.com.FarmHeroesSaga" | Remove-AppxPackage
    Get-AppxPackage "Nordcurrent.CookingFever" | Remove-AppxPackage
    Get-AppxPackage "PandoraMediaInc.29680B314EFC2" | Remove-AppxPackage
    Get-AppxPackage "PricelinePartnerNetwork.Booking.comBigsavingsonhot" | Remove-AppxPackage
    Get-AppxPackage "ThumbmunkeysLtd.PhototasticCollage" | Remove-AppxPackage
    Get-AppxPackage "WinZipComputing.WinZipUniversal" | Remove-AppxPackage
    Get-AppxPackage "XINGAG.XING" | Remove-AppxPackage
}