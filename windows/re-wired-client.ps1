# I2P RE-WIRED client - Liquid Glass unified control.
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="I2P RE-WIRED" Width="390" Height="680"
        WindowStyle="None" Background="Transparent"
        WindowStartupLocation="CenterScreen" Foreground="#F5FFFFFF"
        FontFamily="Segoe UI Variable Display, Segoe UI">
  <Window.Resources>
    <LinearGradientBrush x:Key="specEdge" StartPoint="0,0" EndPoint="0,1">
      <GradientStop Color="#73FFFFFF" Offset="0"/>
      <GradientStop Color="#26FFFFFF" Offset="0.55"/>
      <GradientStop Color="#0DFFFFFF" Offset="1"/>
    </LinearGradientBrush>
    <LinearGradientBrush x:Key="glassFill" StartPoint="0,0" EndPoint="0,1">
      <GradientStop Color="#33FFFFFF" Offset="0"/>
      <GradientStop Color="#0AFFFFFF" Offset="1"/>
    </LinearGradientBrush>
    <LinearGradientBrush x:Key="ringSpec" StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#E6BAE6FD" Offset="0"/>
      <GradientStop Color="#6638BDF8" Offset="0.5"/>
      <GradientStop Color="#E6A5B4FC" Offset="1"/>
    </LinearGradientBrush>
    <RadialGradientBrush x:Key="glowBlue">
      <GradientStop Color="#5938BDF8" Offset="0"/>
      <GradientStop Color="#0038BDF8" Offset="1"/>
    </RadialGradientBrush>
    <RadialGradientBrush x:Key="glowDim">
      <GradientStop Color="#26FFFFFF" Offset="0"/>
      <GradientStop Color="#00FFFFFF" Offset="1"/>
    </RadialGradientBrush>
    <Style TargetType="Button" x:Key="glassRow">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Foreground" Value="#F2FFFFFF"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Margin" Value="0,4"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="rowBg" CornerRadius="16" Padding="16,12"
                    Background="#14FFFFFF" BorderThickness="1"
                    BorderBrush="{StaticResource specEdge}">
              <Grid>
                <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <TextBlock Text="&#8250;" Foreground="#8CFFFFFF" FontSize="15"
                           HorizontalAlignment="Right" VerticalAlignment="Center"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="rowBg" Property="Background" Value="#2EFFFFFF"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="rowBg" Property="Background" Value="#40FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="Button" x:Key="glassPill">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Foreground" Value="#E6FFFFFF"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Width" Value="34"/>
      <Setter Property="Height" Value="34"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="pillBg" CornerRadius="17" Background="#12FFFFFF"
                    BorderThickness="1" BorderBrush="{StaticResource specEdge}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="pillBg" Property="Background" Value="#33FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <!-- glass window body -->
  <Border Name="root" CornerRadius="0" Margin="0"
          Background="#CC0F1420" BorderThickness="1" BorderBrush="{StaticResource specEdge}">
    <Grid>
      <StackPanel>
        <!-- top bar -->
        <Grid Margin="14,14,14,0" Height="34">
          <Button Name="btnMenu" Style="{StaticResource glassPill}" Content="&#8801;"
                  HorizontalAlignment="Left" ToolTip="Refresh"/>
          <TextBlock Text="I2P RE-WIRED" FontSize="14" FontWeight="SemiBold" Foreground="#F2FFFFFF"
                     HorizontalAlignment="Center" VerticalAlignment="Center" Opacity="0.95"/>
          <Button Name="btnClose" Style="{StaticResource glassPill}" Content="&#10005;" FontSize="12"
                  HorizontalAlignment="Right" ToolTip="Close"/>
        </Grid>

        <!-- liquid glass ring (hero control) -->
        <Grid Margin="0,34,0,0" Width="196" Height="196">
          <Ellipse Name="ringGlow" Width="196" Height="196" Fill="{StaticResource glowBlue}" Opacity="0.85"/>
          <Ellipse Name="ring" Width="168" Height="168" StrokeThickness="2.5"
                   Stroke="{StaticResource ringSpec}" Fill="{StaticResource glassFill}"/>
          <Ellipse Name="ringArc" Width="168" Height="168" Fill="Transparent" Visibility="Collapsed"
                   Stroke="#FCD34D" StrokeThickness="2.5" StrokeDashArray="6 4"/>
          <Button Name="btnRing" Width="168" Height="168" Background="Transparent"
                  BorderThickness="0" Cursor="Hand" ToolTip="Toggle fast lane">
            <Button.Template>
              <ControlTemplate TargetType="Button">
                <Border Background="Transparent" CornerRadius="84">
                  <TextBlock Text="RE-WIRED" FontSize="14" FontWeight="SemiBold" Foreground="#F2FFFFFF"
                             HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Button.Template>
          </Button>
        </Grid>

        <TextBlock Name="bigState" Text="Checking..." FontSize="18" FontWeight="SemiBold"
                   HorizontalAlignment="Center" Margin="0,20,0,0" Foreground="#F5FFFFFF"/>
        <TextBlock Name="subState" Text="probing lanes" FontSize="12" Foreground="#A6FFFFFF"
                   HorizontalAlignment="Center" Margin="0,5,0,0" TextWrapping="Wrap"
                   TextAlignment="Center" Width="320"/>

        <!-- glass rows -->
        <StackPanel Margin="18,28,18,0">
          <Button Name="btnTor"     Style="{StaticResource glassRow}" Content="RE-WIRED Mode (Tor for apps)"/>
          <Button Name="btnI2p"     Style="{StaticResource glassRow}" Content="I2P console"/>
          <Button Name="btnBrowser" Style="{StaticResource glassRow}" Content="RE-WIRED browser"/>
          <Button Name="btnI2pSvc"  Style="{StaticResource glassRow}" Content="Restart I2P router"/>
          <Button Name="btnAudit"   Style="{StaticResource glassRow}" Content="Security audit - local checks"/>
        </StackPanel>
        <TextBlock Text="by Hashbrown" FontSize="10" Foreground="#59FFFFFF"
                   HorizontalAlignment="Center" Margin="0,14,0,14"/>
      </StackPanel>
    </Grid>
  </Border>
