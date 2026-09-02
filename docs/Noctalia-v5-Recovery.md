# Noctalia v5 Recovery

Mothline recovery procedures for Noctalia v5 on Niri.

## Hung notification toast

### Symptoms

- A notification toast remains visible indefinitely.
- Dismiss or delete controls do not remove it.
- The remainder of Noctalia may continue operating normally.

### Preferred recovery

Launch **Nocta v5 Restart** from the application launcher.

It runs `~/.local/bin/nocta-v5-restart`, restarting only Noctalia. It does not
alter the Niri session, Mothline configuration, notification history, or open
application windows.

The helper obtains `NIRI_SOCKET` from the current environment or the systemd
user environment, verifies that the socket exists, and asks Niri to spawn
`noctalia --daemon` inside the active graphical session.

### Manual recovery inside Niri

From a terminal running inside the Niri session:

```bash
~/.local/bin/nocta-v5-restart
```

If the launcher is unavailable but the Niri socket is exported:

```bash
pkill -x noctalia
NIRI_SOCKET="$NIRI_SOCKET" niri msg action spawn -- noctalia --daemon
```

### Recovery over SSH

A plain SSH shell normally has no Wayland display. Do not use `nohup noctalia`
from that shell. Discover the socket stored by the user service manager and ask
Niri to perform the spawn:

```bash
socket=$(systemctl --user show-environment | sed -n 's/^NIRI_SOCKET=//p')
test -S "$socket"
NIRI_SOCKET="$socket" niri msg action spawn -- noctalia --daemon
```

If no valid socket exists, stop and recover from the physical Niri session.

## Installation

The main Mothline installer installs `bin/nocta-v5-restart` under
`~/.local/bin/` and installs `examples/nv5restart.desktop` under
`~/.local/share/applications/`.

Search the application launcher for **Nocta v5 Restart**.

## Verification

```bash
pgrep -af '^noctalia|/noctalia'
tail -n 20 ~/.local/state/noctalia/restart.log
```

A successful recovery recreates the configured bars and wallpapers. The log
records whether the restart used the Niri socket or current Wayland session.

## Incident record

On 2026-08-29, restarting Noctalia cleared a hung toast on COVENANT and
restored the bar, wallpaper, IPC, plugins, clipboard, audio integration, and
Polkit authentication agent.

On 2026-09-01, a direct restart from SSH failed to connect to Wayland and left
COVENANT with a black background and no bar. The original Noctalia directory
was restored from the verified pre-cleanup backup. Spawning Noctalia through
the live Niri socket restored the accepted desktop. The restart helper was
then updated to prevent recurrence.
