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
    Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "$env:WINDIR\Temp\Microsoft.VCLibs.x64.14.00.Desktop.appx" -ErrorAction Stop
    Invoke-WebRequest -Uri "https://github.com/Lintnotes/OSDCloud/blob/main/Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx" -OutFile "$env:WINDIR\Temp\Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx" -ErrorAction Stop
    Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile $WingetInstaller -ErrorAction Stop 
    #Install WinGet MSIXBundle 
    Try 	{
        Write-Host "Installing MSIXBundle $WingetInstaller for App Installer..." 
        Add-AppxProvisionedPackage -Online -PackagePath $WingetInstaller -SkipLicense -DependencyPackagePath "$env:WINDIR\Temp\Microsoft.VCLibs.x64.14.00.Desktop.appx","$env:WINDIR\Temp\Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx"
        Write-Host "Installed MSIXBundle $WingetInstaller for App Installer" -ForegroundColor Green
        }
    Catch {
        Write-Host "Failed to install MSIXBundle $WingetInstaller for App Installer..." -ForegroundColor Red
        } 
    }
