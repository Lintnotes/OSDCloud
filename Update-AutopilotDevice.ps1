$appid = 'd1a4a8cc-8737-4efb-b4d9-1de840060d0f'
$tenantid = 'aa90fdc2-6a50-4f3d-b4bd-7fe753d268aa'
$secret = '0qd8Q~y7OyIs4fCU5~hACBb40YY2G3LXfdYcWaTo'
 
$body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $appid
    Client_Secret = $secret
}
 
$connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
    -Method POST `
    -Body $body
 
$token = $connection.access_token
 
Connect-MgGraph -AccessToken $token


$Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AutoPilotDeviceUpdate.log"
$null = Start-Transcript -Path (Join-Path "$env:SystemRoot\Temp" $Transcript) -ErrorAction Ignore

$SerialNumber = (Get-WmiObject -Class Win32_Bios).SerialNumber
$DeviceID = Get-ItemPropertyValue HKLM:\SOFTWARE\Microsoft\Provisioning\Diagnostics\Autopilot\EstablishedCorrelations -Name EntDMID -ErrorAction SilentlyContinue
If(Test-Path $env:windir\Provisioning\Autopilot\AutoPilotConfigurationFile.json){
    $CorrectComputerName = (Get-Content $env:windir\Provisioning\Autopilot\AutoPilotConfigurationFile.json -raw | ConvertFrom-Json).CloudAssignedDeviceName
}
Else{
    $CorrectComputerName = $env:Computername
}


$AutopilotDeviceuri = 'https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities'
$AutopilotDevice = Invoke-MSGraphRequest -HttpMethod GET -Url $AutopilotDeviceuri | Get-MSGraphAllPages | Where-Object{$_.ManagedDeviceId -eq $DeviceID -or $_.serialNumber -eq $SerialNumber}

$ManagedDeviceuri = 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?$filter=startswith(operatingSystem,''Windows'')'
$ManagedDevice = Invoke-MSGraphRequest -HttpMethod GET -Url $ManagedDeviceuri | Get-MSGraphAllPages | Where-Object{$_.id -eq $DeviceID -or $_.id -eq $AutopilotDevice.managedDeviceId}

If($Null -eq $ManagedDevice){
    Write-Host "Azure AD Managed Device Not Found." -ForegroundColor Red
}
Else{
    If($ManagedDevice.deviceName -ne $CorrectComputerName){
        Write-Host "Azure AD Computername:$($ManagedDevice.deviceName) does not match $($CorrectComputerName) update required." -ForegroundColor Yellow
        $SetManagedDeviceNameUri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$($DeviceID)/setDeviceName"
        $ManagedDeviceNamePayload = @"
{
"deviceName":"$($CorrectComputerName)"
}
"@
        try {
            Invoke-MSGraphRequest -Url $SetManagedDeviceNameUri -HttpMethod POST -Content $ManagedDeviceNamePayload
        }
        catch {
            Write-Error $_.Exception 
            break
        }
    }
    Else{
        Write-Host "Azure AD Computername:$($ManagedDevice.deviceName) matches $($CorrectComputerName)." -ForegroundColor Green
    }
}

If($Null -eq $AutopilotDevice){
    Write-Host "Autopilot Device Not Found." -ForegroundColor Red
}
Else{
    If($AutopilotDevice.displayName -ne $CorrectComputerName){
        Write-Host "Autopilot Computername:$($AutopilotDevice.displayName) does not match $($CorrectComputerName) update required." -ForegroundColor Yellow
        $SetAutopilotDisplayNameUri = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/$($AutopilotDevice.id)/UpdateDeviceProperties"
        $AutopilotDeviceNamePayload = @"
{
"displayName":"$($CorrectComputerName)"
}
"@
        try {
            Invoke-MSGraphRequest -Url $SetAutopilotDisplayNameUri -HttpMethod POST -Content $AutopilotDeviceNamePayload
        }
        catch {
            Write-Error $_.Exception 
            break
        }
    }
    Else{
        Write-Host "Autopilot Computername:$($AutopilotDevice.displayName) matches $($CorrectComputerName)." -ForegroundColor Green
    }
}

If($AutopilotDevice -ne $Null){
    If($CorrectComputerName -match 'Zoom'){
        $GroupTag = "Kiosk-Zoom"
    }
    ElseIf($CorrectComputerName -match 'Sign'){
        $GroupTag = "Kiosk-Appspace"
    }
    Else{
        $GroupTag = "HubSpot-Production-Devices"
    }
    # Update Group Tag
    If($AutopilotDevice.GroupTag -ne $GroupTag){
        Write-Host "Autopilot groupTag:$($AutopilotDevice.GroupTag) does not match $($GroupTag) update required." -ForegroundColor Yellow
        $SetAutopilotGroupTagUri = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/$($AutopilotDevice.id)/UpdateDeviceProperties"
        $AutopilotDeviceTagPayload = @"
{
"groupTag":"$($GroupTag)"
}
"@
        try {
            Invoke-MSGraphRequest -Url $SetAutopilotGroupTagUri -HttpMethod POST -Content $AutopilotDeviceTagPayload
        }
        catch {
            Write-Error $_.Exception 
            break
        }
    }
}
Stop-Transcript
