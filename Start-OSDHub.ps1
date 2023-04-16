Add-Type -AssemblyName System.Windows.Forms

$xaml = @"
<Window x:Class="HubSpotOSDGUI.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:HubSpotOSDGUI"
        mc:Ignorable="d"
        BorderThickness="0"
        RenderTransformOrigin="0.5,0.5"
        ResizeMode="NoResize"
        WindowStartupLocation = "CenterScreen"
        Title="Hubspot OSD" Height="380" Width="820">
    <Window.Resources>
        <ResourceDictionary>
            <Style TargetType="{x:Type Button}">
                <Setter Property="Background"
                        Value="{DynamicResource FlatButtonBackgroundBrush}" />
                <Setter Property="BorderThickness"
                        Value="0" />
                <Setter Property="FontSize"
                        Value="{DynamicResource FlatButtonFontSize}" />
                <Setter Property="Foreground"
                        Value="{DynamicResource FlatButtonForegroundBrush}" />
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="{x:Type Button}">
                            <Border x:Name="Border"
                                    Margin="0"
                                    Background="{TemplateBinding Background}"
                                    BorderBrush="{TemplateBinding BorderBrush}"
                                    CornerRadius="5"
                                    BorderThickness="{TemplateBinding BorderThickness}"
                                    SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                                <ContentPresenter x:Name="ContentPresenter"
                                                  ContentTemplate="{TemplateBinding ContentTemplate}"
                                                  Content="{TemplateBinding Content}"
                                                  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
                                                  Margin="{TemplateBinding Padding}"
                                                  VerticalAlignment="{TemplateBinding VerticalContentAlignment}" />
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
                <Style.Triggers>
                    <Trigger Property="IsMouseOver"
                             Value="True">
                        <!-- Windows 11 Theme Dark Blue -->
                        <Setter Property="Background"
                                Value="#0096D6" />
                    </Trigger>
                    <Trigger Property="IsMouseOver"
                             Value="False">
                        <!-- Windows 11 Theme Blue -->
                        <Setter Property="Background"
                                Value="#0067C0" />
                    </Trigger>
                    <Trigger Property="IsPressed"
                             Value="True">
                        <Setter Property="Background"
                                Value="{DynamicResource FlatButtonPressedBackgroundBrush}" />
                        <Setter Property="Foreground"
                                Value="{DynamicResource FlatButtonPressedForegroundBrush}" />
                    </Trigger>
                    <Trigger Property="IsEnabled"
                             Value="False">
                        <Setter Property="Foreground"
                                Value="{DynamicResource GrayBrush2}" />
                    </Trigger>
                </Style.Triggers>
            </Style>
            <Style TargetType="{x:Type ComboBox}">
                <Setter Property="FontFamily"
                        Value="Segoe UI" />
            </Style>
            <Style TargetType="{x:Type Label}">
                <Setter Property="FontFamily"
                        Value="Segoe UI" />
            </Style>
            <Style TargetType="{x:Type TextBox}">
                <Setter Property="FontFamily"
                        Value="Segoe UI" />
            </Style>
            <Style TargetType="{x:Type Window}">
                <Setter Property="FontFamily"
                        Value="Segoe UI" />
                <Setter Property="FontSize"
                        Value="16" />
                <Setter Property="Background"
                        Value="White" />
                <Setter Property="Foreground"
                        Value="Black" />
            </Style>
        </ResourceDictionary>
    </Window.Resources>
    <Window.Background>
        <RadialGradientBrush GradientOrigin="0.2,0.2"
                             Center="0.4,0.1"
                             RadiusX="0.7"
                             RadiusY="0.8">
            <RadialGradientBrush.RelativeTransform>
                <TransformGroup>
                    <ScaleTransform CenterY="0.5"
                                    CenterX="0.5" />
                    <SkewTransform CenterY="0.5"
                                   CenterX="0.5" />
                    <RotateTransform Angle="-40.601"
                                     CenterY="0.5"
                                     CenterX="0.5" />
                    <TranslateTransform />
                </TransformGroup>
            </RadialGradientBrush.RelativeTransform>
            <GradientStop Color="White" />
            <GradientStop Color="#FFF9FFFE"
                          Offset="0.056" />
            <GradientStop Color="#FFF8FEFF"
                          Offset="0.776" />
            <GradientStop Color="#FFF4FAFF"
                          Offset="0.264" />
            <GradientStop Color="White"
                          Offset="0.506" />
            <GradientStop Color="AliceBlue"
                          Offset="1" />
        </RadialGradientBrush>
    </Window.Background>
    <DockPanel>
    <Grid Margin="10,0,10,10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="1" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="1" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="1" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="*" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>

        <!-- Row 0 Title -->
        <Label Grid.Row="0"
               Name="BrandingTitleControl"
               Content="Hubspot IT"
               FlowDirection="RightToLeft"
               FontSize="24"
               FontWeight="Bold"
               Foreground="#0096D6"
               HorizontalAlignment="Right"
               VerticalAlignment="Top" />

        <!-- Row 1 Gridline -->
        <Line Grid.Row="1"
              X1="0"
              Y1="0"
              X2="1"
              Y2="0"
              Stroke="Gainsboro"
              StrokeThickness="1"
              Stretch="Uniform"></Line>

        <!-- Row 2 OperatingSystem -->
        <StackPanel Grid.Row="2"
                    HorizontalAlignment="Left"
                    VerticalAlignment="Top">
            <!-- Operating System -->
            <StackPanel Orientation="Horizontal"
                        HorizontalAlignment="Left"
                        VerticalAlignment="Top">
                <Label Name="OperatingSystemLabel"
                       Content="Operating System"
                       FontSize="18"
                       FontWeight="Bold"
                       Foreground="#0096D6"
                       Margin="5"
                       Padding="2"
                       Width="155"
                       FlowDirection="RightToLeft" />
                <ComboBox Name="OSNameCombobox"
                          FontSize="16"
                          Margin="5"
                          Padding="2" >
                </ComboBox>
            </StackPanel>
            <StackPanel Orientation="Horizontal"
                        HorizontalAlignment="Left"
                        VerticalAlignment="Top">
                <Label Name="OperatingSystemDetailsLabel"
                       Content="OS Language"
                       FontSize="18"
                       FontWeight="Bold"
                       Foreground="#0096D6"
                       Margin="5"
                       Padding="2"
                       Width="155" />
                <ComboBox Name="OSLanguageCombobox"
                          FontSize="16"
                          Margin="5"
                          Padding="2" />
            </StackPanel>
            <StackPanel HorizontalAlignment="Left"
                        VerticalAlignment="Top">
            </StackPanel>
        </StackPanel>

        <!-- Row 3 Gridline -->
        <Line Grid.Row="3"
              X1="0"
              Y1="0"
              X2="1"
              Y2="0"
              Stroke="Gainsboro"
              StrokeThickness="1"
              Stretch="Uniform">
        </Line>

        <!-- Row 5 Gridline -->
        <Line Grid.Row="5"
              X1="0"
              Y1="0"
              X2="1"
              Y2="0"
              Stroke="Gainsboro"
              StrokeThickness="1"
              Stretch="Uniform">
        </Line>

        <!-- Row 6 Options -->
        <StackPanel Grid.Row="6"
                    HorizontalAlignment="Left"
                    VerticalAlignment="Top">
            <!-- AutopilotJson -->
            <StackPanel Orientation="Horizontal"
                        HorizontalAlignment="Left"
                        VerticalAlignment="Top">
                <Label Name="AutopilotJsonLabel"
                       Content="Autopilot Config"
                       FontSize="18"
                       FontWeight="Bold"
                       Foreground="#0096D6"
                       HorizontalAlignment="Left"
                       Margin="5"
                       Padding="2"
                       Width="155" />
                <ComboBox Name="AutopilotJsonCombobox"
                          FontSize="16"
                          Margin="5"
                          Padding="2" />
            </StackPanel>
        </StackPanel>

        <!-- Row 7 Options -->
        <StackPanel Grid.Row="7"
                    HorizontalAlignment="Left"
                    VerticalAlignment="Top">
            <!-- AutopilotJson -->
            <StackPanel Orientation="Horizontal"
                        HorizontalAlignment="Left"
                        VerticalAlignment="Top">
                <Label Name="ComputerNameLabel"
                       Content="Computer Name"
                       FontSize="18"
                       FontWeight="Bold"
                       Foreground="#0096D6"
                       HorizontalAlignment="Left"
                       Margin="5"
                       Padding="2"
                       Width="155" />
                <TextBox Name="ComputerNameTextBox"
                          FontSize="16"
                          Margin="5"
                          MaxLength="15" 
                          CharacterCasing="Upper"
                          Width="155"
                          Padding="2" />
            </StackPanel>
        </StackPanel>
        
        <!-- Row 8 Start -->
        <Button Grid.Row="8"
                Name="StartButton"
                Content="Start"
                FontSize="18"
                Foreground="White"
                Height="40"
                Width="130"
                HorizontalAlignment="Right"
                VerticalAlignment="Bottom" />
        </Grid>
    </DockPanel>
