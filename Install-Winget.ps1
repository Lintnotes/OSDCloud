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
    $MSIXBundle = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $URL_msixbundle = "https://aka.ms/getwinget"
    $wc = New-Object net.webclient
    $wc.Downloadfile($URL_msixbundle, "$env:WINDIR\Temp\$MSIXBundle")
    Try 	{
        Write-Host "Installing MSIXBundle $WingetInstaller for App Installer..." 
        Add-AppxProvisionedPackage -Online -PackagePath $env:WINDIR\Temp\$MSIXBundle -SkipLicense
        Write-Host "Installed MSIXBundle $WingetInstaller for App Installer" -ForegroundColor Green
        }
    Catch {
        Write-Host "Failed to install MSIXBundle $WingetInstaller for App Installer..." -ForegroundColor Red
        } 
    }
