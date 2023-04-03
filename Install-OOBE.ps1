$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Install-OOBE.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

Write-Host -ForegroundColor Green "Running OOBE"
Set-ExecutionPolicy RemoteSigned -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module AutopilotOOBE -Force -Verbose
Install-Module OSD -Force -Verbose
Start-OOBEDeploy

Stop-Transcript