</Window>
"@

# Format XAML
[xml]$xaml = $xaml -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
#Read XAML
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$UIReader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$UIWindow=[Windows.Markup.XamlReader]::Load($UIReader)}
catch{Write-Host "Error: Unable to load Windows.Markup.XamlReader:$($_.Exception.Message)"; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name "WPF$($_.Name)" -Value $UIWindow.FindName($_.Name)}

Function Global:Get-FormVariables{
    if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
    write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
}
#Get-FormVariables

Function Global:Get-DeviceInfo{

Add-Type @"
using System.Runtime.InteropServices;
namespace WinAPI
{
    public class User32 {
        [DllImport("user32.dll")] public static extern int GetSystemMetrics(int nIndex);
    }
}
"@

[boolean]$IsTouch = [boolean](([WinAPI.User32]::GetSystemMetrics(86)) -band 0x41 -eq 0x41)

$CIMSystemEnclosure = Get-CimInstance Win32_SystemEnclosure -ErrorAction Stop
$CIMComputerSystem = Get-CimInstance CIM_ComputerSystem -ErrorAction Stop
$CIMOperatingSystem = Get-CimInstance CIM_OperatingSystem -ErrorAction Stop
$CIMNetworkAdapter = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $True} -ErrorAction Stop
$CIMTPM = Get-CimInstance -Namespace 'root\CIMV2\Security\MicrosoftTPM' -ClassName Win32_TPM -ErrorAction Stop
$CIMBios = Get-CimInstance Win32_BIOS -ErrorAction Stop
$CIMProc = Get-CimInstance Win32_Processor -ErrorAction Stop

