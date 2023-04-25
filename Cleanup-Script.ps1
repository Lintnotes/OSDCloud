$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Cleanup-Script.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

Write-Host "Execute OSD Cloud Cleanup Script" -ForegroundColor Green

# Copying the OOBEDeploy and AutopilotOOBE Logs
Get-ChildItem 'C:\Windows\Temp' -Filter *OOBE* | Copy-Item -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Recurse -Force

# Copying OSDCloud Logs
If (Test-Path -Path 'C:\OSDCloud\Logs') {
    Move-Item 'C:\OSDCloud\Logs\*.*' -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Recurse -Force
}
Move-Item 'C:\ProgramData\OSDeploy\*.*' -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Recurse -Force

If (Test-Path -Path 'C:\Temp') {
    Get-ChildItem 'C:\Temp' -Filter *OOBE* | Copy-Item -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Recurse -Force
    Get-ChildItem 'C:\Windows\Temp' -Filter *Events* | Copy-Item -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Recurse -Force
}

# Cleanup directories
If (Test-Path -Path 'C:\OSDCloud') { Remove-Item -Path 'C:\OSDCloud' -Recurse -Force }
If (Test-Path -Path 'C:\Drivers') { Remove-Item 'C:\Drivers' -Recurse -Force }
If (Test-Path -Path 'C:\Temp') { Remove-Item 'C:\Temp' -Recurse -Force }

$EnrollmentID = ((Get-Childitem 'HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\').Name).Split('\')[-1]

$DeviceLockKeys = @(
'HKLM:\SYSTEM\CurrentControlSet\Control\EAS'
"HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\$EnrollmentID\default\Device\DeviceLock"
'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\DeviceLock'
)

ForEach ($Key in $DeviceLockKeys) {
    Remove-Item $Key -Force -ErrorAction Continue
}

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
$Process.ExitCode

If($env:Computername -match 'Zoom|Sign'){
    $RegKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
    New-ItemProperty -Path $RegKeyPath -Name "Enabled" -Value "0" -PropertyType DWORD -Force | Out-Null
}



Stop-Transcript
