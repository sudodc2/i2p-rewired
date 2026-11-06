# I2P RE-WIRED client - unified control for WARP, Tor and I2P lanes.
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="I2P RE-WIRED" Width="420" Height="560" ResizeMode="NoResize"
        WindowStartupLocation="CenterScreen" Background="#0b0d10" Foreground="#e6e9ee">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="Background" Value="#181c22"/>
      <Setter Property="Foreground" Value="#e6e9ee"/>
      <Setter Property="BorderBrush" Value="#2a3038"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="14,10"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Margin" Value="0,5"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}"
                    BorderThickness="1" CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter Property="Background" Value="#222833"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>
  <StackPanel Margin="24">
    <TextBlock Text="I2P RE-WIRED" FontSize="26" FontWeight="Bold" Foreground="#5ac8fa" HorizontalAlignment="Center"/>
    <TextBlock Text="by Hashbrown" FontSize="11" Foreground="#6b7280" HorizontalAlignment="Center" Margin="0,2,0,18"/>

    <TextBlock Text="LANES" FontSize="11" Foreground="#6b7280" Margin="0,0,0,6"/>
    <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
      <Ellipse Name="dotWarp" Width="10" Height="10" Fill="#4b5563" Margin="0,0,8,0"/>
      <TextBlock Text="RE-WIRED Fast (WARP - all apps, 1 hop)" VerticalAlignment="Center" FontSize="13"/>
    </StackPanel>
    <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
      <Ellipse Name="dotTor" Width="10" Height="10" Fill="#4b5563" Margin="0,0,8,0"/>
      <TextBlock Text="RE-WIRED Mode (Tor - proxy-aware apps)" VerticalAlignment="Center" FontSize="13"/>
    </StackPanel>
    <StackPanel Orientation="Horizontal" Margin="0,0,0,12">
      <Ellipse Name="dotI2p" Width="10" Height="10" Fill="#4b5563" Margin="0,0,8,0"/>
      <TextBlock Text="I2P (.i2p network, hidden mode)" VerticalAlignment="Center" FontSize="13"/>
    </StackPanel>
    <TextBlock Name="status" Text="checking..." FontSize="12" Foreground="#9ca3af" Margin="0,0,0,14"/>

    <Button Name="btnWarp" Content="Connecting WARP..."/>
    <Button Name="btnTor"  Content="RE-WIRED Mode: ..."/>
    <Button Name="btnConsole" Content="Open I2P Console"/>
    <Button Name="btnBrowser" Content="Launch RE-WIRED Browser"/>

    <TextBlock Text="Every lane runs locally on this PC. No accounts, no traffic database."
               FontSize="10" Foreground="#4b5563" HorizontalAlignment="Center" TextWrapping="Wrap" Margin="0,18,0,0"/>
  </StackPanel>
</Window>
'@

$win = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$xaml)))
$dotWarp = $win.FindName('dotWarp'); $dotTor = $win.FindName('dotTor'); $dotI2p = $win.FindName('dotI2p')
$status = $win.FindName('status')
$btnWarp = $win.FindName('btnWarp'); $btnTor = $win.FindName('btnTor')
$btnConsole = $win.FindName('btnConsole'); $btnBrowser = $win.FindName('btnBrowser')

$warp = 'C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe'
$k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

function Refresh-State {
  $warpOn = ((& $warp status 2>$null) -match 'Connected')
  $torOn = (Get-ItemProperty $k).ProxyEnable -eq 1
  try { Invoke-WebRequest 'http://127.0.0.1:7657' -TimeoutSec 3 -UseBasicParsing | Out-Null; $i2pOn = $true } catch { $i2pOn = $false }

  $dotWarp.Fill = if ($warpOn) { '#34d399' } else { '#4b5563' }
  $dotTor.Fill  = if ($torOn)  { '#34d399' } else { '#4b5563' }
  $dotI2p.Fill  = if ($i2pOn)  { '#34d399' } else { '#f59e0b' }

  $btnWarp.Content = if ($warpOn) { 'Fast lane: CONNECTED - click to disconnect' } else { 'Fast lane: OFF - click to connect' }
  $btnTor.Content  = if ($torOn)  { 'RE-WIRED Mode: ON - click to disable' } else { 'RE-WIRED Mode: OFF - click to enable' }
  $status.Text = if ($i2pOn) { 'router hidden, tunnels up' } else { 'i2p router starting...' }
}

$btnWarp.add_Click({ if ((& $warp status 2>$null) -match 'Connected') { & $warp disconnect | Out-Null } else { & $warp connect | Out-Null }; Start-Sleep 1; Refresh-State })
$btnTor.add_Click({ & powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File 'B:\tor\I2P-RE-WIRED-Mode.ps1'; Start-Sleep 1; Refresh-State })
$btnConsole.add_Click({ Start-Process 'B:\i2p\docs\startconsole.html' })
$btnBrowser.add_Click({ Start-Process 'B:\i2pdbrowser\StartI2PdBrowser.bat' -WorkingDirectory 'B:\i2pdbrowser' })

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(15)
$timer.add_Tick({ Refresh-State })
$timer.Start()

Refresh-State
$win.ShowDialog() | Out-Null
