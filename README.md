# I2P RE-WIRED

[![Discord](https://img.shields.io/discord/1556595354999332884?logo=discord&logoColor=white&label=Discord&color=5865F2)](https://discord.com/invite/JUEc8rBVvC)
[![Upstream](https://img.shields.io/badge/upstream-PurpleI2P%2Fi2pdbrowser-blue)](https://github.com/PurpleI2P/i2pdbrowser)

**A rebuilt and privacy-hardened I2P browser bundle by [Hashbrown](https://github.com/sudodc2).**
Forked and rewired from the PurpleI2P project.
Same hardened-Firefox + i2pd portable setup — with a privacy-tuned
router profile applied to every shipped config. See
[Hardened profile](#hardened-profile-this-fork) below.

*Note: repository was force-pushed to remove bundled Firefox and big binaries from repository archive. Clone repository again to fetch new commit tree.*

-----

This is a collection of scripts that will download the recent Firefox ESR release and configure it to connect over I2P, using i2pd.
Since 1.2.6 pre-built version for Windows is excluded from repository, but releases will contain it.

## How to use it on Linux

1. Build preconfigured FireFox using script `build.sh` from `build` folder
2. Run i2pd by executing `./i2pd` from `i2pd` folder
3. Run FireFox by executing `./firefox-portable`

### Release signing
Release hashsums signed with key [66f6c87b98ebcfe2](http://keyserver.ubuntu.com/pks/lookup?op=vindex&search=0x66F6C87B98EBCFE2)

-----

## Hardened profile (this fork)

Upstream `i2pd` config templates tuned for privacy + low resource use.
No router keys, identities, or runtime state ship in this repo — all
keys are generated per-install at first run, as upstream intended.

Changes vs upstream `i2pd.conf` (all three OS bundles):

| Setting | Upstream | Hardened | Why |
| --- | --- | --- | --- |
| `upnp.enabled` | `true` | `false` | Stops auto-punching NAT holes and announcing an I2P router on the LAN |
| `ntcp2.enabled` | `true` | `false` | Kills the inbound TCP listener on all interfaces - SSU2/UDP carries everything, one less fingerprintable port |
| `notransit` | unset | `true` | Router never relays traffic for others; transit tunnels expose your router's long-lived identity to more peers |
| `floodfill` | unset | `false` | Explicit opt-out of network-database duty (default off upstream; pinned here) |
| `[limits] transittunnels` | unset | `0` | Hard cap matching `notransit` for defense-in-depth |
| `bandwidth` | `O` | `O` (unchanged) | Already capped at ~256 KB/s — bounded on modest machines |

What this does NOT do: these are configuration hardening only. I2P's
cryptography (ECIES-X25519, NTCP2/SSU2, garlic routing) is unchanged —
the privacy risks it does not solve are network-layer traffic analysis,
which no config can fully eliminate.

### Boot persistence (Windows)

To autostart the hardened bundle at logon — while staying visible and
toggleable in Task Manager's **Startup** tab — add a per-user Run key:

```powershell
New-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' `
  -Name 'I2PdBrowser' -PropertyType String `
  -Value '"<bundle path>\StartI2PdBrowser.bat"'
```

Per-user Run keys need no admin rights, appear under
Task Manager > Startup for easy disabling, and use the bundle's own
config directory. Prefer this over a SYSTEM scheduled task, which is
invisible in Task Manager and resolves the config under a different
profile.

-----

## System-wide lane: RE-WIRED Mode (optional, Windows)

I2P carries `.i2p` destinations only. For general anonymous browsing,
RE-WIRED includes a Windows system-proxy toggle that routes all
proxy-aware apps through a locally running Tor client
(`127.0.0.1:9050`, `ClientOnly`, no relaying, no account, no logs -
same architectural posture as Mullvad: there is no database of user
traffic for anyone to breach).

- `windows/tor-mode.ps1`: flips the Windows system proxy on/off and
  shows the current state. ON routes browsers and most apps through
  Tor; Discord, Steam and LAN addresses are bypassed so accounts are
  not flagged and LAN stays fast.
- Requires a Tor client listening on `9050` (Tor Expert Bundle or
  Tor Browser's built-in client).
- Not a VPN: UDP-only apps and apps that ignore the system proxy are
  unaffected. Toggle it off anytime; nothing is persisted except the
  standard Windows proxy keys.

-----

## RE-WIRED Client (Windows)

`windows/re-wired-client.ps1`: a single-window dark client that unifies
every lane - Cloudflare WARP fast lane connect/disconnect, RE-WIRED
Mode (Tor) toggle, I2P console and hardened browser launch, with live
per-lane status indicators. No build step; run with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File windows\re-wired-client.ps1
```

Requires: I2P at `B:\i2p`, the bundle at `B:\i2pdbrowser`, WARP client,
Tor on `127.0.0.1:9050`. Adjust paths at the top of the file for other
install layouts.