#Compile Machine Name
Switch ($CIMSystemEnclosure.ChassisTypes)
    {
        "1" {$Type = "Other";$ChassisIdentifier = ""}
        "2" {$Type = "Virtual Machine";$ChassisIdentifier = "V"}
        "3" {$Type = "Desktop";$ChassisIdentifier = "D"}
        "4" {$type = "Low Profile Desktop";$ChassisIdentifier = "D"}
        "5" {$type = "Pizza Box";$ChassisIdentifier = "S"}
        "6" {$type = "Mini Tower";$ChassisIdentifier = "D"}
        "7" {$type = "Tower";$ChassisIdentifier = "D"}
        "8" {$type = "Portable";$ChassisIdentifier = "L"}
        "9" {$type = "Laptop";$ChassisIdentifier = "L"}
        "10" {$type = "Notebook";$ChassisIdentifier = "L"}
        "11" {$type = "Handheld";$ChassisIdentifier = "T"}
        "12" {$type = "Docking Station";$ChassisIdentifier = "L"}
        "13" {$type = "All-in-One";$ChassisIdentifier = "D"}
        "14" {$type = "Sub-Notebook";$ChassisIdentifier = "L"}
        "15" {$type = "Space Saving";$ChassisIdentifier = "S"}
        "16" {$type = "Lunch Box";$ChassisIdentifier = "S"}
        "17" {$type = "Main System Chassis";$ChassisIdentifier = "S"}
        "18" {$type = "Expansion Chassis";$ChassisIdentifier = "S"}
        "19" {$type = "Sub-Chassis";$ChassisIdentifier = "S"}
        "20" {$type = "Bus Expansion Chassis";$ChassisIdentifier = "S"}
        "21" {$type = "Peripheral Chassis";$ChassisIdentifier = "S"}
        "22" {$type = "Storage Chassis";$ChassisIdentifier = "S"}
        "23" {$type = "Rack Mount Chassis";$ChassisIdentifier = "S"}
        "24" {$type = "Sealed-Case PC";$ChassisIdentifier = "D"}
        "25" {$type = "Multi-system chassis";$ChassisIdentifier = "S"}
        "26" {$type = "Compact PCI";$ChassisIdentifier = "S"}
        "27" {$type = "Advanced";$ChassisIdentifier = "S"}
        "28" {$type = "Blade";$ChassisIdentifier = "S"}
        "29" {$type = "Blade Enclosure";$ChassisIdentifier = "S"}
        "30" {$type = "Tablet";$ChassisIdentifier = "T"}
        "31" {$type = "Convertible";$ChassisIdentifier = "T"}
        "32" {$type = "Detachable";$ChassisIdentifier = "T"}
        "33" {$type = "IoT Gateway";$ChassisIdentifier = "I"}
        "34" {$type = "Embedded PC";$ChassisIdentifier = "I"}
        "35" {$type = "Mini PC";$ChassisIdentifier = "D"}
        "36" {$type = "Stick PC";$ChassisIdentifier = "D"}
        Default {$type = "Unknown";$ChassisIdentifier = "L"}
    }

