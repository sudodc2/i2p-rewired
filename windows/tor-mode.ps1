# I2P RE-WIRED system-wide lane toggle (Tor). Click once to flip state.
$k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
$on = (Get-ItemProperty $k).ProxyEnable -eq 1
if ($on) {
  Set-ItemProperty $k ProxyEnable 0
  $msg = 'I2P RE-WIRED mode: OFF`nSystem-wide anonymous routing disabled.'
  $title = 'I2P RE-WIRED - OFF'
} else {
  Set-ItemProperty $k ProxyEnable 1
  Set-ItemProperty $k ProxyServer 'socks=127.0.0.1:9050'
  Set-ItemProperty $k ProxyOverride 'localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.2?.*;192.168.*;*.local;*.discord.com;discord.com;*.discord.gg;*.discord.media;*.discordapp.com;*.discordapp.net;*.steampowered.com;steampowered.com;*.steamcommunity.com;*.steamcontent.com;<local>'
  $msg = 'I2P RE-WIRED mode: ON`nBrowsers and proxy-aware apps now route through Tor.`nDiscord, Steam and LAN bypassed.'
  $title = 'I2P RE-WIRED - ON'
}
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show($msg, $title, 'OK', 'Information') | Out-Null
