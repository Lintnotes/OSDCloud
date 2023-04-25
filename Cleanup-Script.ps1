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

Stop-Transcript
