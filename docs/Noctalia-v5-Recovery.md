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
alter the Niri session, Mothline configuration, wallpaper selection,
notification history, or open application windows.

### Manual recovery

```bash
pkill -x noctalia
nohup noctalia >/tmp/noctalia.log 2>&1 &
disown
```

If the shell does not return:

```bash
niri msg action spawn -- noctalia
```

## Installation

Install `bin/nocta-v5-restart` to `~/.local/bin/nocta-v5-restart` and install
`examples/nv5restart.desktop` under `~/.local/share/applications/`.

Search the application launcher for **Nocta v5 Restart**.

## Verification

```bash
pgrep -af '^noctalia|/noctalia'
tail -n 20 ~/.local/state/noctalia/restart.log
```

A successful recovery recreates the configured bars and wallpapers and reports
the Noctalia IPC socket in the restart log.

## Incident record

Verified on COVENANT on 2026-08-29. Restarting Noctalia cleared a hung toast.
The Mothline bar, wallpaper, IPC, plugins, clipboard, audio integration, and
Polkit authentication agent returned normally.