If ($CIMBios.Version -match 'VRTUAL' -or $CIMBios.Version -match 'VMware' -or $CIMComputerSystem.Manufacturer -Match 'Vmware' -or $CIMComputerSystem.Manufacturer -match 'Google' -or $CIMComputerSystem.Manufacturer -match 'Amazon' -or $CIMComputerSystem.Manufacturer -match 'QEUMU' -or $CIMComputerSystem.Manufacturer -match 'Xen') { $ChassisIdentifier = 'V' }
If($IsTouch -eq $True){
    $ChassisIdentifier = 'T'
}

[boolean]$Is64Bit = [boolean](($CIMProc | Where-Object {$_.DeviceID -eq 'CPU0'} | Select-object -ExpandProperty 'AddressWidth') -eq 64)
If($Is64Bit){[string]$OsArchitecture = '64-bit'}else {[string]$OsArchitecture = '32-bit'}

[boolean]$IsSecureBootEnabled = [boolean]((Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\SecureBoot\State' -Name UEFISecureBootEnabled -ea SilentlyContinue).UEFISecureBootEnabled -eq 1)

If($CIMTPM)
{
    [boolean]$TPMPresent = $True
    If($CIMTPM.SpecVersion -match '2.0'){[string]$TPMSpecVersion = '2.0'}else{[string]$TPMSpecVersion = '1.2'}
    If($CIMTPM.IsActivated_InitialValue -eq $True -and $CIMTPM.IsEnabled_InitialValue -eq $True){[boolean]$TPMEnabledActivated = $True}else{[boolean]$TPMEnabledActivated = $False}
}
Else{
        [boolean]$TPMPresent = $False
        [string]$TPMSpecVersion = '0.0'
        [boolean]$TPMEnabledActivated = $False
}

[PSCustomObject] @{
    "Manufacturer" = $CIMComputerSystem.Manufacturer;
    "Model" = $CIMComputerSystem.Model;
    "MemoryGB" = $CIMComputerSystem.TotalPhysicalMemory/1GB -as [int]
    "Architecture" = $OsArchitecture;
    "AssetTag" = $CIMSystemEnclosure.SMBIOSAssetTag;
    "SerialNumber" = $CIMBios.SerialNumber -replace "\W", "" -replace "VMware","";
    "BiosVersion" = $CIMBios.SMBIOSBIOSVersion;
    "Chassis" = $Type
    "ChassisIdentifier" = $ChassisIdentifier;
    "VirtualFirmware" = $CIMProc.VirtualizationFirmwareEnabled[0];
    "IPAddress" = ($CIMNetworkAdapter | Where-Object {$_.DefaultIPGateway -ne "0.0.0.0" -and $null -ne $_.DefaultIPGateway} | Select-Object IPAddress).IPAddress[0];
    "MacAddress" = ($CIMNetworkAdapter | Where-Object {$_.DefaultIPGateway -ne "0.0.0.0" -and $null -ne $_.DefaultIPGateway} | Select-Object MACAddress).MACAddress;
    "NetworkAdapter" = ($CIMNetworkAdapter | Where-Object {$_.DefaultIPGateway -ne "0.0.0.0" -and $null -ne $_.DefaultIPGateway} | Select-Object Description).Description;
    "TPM" = $TPMPresent;
    "TPMVersion" = $TPMSpecVersion;
    "TPMReady" = $TPMEnabledActivated;
    "SecureBoot" = $IsSecureBootEnabled;
    "BiosFirmwareType" = $env:Firmware_Type
    "IsTouch" = $IsTouch
    }
}

#Default Variables
$DeviceInfo = Get-DeviceInfo
$WPFOSNameCombobox.SelectedItem = "Windows 10"
$WPFOSLanguageCombobox.SelectedItem = "en-us"
$WPFAutopilotJsonCombobox.SelectedItem = "Hubspot Production Devices"
$WPFComputerNameTextBox.Text = "INT" + $DeviceInfo.SerialNumber.SubString($DeviceInfo.SerialNumber.Length - 7).ToUpper()
"Windows 10","Windows 11" | ForEach-Object { $WPFOSNameCombobox.Items.Add($_)} | Out-Null
'ar-sa','bg-bg','cs-cz','da-dk','de-de','el-gr',
'en-us','en-gb','es-es','es-mx','et-ee','fi-fi',
'fr-ca','fr-fr','he-il','hr-hr','hu-hu','it-it',
'ja-jp','ko-kr','lt-lt','lv-lv','nb-no','nl-nl',
'pl-pl','pt-br','pt-pt','ro-ro','ru-ru','sk-sk',
'sl-si','sr-latn-rs','sv-se','th-th','tr-tr',
'uk-ua','zh-cn','zh-tw' | ForEach-Object { $WPFOSLanguageCombobox.Items.Add($_)} | Out-Null
"Hubspot Production Devices","HubSpot Production Kiosk Devices" | ForEach-Object { $WPFAutopilotJsonCombobox.Items.Add($_)} | Out-Null

# Computer Name Text Box Change Event
$WPFComputerNameTextBox.Add_TextChanged({
    If ($WPFComputerNameTextBox.Text.Length -le 0)
    {
        #$WPFImage_StatusCheck.Source = "$PSScriptRoot\Failure.png"
        $WPFComputerNameTextBox.ToolTip="Computer Name cannot be empty"
        #$WPFButton_Next.IsEnabled = $False
    }
    elseif ($WPFComputerNameTextBox.Text.Length -lt 5)
    {
        #$WPFImage_StatusCheck.Source = "$PSScriptRoot\Failure.png"
        $WPFComputerNameTextBox.ToolTip="Computer Name must be greater than 5 characters and less than 15 characters"
        #$WPFButton_Next.IsEnabled = $False
    }
    elseif ($WPFComputerNameTextBox.Text -match "^[-_]|[^\w-_]")
    {
        #$WPFImage_StatusCheck.Source = "$PSScriptRoot\Failure.png"
        $WPFComputerNameTextBox.ToolTip='Invalid Character please correct.'
        $WPFComputerNameTextBox.Text = $WPFTextBox_GeneralComputerName.Text -replace "^[-_]|[^\w-_]", ""
        $WPFComputerNameTextBox.Focus();
    }
    else
    {
        #$WPFImage_StatusCheck.Source = "$PSScriptRoot\Success.png"
        $WPFComputerNameTextBox.ToolTip="Computer Name format is correct."
        #$WPFButton_Next.IsEnabled = $True
    }
})

$WPFStartButton.Add_Click({
    $OSDVarsFile = New-Item -Path $env:WINDIR\Temp -Name "OSDVarsFile.txt" -ItemType File -Force
    Add-Content -Path $OSDVarsFile -Value "OperatingSystem=$(($WPFOSNameCombobox).SelectedItem)"
    Add-Content -Path $OSDVarsFile -Value "OperatingSystemLanguage=$(($WPFOSLanguageCombobox).SelectedItem)"
    Add-Content -Path $OSDVarsFile -Value "AutoPilotConfig=$(($WPFAutopilotJsonCombobox).SelectedItem)"
    Add-Content -Path $OSDVarsFile -Value "ComputerName=$(($WPFComputerNameTextBox).Text)"
    Start PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Lintnotes/OSDCloud/main/Start-OSDeployment.ps1
    $UIWindow.Close()
    })
###### ON Load Event
$UIWindow.Add_Loaded({

})

$UIWindow.Add_Closing({
    $Timer.Dispose()
    $App.Shutdown()
    Stop-Process -id $pid
})

$Host.UI.RawUI.WindowTitle = "HubSpot OSD Cloud"
$UIWindow.ShowDialog() | Out-Null
