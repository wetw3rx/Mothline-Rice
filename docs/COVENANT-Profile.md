# COVENANT Machine Profile

The `covenant` profile packages the tested Mothline configuration for a Lenovo
ThinkPad T480 while keeping the repository free of account credentials,
personal identifiers, LAN addresses, and machine-specific secrets.

## Tested baseline

- Lenovo ThinkPad T480
- Intel Core i5-8350U
- 16 GB RAM
- 512 GB NVMe SSD
- CachyOS
- Niri 26.04
- Noctalia v5
- Internal output: `eDP-1`, `1920x1080@60.020`, scale 1

Hardware revisions and replacement display panels may advertise different
output names, modes, or refresh rates. Always confirm with `niri msg outputs`.

## Installation

```bash
git clone https://github.com/wetw3rx/Mothline-Rice.git
cd Mothline-Rice
./install.zsh --profile covenant
```

The installer creates a timestamped backup, installs the portable common
configuration, then applies `profiles/covenant/config/` as the machine overlay.
It installs the canonical wallpaper, expands `@HOME@` only in the installed
copy, installs the maintenance helpers, and validates Niri.

## Profile behavior

The profile preserves the accepted COVENANT bar colors, widget order,
wallpaper, and Noctalia v5 layout.

The lock screen and lock-screen widgets remain disabled through
`zzz-covenant-safety.toml`. Enable and visually test them only after confirming
that every connected output renders a working login box.

The calendar account is a disabled example using `you@example.com`. Configure
the installed copy locally. Never commit account names, calendar addresses,
tokens, passwords, or exported calendar archives.

## Optional integrations

The accepted snapshot references optional phone-connect and DivingCrush mail
integrations. Noctalia may warn when those plugins are absent. Core bar,
wallpaper, launcher, notification, and control-center operation do not depend
on them.

## Network portability

Do not encode a changing DHCP address in the repository. Reserve the desired
address on the router using the wired-interface MAC, then point the local SSH
alias `covenant` at that reserved address. Keep MAC and LAN addresses, SSH
keys, agent sockets, and `authorized_keys` out of the public profile.

## Noctalia recovery

Use the **Nocta v5 Restart** launcher. The helper discovers the live
`NIRI_SOCKET` and asks Niri to spawn Noctalia inside the graphical session.
Do not start Noctalia directly from a plain SSH environment; it may have no
Wayland display and can leave the session with no bar or wallpaper.

## Rollback

Use the backup path printed by the installer:

```bash
./restore.zsh ~/.local/state/mothline-backups/install-YYYYMMDD-HHMMSS
```

The restore tool returns backed-up configuration, managed helper binaries, and
the restart launcher, then validates Niri when available.

## Acceptance checks

```bash
niri validate
niri msg outputs
pgrep -a noctalia
systemctl --failed
systemctl --user --failed
```

COVENANT passed isolated profile installation and install/restore round-trip
tests on 2026-09-01. These tests used a temporary home and did not modify the
live desktop.