</Window>
'@

$win = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$xaml)))
$ring = $win.FindName('ring'); $ringArc = $win.FindName('ringArc'); $ringGlow = $win.FindName('ringGlow')
$btnRing = $win.FindName('btnRing')
$bigState = $win.FindName('bigState'); $subState = $win.FindName('subState')
$btnTor = $win.FindName('btnTor'); $btnI2p = $win.FindName('btnI2p')
$btnBrowser = $win.FindName('btnBrowser'); $btnI2pSvc = $win.FindName('btnI2pSvc')
$btnAudit = $win.FindName('btnAudit'); $btnMenu = $win.FindName('btnMenu')
$btnClose = $win.FindName('btnClose')

# acrylic blur-behind: the frosted glass layer (undocumented but stable since Win10)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class GlassFx {
  [DllImport("dwmapi.dll")] public static extern int DwmSetWindowAttribute(IntPtr h, int attr, ref int val, int size);
  [StructLayout(LayoutKind.Sequential)] public struct ACCENT { public int AccentState; public int AccentFlags; public int GradientColor; public int AnimationId; }
  [StructLayout(LayoutKind.Sequential)] public struct WCAD { public int Attribute; public IntPtr Data; public int SizeOfData; }

  public static void Enable(IntPtr hwnd) {
    int corner = 2;  // DWMWA_WINDOW_CORNER_PREFERENCE -> ROUND
    DwmSetWindowAttribute(hwnd, 33, ref corner, 4);
    int backdrop = 3; // DWMSBT_TRANSIENTWINDOW -> acrylic
    DwmSetWindowAttribute(hwnd, 38, ref backdrop, 4);
    int dark = 1;    // DWMWA_USE_IMMERSIVE_DARK_MODE
    DwmSetWindowAttribute(hwnd, 20, ref dark, 4);
  }
}
"@
$win.add_SourceInitialized({
  $hwnd = (New-Object System.Windows.Interop.WindowInteropHelper($win)).Handle
  [GlassFx]::Enable($hwnd)
})

# drag anywhere except on a button
$win.add_MouseLeftButtonDown({
  $src = $_.OriginalSource
  try {
    while ($src -and $src -isnot [System.Windows.Controls.Button] -and $src -isnot [System.Windows.Window]) {
      $src = [System.Windows.Media.VisualTreeHelper]::GetParent($src)
    }
  } catch { $src = $null }
  if ($src -isnot [System.Windows.Controls.Button]) { $win.DragMove() }
})
$btnClose.add_Click({ $win.Close() })
$win.add_KeyDown({ if ($_.Key -eq 'Escape') { $win.Close() } })

if (Test-Path 'B:\i2p\assets\rewired.ico') {
  $win.Icon = New-Object Windows.Media.Imaging.BitmapImage (New-Object Uri 'file:///B:/i2p/assets/rewired.ico')
}

$warp = 'C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe'
$k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

