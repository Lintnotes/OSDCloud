#==============================================================================================
# Title: OSD Branding 1.1
# Created: 12/16/2019
# Author: Brandon Linton
# Version: 1.1
#===================================== =========================================================

#==============================================================================================
# XAML Code - Imported from Visual Studio Express WPF Application
#==============================================================================================	

$xaml = @"
<Window x:Name="Window_OSDBranding" x:Class="OSDBranding.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:OSDBranding"
        mc:Ignorable="d"
        Title="OSD Branding" Topmost="False" WindowStartupLocation="CenterScreen" WindowState="Maximized" ResizeMode="NoResize" Width="Auto" Height="Auto" WindowStyle="None" SizeToContent="WidthAndHeight" ShowInTaskbar="False" d:DesignWidth="800" d:DesignHeight="600">
    <Grid DockPanel.Dock="Top">
        <Image x:Name="Image_OSDBackGround" Margin="0,0,10,0" VerticalAlignment="Center" HorizontalAlignment="Center" Width="Auto" Height="Auto" Source="X:\Windows\System32\winpe.jpg" Stretch="Fill"/>
        <ProgressBar x:Name="ProgressBar" Margin="0,0,0,225" VerticalAlignment="Bottom" HorizontalAlignment="Center" MinHeight="20" MinWidth="400" Visibility="Hidden" />
        <TextBlock x:Name="TextBlock_ProgressBar" FontWeight="Bold" FontSize="16" Margin="0,0,0,205" HorizontalAlignment="Center" VerticalAlignment="Bottom" Visibility="Hidden"/>
        <StackPanel x:Name="StackPanel" HorizontalAlignment="Right" Margin="0,0,1,63" VerticalAlignment="Bottom" Width="310">
            <TextBlock x:Name="TextBlock_HostName" TextWrapping="Wrap" Text="Host Name" FontWeight="Bold" FontSize="16" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_CPU" TextWrapping="Wrap" Text="CPU" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_Memory" TextWrapping="Wrap" Text="Memory" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_Empty" TextWrapping="Wrap" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_NetworkCard" TextWrapping="Wrap" Text="Network Card" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_Mac" TextWrapping="Wrap" Text="Mac" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_IP" TextWrapping="Wrap" Text="IP" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_DartID" TextWrapping="Wrap" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_StartTime" TextWrapping="Wrap" FontWeight="Bold" TextAlignment="Left"/>
            <TextBlock x:Name="TextBlock_ElapsedTime" TextWrapping="Wrap" FontWeight="Bold" TextAlignment="Left"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Format XAML
[xml]$xaml = $xaml -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window' -replace 'd:DesignWidth="800"','' -replace 'd:DesignHeight="600"',''
#Read XAML
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$UIReader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$UIWindow=[Windows.Markup.XamlReader]::Load($UIReader)}
catch{global:Write-LogEntry -Value "Error: Unable to load Windows.Markup.XamlReader:$($_.Exception.Message)" -Severity 3; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name "WPF$($_.Name)" -Value $UIWindow.FindName($_.Name)}

# Events

#===========================================================================
# Shows the form
#===========================================================================
$commonKeyEvents = {
    if (($_.Key -eq "Q" -and $_.KeyboardDevice.Modifiers -eq "Ctrl") -or
        ($_.Key -eq "ESC")) {            
        $this.Close()
        $App.Shutdown()
        Stop-Process -id $pid
    }
    If (($_.Key -eq "D" -and $_.KeyboardDevice.Modifiers -eq "Ctrl")){cscript.exe $PSScriptRoot\Launcher.vbs "Tools.ps1"}
}

Function Timer_Tick()
{
    $Script:OSDElapsedTime = (New-TimeSpan $OSDStartTime $(Get-Date)).ToString("hh\:mm\:ss")
    $WPFTextBlock_ElapsedTime.Text = "Elapsed Time: " + $OSDElapsedTime

}

###### ON Load Event
$UIWindow.Add_Loaded({

})

$UIWindow.Add_Closing({
    If ($TSEnvironment) { $TSEnvironment.Value("OSDElapsedTime") = "$($OSDElapsedTime)" }
    $Timer.Dispose()
    $ProgressBarTimer.Dispose()
    $App.Shutdown()
    Stop-Process -id $pid
})

$Host.UI.RawUI.WindowTitle = "OSD Branding"

$WPFTextBlock_HostName.Text = "Host Name: " + $env:COMPUTERNAME
$WPFTextBlock_CPU.Text = "CPU: " + (Get-WmiObject Win32_Processor).Name
$WPFTextBlock_Memory.Text = "Memory: " + (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb + "GB"
$WPFTextBlock_NetworkCard.Text = "NIC: " + (Get-WmiObject -class Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = True').Description
$WPFTextBlock_Mac.Text = "Mac: " + (Get-WmiObject -class Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = True').MacAddress
$WPFTextBlock_IP.Text = "IP: " + (Get-WmiObject -class Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = True').ipaddress[0]
If (Test-Path -Path HKLM:\Software\Microsoft\DaRT){
    $DaRTID = (Get-ItemProperty -Path HKLM:\Software\Microsoft\DaRT -Name ID).ID
    $WPFTextBlock_DartID.Text = "DaRT ID: $($DaRTID)"
}

$Instances = Get-WmiObject Win32_Process -Filter "Name='Powershell.exe' AND CommandLine LIKE '%OSDBranding.ps1%'"
Foreach ($Instance in $Instances){
    If($Instance.ProcessID -ne $PID){
        Write-Host "Warning: Previous Instance of $($Instance.CommandLine) Detected closing PID:$($Instance.ProcessID)"
        Stop-Process -Id $Instance.ProcessID -Force
    }
}

$OSDStartTime = Get-Date -Format g

$WPFTextBlock_StartTime.Text = "Start Time: " + $OSDStartTime

$Script:Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 1000
$Timer.Add_Tick({Timer_Tick})
$Timer.Start()

$UIWindow.Add_PreViewKeyDown($commonKeyEvents)
$App = [Windows.Application]::New()
$App.Run($UIWindow)
