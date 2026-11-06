# I2P RE-WIRED client - WARP-client-style unified control.
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="I2P RE-WIRED" Width="360" Height="600" ResizeMode="NoResize"
        WindowStartupLocation="CenterScreen" Background="#16181d" Foreground="#f4f4f5"
        FontFamily="Segoe UI">
  <Window.Resources>
    <Style TargetType="Button" x:Key="row">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#f4f4f5"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Padding" Value="16,12"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Background="{TemplateBinding Background}" Padding="{TemplateBinding Padding}">
              <Grid>
                <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <TextBlock Text=">" Foreground="#71717a" HorizontalAlignment="Right" VerticalAlignment="Center" FontSize="14"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter Property="Background" Value="#22252c"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>
  <Grid>
    <StackPanel>
      <!-- top bar: hamburger + wordmark -->
      <Grid Margin="18,14,18,0">
        <Button Name="btnMenu" Content="≡" FontSize="18" Padding="8,4" Background="Transparent"
                BorderThickness="0" Foreground="#e4e4e7" Cursor="Hand" HorizontalAlignment="Left"/>
        <TextBlock Text="I2P RE-WIRED" FontSize="15" FontWeight="SemiBold" Foreground="#e4e4e7"
                   HorizontalAlignment="Center" VerticalAlignment="Center"/>
      </Grid>

      <!-- big ring toggle (the hero control) -->
      <Grid Margin="0,30,0,0" Width="170" Height="170">
        <Ellipse Name="ringGlow" Width="170" Height="170" Fill="#1d4ed8" Opacity="0.25"/>
        <Ellipse Name="ring" Width="160" Height="160" Fill="Transparent"
                 Stroke="#3f3f46" StrokeThickness="10"/>
        <Ellipse Name="ringArc" Width="160" Height="160" Fill="Transparent"
                 Stroke="#2563eb" StrokeThickness="10" Visibility="Collapsed"/>
        <Button Name="btnRing" Width="160" Height="160" Background="Transparent" BorderThickness="0" Cursor="Hand">
          <Button.Template>
            <ControlTemplate TargetType="Button">
              <Border Background="Transparent">
                <TextBlock Text="RE-WIRED" FontSize="15" FontWeight="SemiBold" Foreground="#e4e4e7"
                           HorizontalAlignment="Center" VerticalAlignment="Center"/>
              </Border>
            </ControlTemplate>
          </Button.Template>
        </Button>
      </Grid>

      <TextBlock Name="bigState" Text="Checking..." FontSize="17" FontWeight="SemiBold"
                 HorizontalAlignment="Center" Margin="0,18,0,0" Foreground="#f4f4f5"/>
      <TextBlock Name="subState" Text="probing lanes" FontSize="12" Foreground="#a1a1aa"
                 HorizontalAlignment="Center" Margin="0,4,0,0"/>

      <!-- menu rows -->
      <Border Margin="18,26,18,0" BorderBrush="#26272b" BorderThickness="0,1,0,0"/>
      <StackPanel Margin="6,6">
        <Button Name="btnTor"    Style="{StaticResource row}" Content="RE-WIRED Mode (Tor for apps)"/>
        <Button Name="btnI2p"    Style="{StaticResource row}" Content="I2P console"/>
        <Button Name="btnBrowser" Style="{StaticResource row}" Content="RE-WIRED browser"/>
        <Button Name="btnI2pSvc" Style="{StaticResource row}" Content="Restart I2P router"/>
      </StackPanel>
    </StackPanel>

    <TextBlock Text="by Hashbrown" FontSize="10" Foreground="#52525b"
               HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,12"/>
  </Grid>
</Window>
'@

$win = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$xaml)))
$ring = $win.FindName('ring'); $ringArc = $win.FindName('ringArc'); $ringGlow = $win.FindName('ringGlow')
$btnRing = $win.FindName('btnRing')
$bigState = $win.FindName('bigState'); $subState = $win.FindName('subState')
$btnTor = $win.FindName('btnTor'); $btnI2p = $win.FindName('btnI2p')
$btnBrowser = $win.FindName('btnBrowser'); $btnI2pSvc = $win.FindName('btnI2pSvc')
$btnMenu = $win.FindName('btnMenu')

$warp = 'C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe'
$k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

function Refresh-State {
  $warpOn = ((& $warp status 2>$null) -match 'Connected')
  $torOn = (Get-ItemProperty $k).ProxyEnable -eq 1
  try { Invoke-WebRequest 'http://127.0.0.1:7657' -TimeoutSec 3 -UseBasicParsing | Out-Null; $i2pOn = $true } catch { $i2pOn = $false }

  if ($warpOn) {
    $ring.Stroke = '#2563eb'; $ringArc.Visibility = 'Collapsed'; $ringGlow.Opacity = 0.3
    $bigState.Text = 'Connected'; $bigState.Foreground = '#60a5fa'
    $subState.Text = 'Your traffic exits at a Cloudflare datacenter.'
  } else {
    $ring.Stroke = '#3f3f46'; $ringArc.Visibility = 'Collapsed'; $ringGlow.Opacity = 0.12
    $bigState.Text = 'Disconnected'; $bigState.Foreground = '#a1a1aa'
    $subState.Text = 'Fast lane is off. Real IP exposed.'
  }
  $btnTor.Content = if ($torOn) { 'RE-WIRED Mode (Tor) — ON' } else { 'RE-WIRED Mode (Tor) — OFF' }
  $btnI2p.Content = if ($i2pOn) { 'I2P console — hidden, up' } else { 'I2P console — starting...' }
}

$btnRing.add_Click({
  $ring.Stroke = '#f59e0b'; $bigState.Text = 'Switching...'; $bigState.Foreground = '#f59e0b'
  if ((& $warp status 2>$null) -match 'Connected') { & $warp disconnect | Out-Null } else { & $warp connect | Out-Null }
  Start-Sleep 2; Refresh-State
})
$btnTor.add_Click({ & powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File 'B:\tor\I2P-RE-WIRED-Mode.ps1'; Start-Sleep 1; Refresh-State })
$btnI2p.add_Click({ Start-Process 'B:\i2p\docs\startconsole.html' })
$btnBrowser.add_Click({ Start-Process 'B:\i2pdbrowser\StartI2PdBrowser.bat' -WorkingDirectory 'B:\i2pdbrowser' })
$btnI2pSvc.add_Click({ Get-Process javaw -ErrorAction SilentlyContinue | Stop-Process -Force; Start-Sleep 2; Start-Process 'B:\i2p\i2p.exe' -WorkingDirectory 'B:\i2p'; Refresh-State })
$btnMenu.add_Click({ Refresh-State })

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(15)
$timer.add_Tick({ Refresh-State }); $timer.Start()

Refresh-State
$win.ShowDialog() | Out-Null