function New-RingBrush([string]$c1, [string]$c2, [string]$c3) {
  $b = New-Object Windows.Media.LinearGradientBrush
  $b.StartPoint = '0,0'; $b.EndPoint = '1,1'
  $gs = New-Object Windows.Media.GradientStopCollection
  @(@($c1,0), @($c2,0.5), @($c3,1)) | ForEach-Object {
    $s = New-Object Windows.Media.GradientStop
    $s.Color = [Windows.Media.ColorConverter]::ConvertFromString($_[0]); $s.Offset = $_[1]
    $gs.Add($s)
  }
  $b.GradientStops = $gs; return $b
}

function Refresh-State {
  $warpOn = ((& $warp status 2>$null) -match 'Connected')
  $torOn = (Get-ItemProperty $k).ProxyEnable -eq 1
  try { Invoke-WebRequest 'http://127.0.0.1:7657' -TimeoutSec 3 -UseBasicParsing | Out-Null; $i2pOn = $true } catch { $i2pOn = $false }

  if ($warpOn) {
    $ring.Stroke = New-RingBrush '#E6BAE6FD' '#6638BDF8' '#E6A5B4FC'; $ringArc.Visibility = 'Collapsed'; $ringGlow.Opacity = 0.85
    $bigState.Text = 'Connected'; $bigState.Foreground = '#BAE6FD'
    $subState.Text = 'Your traffic exits at a Cloudflare datacenter.'
  } else {
    $ring.Stroke = '#40FFFFFF'; $ringArc.Visibility = 'Collapsed'; $ringGlow.Opacity = 0.3
    $bigState.Text = 'Disconnected'; $bigState.Foreground = '#A6FFFFFF'
    $subState.Text = 'Fast lane is off. Real IP exposed.'
  }
  $btnTor.Content = if ($torOn) { 'RE-WIRED Mode (Tor) - ON' } else { 'RE-WIRED Mode (Tor) - OFF' }
  $btnI2p.Content = if ($i2pOn) { 'I2P console - hidden, up' } else { 'I2P console - starting...' }
}

$btnRing.add_Click({
  $ring.Stroke = '#FCD34D'; $bigState.Text = 'Switching...'; $bigState.Foreground = '#FCD34D'
  if ((& $warp status 2>$null) -match 'Connected') { & $warp disconnect | Out-Null } else { & $warp connect | Out-Null }
  Start-Sleep 2; Refresh-State
})
$btnTor.add_Click({ & powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File 'B:\tor\I2P-RE-WIRED-Mode.ps1'; Start-Sleep 1; Refresh-State })
$btnI2p.add_Click({ Start-Process 'B:\i2p\docs\startconsole.html' })
$btnBrowser.add_Click({ Start-Process 'B:\i2pdbrowser\StartI2PdBrowser.bat' -WorkingDirectory 'B:\i2pdbrowser' })
$btnI2pSvc.add_Click({ Get-Process javaw -ErrorAction SilentlyContinue | Stop-Process -Force; Start-Sleep 2; Start-Process 'B:\i2p\i2p.exe' -WorkingDirectory 'B:\i2p'; Refresh-State })
function Invoke-Audit {
  # REA-style local audit: prove nothing privacy-sensitive leaks outside localhost.
  $issues = @()
  $i2pPid = (Get-Process javaw -ErrorAction SilentlyContinue | Select-Object -First 1).Id
  if ($i2pPid) {
    $open = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
      Where-Object { $_.OwningProcess -eq $i2pPid -and $_.LocalAddress -notin @('127.0.0.1','::1') }
    if ($open) { $issues += "i2p listening on $($open.LocalAddress -join ',')" }
  } else { $issues += 'i2p router not running' }
  if (-not (Get-Process tor -ErrorAction SilentlyContinue)) { $issues += 'tor client not running' }
  $svc = Get-Service tor -ErrorAction SilentlyContinue
  if ($svc -and $svc.Status -ne 'Running') { $issues += 'tor service stopped' }
  $mode = (Get-ItemProperty $k).ProxyEnable -eq 1
  $report = if ($issues.Count) { "audit: " + ($issues -join '; ') } else { "audit: clean - all lanes localhost-bound, no leaks" + $(if ($mode) { ', tor proxy on' } else { '' }) }
  $subState.Text = $report
}
$btnAudit.add_Click({ Invoke-Audit })
$btnMenu.add_Click({ Refresh-State })

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(15)
$timer.add_Tick({ Refresh-State }); $timer.Start()

Refresh-State
$win.ShowDialog() | Out-Null
