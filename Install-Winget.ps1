#Check Winget Install
If(!(Test-Path $env:WINDIR\Logs\Software)){New-Item $env:WINDIR\Logs\Software -ItemType Directory -Force}
$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Install-Winget.log"
Start-Transcript -Path (Join-Path "$env:WINDIR\Logs\Software\" $Global:Transcript) -ErrorAction Ignore
Write-Host "Checking if Winget is installed" -ForegroundColor Yellow
$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.DesktopAppInstaller"}
If ([Version]$TestWinGet. Version -gt "2022.506.16.0") 
{
    Write-Host "WinGet is Installed" -ForegroundColor Green
}Else 
    {
    #Download WinGet MSIXBundle
    Write-Host "Not installed. Downloading WinGet..." 
    $WingetInstaller = "$env:WINDIR\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $VCLibs = "$env:WINDIR\Temp\Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $Xaml = "$env:WINDIR\Temp\Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx"
    Invoke-WebRequest -Uri "https://github.com/Lintnotes/OSDCloud/blob/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_x64__8wekyb3d8bbwe.Appx" -OutFile $VCLibs -ErrorAction Stop
    Invoke-WebRequest -Uri "https://github.com/Lintnotes/OSDCloud/blob/main/Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx" -OutFile $Xaml -ErrorAction Stop
    Invoke-WebRequest -Uri "https://github.com/Lintnotes/OSDCloud/blob/main/Microsoft.DesktopAppInstaller_2023.118.406.0_neutral_~_8wekyb3d8bbwe.Msixbundle" -OutFile $WingetInstaller -ErrorAction Stop 
    #Install WinGet MSIXBundle 
    Try 	{
        Write-Host "Installing MSIXBundle $WingetInstaller for App Installer..." 
        Add-AppxProvisionedPackage -Online -PackagePath $WingetInstaller -DependencyPackagePath $VCLibs,$Xaml -SkipLicense
        Write-Host "Installed MSIXBundle $WingetInstaller for App Installer" -ForegroundColor Green
        }
    Catch {
        Write-Host "Failed to install MSIXBundle $WingetInstaller for App Installer..." -ForegroundColor Red
        } 
    }
