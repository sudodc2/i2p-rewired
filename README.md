# i2pdbrowser

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
| `notransit` | unset | `true` | Router never relays traffic for others; transit tunnels expose your router's long-lived identity to more peers |
| `floodfill` | unset | `false` | Explicit opt-out of network-database duty (default off upstream; pinned here) |
| `[limits] transittunnels` | unset | `0` | Hard cap matching `notransit` for defense-in-depth |
| `bandwidth` | `O` | `O` (unchanged) | Already capped at ~256 KB/s — bounded on modest machines |

What this does NOT do: these are configuration hardening only. I2P's
cryptography (ECIES-X25519, NTCP2/SSU2, garlic routing) is unchanged —
the privacy risks it does not solve are network-layer traffic analysis,
which no config can fully eliminate.
