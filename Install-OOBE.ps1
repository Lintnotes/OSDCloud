$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Install-OOBE.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

Write-Host -ForegroundColor Green "Running OOBE"
Set-ExecutionPolicy RemoteSigned -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module OSD -Force
Import-Module OSD -Force
Install-Module AutopilotOOBE -Force
Import-Module AutopilotOOBE -Force
Start-OOBEDeploy -AddNetFX3 -UpdateDrivers -UpdateWindows -SetEdition Enterprise -RemoveAppx "Microsoft.549981C3F5F10","Microsoft.GetHelp","Microsoft.Getstarted","Microsoft.Microsoft3DViewer","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.MixedReality.Portal","Microsoft.People","Microsoft.SkypeApp","Microsoft.Wallet","microsoft.windowscommunicationsapps","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.YourPhone","Microsoft.ZuneMusic","Microsoft.ZuneVideo"
Stop-Transcript
