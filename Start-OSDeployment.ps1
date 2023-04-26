#================================================
#   OSDCloud Task Sequence
#   Windows 10/11 22H2 Enterprise en-us Retail
#   Autopilot
#   No Office Deployment Tool
#================================================
#   PreOS
#   Install and Import OSD Module
#================================================
#Start the Transcript
$Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-OSDCloud.log"
$null = Start-Transcript -Path (Join-Path "$env:SystemRoot\Temp" $Transcript) -ErrorAction Ignore
#Script Information
$ScriptName = 'HubSpot Cloud OSD'
$ScriptVersion = '23.4.17.1'

#Determine the proper Windows environment
if ($env:SystemDrive -eq 'X:') { $WindowsPhase = 'WinPE' }
else {
    $ImageState = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore).ImageState
    if ($env:UserName -eq 'defaultuser0') { $WindowsPhase = 'OOBE' }
    elseif ($ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_OOBE') { $WindowsPhase = 'Specialize' }
    elseif ($ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT') { $WindowsPhase = 'AuditMode' }
    else { $WindowsPhase = 'Windows' }
}
#Finish initialization
Write-Host -ForegroundColor DarkGray "$ScriptName $ScriptVersion $WindowsPhase"

#=================================================
#region WinPE
if ($WindowsPhase -eq 'WinPE') {

    $TLS12Protocol = [System.Net.SecurityProtocolType] 'Ssl3 , Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $TLS12Protocol
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    if ((Get-MyComputerManufacturer) -match 'Dell') {
        $DellProviderPath = Split-Path -Path (Get-Module -ListAvailable DellBiosProvider).Path
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/msvcp140.dll" -OutFile "$DellProviderPath\msvcp140.dll" -ErrorAction SilentlyContinue
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/vcruntime140.dll" -OutFile "$DellProviderPath\vcruntime140.dll" -ErrorAction SilentlyContinue
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/ExtraFiles/vcruntime140_1.dll" -OutFile "$DellProviderPath\vcruntime140_1.dll" -ErrorAction SilentlyContinue
        Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Importing DellBiosProvider"
        Import-Module DellBIOSProvider
    }
    if ((Get-MyComputerManufacturer) -match 'HP') {
        Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Importing HPCMSL"
        Import-Module -Name HPCMSL -Force -AcceptLicense
    }
    if ((Get-MyComputerManufacturer) -match 'Lenovo') {
        Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Importing LSUClient"
        Import-Module -Name LSUClient -Force
    }

    if ((Get-MyComputerModel) -match 'Virtual|Vmware') {
        Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"
        Set-DisRes 1600
    }

    If (Test-Path $env:WINDIR\Temp\OSDVarsFile.txt) {
        $OSDVars = Get-Content -Raw -Path $env:WINDIR\Temp\OSDVarsFile.txt | ConvertFrom-StringData
    }
    $AssignedComputerName = $OSDVars.ComputerName
    Write-Host -ForegroundColor DarkGray "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Computername: $AssignedComputerName"

    #================================================
    #   Autopilot Configs
    #================================================
    $Production = @'
{
    "CloudAssignedTenantId":  "aa90fdc2-6a50-4f3d-b4bd-7fe753d268aa",
    "CloudAssignedDeviceName": "INT%SERIAL%",
    "CloudAssignedAutopilotUpdateTimeout":  1800000,
    "CloudAssignedAutopilotUpdateDisabled":  1,
    "CloudAssignedForcedEnrollment":  1,
    "Version":  2049,
    "Comment_File":  "Profile Hubspot Production Devices",
    "CloudAssignedAadServerData":  "{\"ZeroTouchConfig\":{\"CloudAssignedTenantUpn\":\"\",\"ForcedEnrollment\":1,\"CloudAssignedTenantDomain\":\"hubspotcorp.onmicrosoft.com\"}}",
    "CloudAssignedOobeConfig":  1310,
    "CloudAssignedDomainJoinMethod":  0,
    "ZtdCorrelationId":  "82349a82-5f14-4eb4-a77b-5c8648f3343c",
    "CloudAssignedLanguage":  "os-default",
    "CloudAssignedTenantDomain":  "hubspotcorp.onmicrosoft.com"
}
'@

    $Kiosks = @'
{
    "CloudAssignedTenantId":  "aa90fdc2-6a50-4f3d-b4bd-7fe753d268aa",
    "CloudAssignedDeviceName": "INT%SERIAL%",
    "CloudAssignedAutopilotUpdateTimeout":  1800000,
    "CloudAssignedAutopilotUpdateDisabled":  1,
    "CloudAssignedForcedEnrollment":  1,
    "Version":  2049,
    "Comment_File":  "Profile HubSpot Production Kiosk Devices",
    "CloudAssignedAadServerData":  "{\"ZeroTouchConfig\":{\"CloudAssignedTenantUpn\":\"\",\"ForcedEnrollment\":1,\"CloudAssignedTenantDomain\":\"hubspotcorp.onmicrosoft.com\"}}",
    "CloudAssignedOobeConfig":  1406,
    "CloudAssignedDomainJoinMethod":  0,
    "ZtdCorrelationId":  "6dcf7108-8c1d-415c-a27d-3506317657dc",
    "CloudAssignedLanguage":  "os-default",
    "CloudAssignedTenantDomain":  "hubspotcorp.onmicrosoft.com"
}
'@
    #================================================
    #   [OS] Start-OSDCloud with Params
    #================================================
    $Params = @{
        OSVersion     = $OSDVars.OperatingSystem
        OSBuild       = "22H2"
        OSEdition     = "Enterprise"
        OSLanguage    = $OSDVars.OperatingSystemLanguage
        OSLicense     = "Retail"
        SkipAutopilot = $True
        SkipODT       = $True
        Firmware      = $True
        ZTI           = $True
    }

    #=================================================
    #   oobeCloud Settings
    #=================================================
    $Global:oobeCloud = @{
        oobeSetDisplay               = $false
        oobeSetRegionLanguage        = $false
        oobeSetDateTime              = $false
        oobeRegisterAutopilot        = $true
        oobeRegisterAutopilotCommand = 'Get-WindowsAutopilotInfo -Online -GroupTag "Kiosk-Zoom" -Assign'
        oobeRemoveAppxPackage        = $false
        oobeRemoveAppxPackageName    = 'CommunicationsApps', 'OfficeHub', 'People', 'Skype', 'Solitaire', 'Xbox', 'ZuneMusic', 'ZuneVideo'
        oobeAddCapability            = $false
        oobeAddCapabilityName        = 'ActiveDirectory', 'BitLocker', 'GroupPolicy', 'RemoteDesktop', 'ServerManager', 'VolumeActivation', 'NetFX'
        oobeUpdateDrivers            = $true
        oobeUpdateWindows            = $true
        oobeRestartComputer          = $true
        oobeStopComputer             = $false
    }
    Start-OSDCloud @Params
    Start-EjectCD
    If ($OSDVars.AutoPilotConfig -eq 'Hubspot Production Devices') {
        $AutoPilotConfig = $Production.Replace('"INT%SERIAL%"', "`"$AssignedComputerName`"")
    }
    ElseIf($OSDVars.AutoPilotConfig -match 'zoom'){
            $AutoPilotConfig = $Kiosks.Replace('"INT%SERIAL%"', "`"$AssignedComputerName`"")
            $AutoPilotConfig = $AutoPilotConfig.Replace('"6dcf7108-8c1d-415c-a27d-3506317657dc"', '"Zoom-6dcf7108-8c1d-415c-a27d-3506317657dc"') 
    }
    ElseIf($OSDVars.AutoPilotConfig -match 'Appspace') {
            $AutoPilotConfig = $Kiosks.Replace('"INT%SERIAL%"', "`"$AssignedComputerName`"")
            $AutoPilotConfig = $AutoPilotConfig.Replace('"6dcf7108-8c1d-415c-a27d-3506317657dc"', '"Appspace-6dcf7108-8c1d-415c-a27d-3506317657dc"') 
    }
    Else{
        $AutoPilotConfig = $Null
    }

    If($Null -ne $AutoPilotConfig){
        $AutoPilotConfig  | Out-File C:\Windows\Provisioning\AutoPilot\AutoPilotConfigurationFile.json -Encoding ascii | Out-Null
    }
    iex (irm https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Update-AutopilotDevice.ps1)
    
    #================================================
    #  [PostOS] AutopilotOOBE CMD Command Line
    #================================================
    Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\OOBE.cmd"
    $OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Install-EmbeddedProductKey.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Cleanup-Script.ps1
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
    $OOBECMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\OOBE.cmd' -Encoding ascii -Force

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
    #Write-Host "Restarting in 10 seconds!" -ForegroundColor Green
    Start-Sleep -Seconds 5
    $null = Stop-Transcript -ErrorAction Ignore
    wpeutil reboot
}
#endregion
#=================================================
#region Specialize
if ($WindowsPhase -eq 'Specialize') {
    $null = Stop-Transcript -ErrorAction Ignore
}
#endregion
#=================================================
#region AuditMode
if ($WindowsPhase -eq 'AuditMode') {
    $null = Stop-Transcript -ErrorAction Ignore
}
#endregion
#=================================================
#region OOBE
if ($WindowsPhase -eq 'OOBE') {

    #Load everything needed to run AutoPilot and Azure KeyVault
    osdcloud-StartOOBE -Display -Language -DateTime -Autopilot -KeyVault

    #Get Autopilot information from the device
    $TestAutopilotProfile = osdcloud-TestAutopilotProfile

    #If the device has an Autopilot Profile
    if ($TestAutopilotProfile -eq $true) {
        #osdcloud-ShowAutopilotProfile
    }
    #If not, need to register the device using the Enterprise GroupTag and Assign it
    elseif ($TestAutopilotProfile -eq $false) {
        $AutopilotRegisterCommand = 'Get-WindowsAutopilotInfo -Online -GroupTag Enterprise -Assign'
        $AutopilotRegisterProcess = osdcloud-AutopilotRegisterCommand -Command $AutopilotRegisterCommand; Start-Sleep -Seconds 30
    }
    #Or maybe we just can't figure it out
    else {
        Write-Warning 'Unable to determine if device is Autopilot registered'
    }
    #osdcloud-RemoveAppx -Basic
    #osdcloud-Rsat -Basic
    osdcloud-NetFX
    osdcloud-UpdateDrivers
    osdcloud-UpdateWindows
    osdcloud-UpdateDefender
    if ($AutopilotRegisterProcess) {
        Write-Host -ForegroundColor Cyan 'Waiting for Autopilot Registration to complete'
        #$AutopilotRegisterProcess.WaitForExit()
        if (Get-Process -Id $AutopilotRegisterProcess.Id -ErrorAction Ignore) {
            Wait-Process -Id $AutopilotRegisterProcess.Id
        }
    }
    $null = Stop-Transcript -ErrorAction Ignore
    osdcloud-RestartComputer
}
#endregion
#=================================================
#region Windows
if ($WindowsPhase -eq 'Windows') {

    #Load OSD and Azure stuff
    osdcloud-SetExecutionPolicy
    osdcloud-InstallPackageManagement
    osdcloud-InstallModuleKeyVault
    osdcloud-InstallModuleOSD
    osdcloud-InstallModuleAzureAD
    $null = Stop-Transcript -ErrorAction Ignore
}
#endregion
#=================================================
