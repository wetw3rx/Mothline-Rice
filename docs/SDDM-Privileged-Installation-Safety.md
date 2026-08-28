# SDDM Privileged Installation Safety

## Incident

On 2026-08-28, COVENANT's Mothline SDDM theme was present in the rice and in
the user's staged assets, but it was not installed under
`/usr/share/sddm/themes` or selected in SDDM configuration.

A temporary repair script initially used:

```bash
SOURCE="$HOME/Projects/mothline-rice/config/sddm-mothline"
```

Under sudo, `$HOME` resolved to `/root`, so source validation failed before
any privileged mutation. The temporary script was corrected for COVENANT and
the theme was installed, configured, reboot-tested, and visually accepted.

## Canonical correction

The bundled installer at `config/sddm-mothline/install.sh` already avoids this
defect by deriving its source from `${BASH_SOURCE[0]}`. The repository gap was
that the main `install.zsh` only staged the theme and did not offer the
system-wide installer.

The main installer now:

1. stages the theme under `~/.local/share/mothline-sddm`;
2. explains the privilege boundary;
3. offers an explicit opt-in system installation;
4. invokes the staged installer through sudo;
5. never restarts SDDM automatically.

## Rules for privileged installers

- Do not use root's `$HOME` to locate user-owned project assets.
- Prefer an explicit validated absolute source or a script-relative source.
- Validate required files before mutation.
- Back up an existing target before replacement.
- Verify ownership, permissions, `Main.qml`, and `metadata.desktop`.
- Keep display-manager restart or reboot separate from installation.
- Treat installation, activation, reboot acceptance, Git push, and backup
  synchronization as separate evidence-backed states.

## Verification

After installation:

```bash
test -f /usr/share/sddm/themes/sddm-noctalia-theme/Main.qml
grep -RhsE '^[[:space:]]*Current=' \
  /etc/sddm.conf /etc/sddm.conf.d 2>/dev/null
```

Expected theme:

```text
Current=sddm-noctalia-theme
```

Save active work before rebooting. After reboot, verify the Mothline greeter,
successful login, Niri/Noctalia startup, and SDDM logs.

## COVENANT acceptance

COVENANT passed the reboot and visual login test on 2026-08-28. The Mothline
greeter appeared correctly and the desktop session launched successfully.
