#================================================
#   OSDCloud Task Sequence
#   Windows 11 22H2 Enterprise en-us Retail
#   Autopilot
#   No Office Deployment Tool
#================================================
#   PreOS
#   Install and Import OSD Module
#================================================
$TLS12Protocol = [System.Net.SecurityProtocolType] 'Ssl3 , Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $TLS12Protocol
&certutil.exe -addstore -f -enterprise root X:\OSDCloud\Config\Scripts\StartNet\certadmin.cer | Out-Null
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
if ((Get-MyComputerManufacturer) -match 'Dell') {
Install-Module DellBIOSProvider -Force
$DellProviderPath = Split-Path -Path (Get-Module -ListAvailable DellBiosProvider).Path
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/msvcp140.dll" -OutFile "$DellProviderPath\msvcp140.dll" -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/vcruntime140.dll" -OutFile "$DellProviderPath\vcruntime140.dll" -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/vcruntime140_1.dll" -OutFile "$DellProviderPath\vcruntime140_1.dll" -ErrorAction SilentlyContinue
Import-Module DellBIOSProvider -Verbose
}
if ((Get-MyComputerManufacturer) -match 'HP') {
Install-Module -Name HPCMSL -AcceptLicense
Install-Module -Name HPCMSL -Force -AcceptLicense
}

if ((Get-MyComputerModel) -match 'Virtual|Vmware') {
    Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}
#================================================
#   [OS] Start-OSDCloud with Params
#================================================
$Params = @{
    OSVersion = "Windows 11"
    OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    SkipAutopilot = $false
    SkipODT = $true
    Firmware = $True
    ZTI = $True
}
Start-OSDCloud @Params
Start-EjectCD
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Install-EmbeddedProductKey.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Install-Updates.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Cleanup-Script.ps1

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\OOBE.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Install-EmbeddedProductKey.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Install-Updates.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Cleanup-Script.ps1
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
#$OOBECMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\OOBE.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host "Restarting in 10 seconds!" -ForegroundColor Green
Start-Sleep -Seconds 10
wpeutil reboot
