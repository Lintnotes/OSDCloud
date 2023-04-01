#================================================
#   OSDCloud Task Sequence
#   Windows 10 22H2 Enterprise en-us Retail
#   Autopilot
#   No Office Deployment Tool
#================================================
#   PreOS
#   Install and Import OSD Module
#================================================
&certutil.exe -addstore -f -enterprise root X:\OSDCloud\Config\Scripts\StartNet\certadmin.cer
Install-Module OSD -Force
Import-Module OSD -Force

if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}
#================================================
#   [OS] Start-OSDCloud with Params
#================================================
$Params = @{
    OSVersion = "Windows 10"
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
#================================================
#   WinPE PostOS Sample
#   AutopilotOOBE Offline Staging
#================================================
&certutil.exe -addstore -f -enterprise root X:\OSDCloud\Config\Scripts\StartNet\certadmin.cer
Install-Module AutopilotOOBE -Force
Import-Module AutopilotOOBE -Force

$Params = @{
    Title = 'Intune Manual Autopilot Registration'
    GroupTag = 'Enterprise'
    GroupTagOptions = 'Development','Enterprise'
    Hidden = 'AddToGroup','AssignedComputerName','AssignedUser','PostAction'
    Assign = $true
    Run = 'NetworkingWireless'
    Docs = 'https://autopilotoobe.osdeploy.com/'
}
AutopilotOOBE @Params
#================================================
#   WinPE PostOS Sample
#   OOBEDeploy Offline Staging
#================================================
$Params = @{
    Autopilot = $true
    RemoveAppx = "CommunicationsApps","OfficeHub","People","Skype","Solitaire","Xbox","ZuneMusic","ZuneVideo"
    UpdateDrivers = $true
    UpdateWindows = $true
    AddNetFX3 = $true
}
Start-OOBEDeploy @Params
#================================================
#   WinPE PostOS
#   Set OOBEDeploy CMD.ps1
#================================================
$SetCommand = @'
@echo off
:: Set the PowerShell Execution Policy
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
:: Add PowerShell Scripts to the Path
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
:: Open and Minimize a PowerShell instance just in case
start PowerShell -NoL -W Mi
:: Install the latest OSD Module
start "Install-Module OSD" /wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
:: Start-OOBEDeploy
:: There are multiple example lines. Make sure only one is uncommented
:: The next line assumes that you have a configuration saved in C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json
start "Start-OOBEDeploy" PowerShell -NoL -C Start-OOBEDeploy
:: The next line assumes that you do not have a configuration saved in or want to ensure that these are applied
REM start "Start-OOBEDeploy" PowerShell -NoL -C Start-OOBEDeploy -AddNetFX3 -UpdateDrivers -UpdateWindows
exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\OOBEDeploy.cmd" -Encoding ascii -Force
#================================================
#   WinPE PostOS
#   Set AutopilotOOBE CMD.ps1
#================================================
$SetCommand = @'
@echo off
:: Set the PowerShell Execution Policy
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
:: Add PowerShell Scripts to the Path
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
:: Open and Minimize a PowerShell instance just in case
start PowerShell -NoL -W Mi
:: Install the latest AutopilotOOBE Module
start "Install-Module AutopilotOOBE" /wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
:: Start-AutopilotOOBE
:: There are multiple example lines. Make sure only one is uncommented
:: The next line assumes that you have a configuration saved in C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json
start "Start-AutopilotOOBE" PowerShell -NoL -C Start-AutopilotOOBE
:: The next line is how you would apply a CustomProfile
REM start "Start-AutopilotOOBE" PowerShell -NoL -C Start-AutopilotOOBE -CustomProfile OSDeploy
:: The next line is how you would configure everything from the command line
REM start "Start-AutopilotOOBE" PowerShell -NoL -C Start-AutopilotOOBE -Title 'OSDeploy Autopilot Registration' -GroupTag Enterprise -GroupTagOptions Development,Enterprise -Assign
exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\Autopilot.cmd" -Encoding ascii -Force
#================================================
#   PostOS
#   Restart-Computer
#================================================
Restart-Computer
