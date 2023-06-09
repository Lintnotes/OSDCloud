$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Cleanup-Script.log"
Start-Transcript -Path (Join-Path "$env:WINDIR\Temp\" $Global:Transcript) -ErrorAction Ignore

Write-Host "Execute OSD Cloud Cleanup Script" -ForegroundColor Green

If(Test-Path $env:windir\Provisioning\Autopilot\AutoPilotConfigurationFile.json){
    $CorrectComputerName = (Get-Content $env:windir\Provisioning\Autopilot\AutoPilotConfigurationFile.json -raw | ConvertFrom-Json).CloudAssignedDeviceName
}
Else{
    $CorrectComputerName = $env:Computername
}
If($env:computername -ne $CorrectComputerName){
    Write-Host "Renaming Computer:$env:computername to $CorrectComputerName"
    Rename-Computer -Computername $env:computername -NewName $CorrectComputerName -Force
}


# Copying OSDCloud Logs
If (Test-Path -Path 'C:\OSDCloud\Logs') {
    Move-Item 'C:\OSDCloud\Logs\*.*' -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Force
}

# Cleanup directories
If (Test-Path -Path 'C:\OSDCloud') { Remove-Item -Path 'C:\OSDCloud' -Recurse -Force }
If (Test-Path -Path 'C:\Drivers') { Remove-Item 'C:\Drivers' -Recurse -Force }
If (Test-Path -Path 'C:\Temp') { Remove-Item 'C:\Temp' -Recurse -Force }

$Inf = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[System Access]
MinimumPasswordAge = 0
MaximumPasswordAge = 720
MinimumPasswordLength = 12
PasswordComplexity = 1
PasswordHistorySize = 24
LockoutBadCount = 10
ResetLockoutCount = 5
LockoutDuration = 5
RequireLogonToChangePassword = 0
ForceLogoffWhenHourExpire = 0
"@
 
$Null = New-Item -Path "$Env:SystemRoot\security\database" -Name SecPolicy.inf -ItemType File -Value $Inf -Force
$Process = Start-Process -FilePath Secedit.exe -ArgumentList "/configure /db secedit.sdb /cfg $env:SystemRoot\Security\Database\SecPolicy.inf /overwrite /quiet" -NoNewWindow -PassThru -Wait

If($env:Computername -match 'Zoom|Sign'){
    $RegKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
    If(!(Test-Path $RegKeyPath)){New-Item $RegKeyPath | Out-Null}
    New-ItemProperty -Path $RegKeyPath -Name "Enabled" -Value "0" -PropertyType DWORD -Force | Out-Null
}

Stop-Transcript
