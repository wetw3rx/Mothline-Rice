# Mothline

A red-and-teal CachyOS rice built around Niri, Noctalia v5, Kitty, Fastfetch,
Zsh, and a matching Firefox start page.

Mothline uses a near-black foundation, bone-white text, blood-red structure,
teal highlights, restrained glass surfaces, and a recurring moth emblem.

## Included

- Niri 26.04 layout, animation, rules, keybinds, blur, and gradient borders
- Noctalia v5 palette, bar, launcher, notifications, and lock screen
- Kitty theme plus a dedicated Fastfetch popup profile
- Fastfetch layout with NVIDIA, network, and optional PIA status
- Responsive start page with military time and Open-Meteo weather
- Mothline lock-screen wallpaper and avatar
- Zsh installer with timestamped backups and a restoration script

## Preview

Add desktop, lock-screen, terminal, launcher, and start-page screenshots to
`screenshots/`. Avoid screenshots containing notifications, email addresses,
public IP addresses, calendar events, or private browser tabs.

## Requirements

Core applications:

```zsh
sudo pacman -S --needed niri kitty fastfetch zsh git curl jq
```

Install Noctalia v5 using its current official installation instructions.
The configuration expects `noctalia msg ...` IPC commands, not legacy
`qs -c noctalia ipc call ...` commands.

Recommended extras:

```zsh
sudo pacman -S --needed ttf-jetbrains-mono-nerd starship fzf \
  zsh-autosuggestions zsh-syntax-highlighting kdeconnect nautilus
```

## Install

Clone the repository and run the Zsh installer:

```zsh
git clone https://github.com/wetw3rx/mothline-rice.git
cd mothline-rice
./install.zsh
```

The installer backs up existing Niri, Noctalia, Kitty, Fastfetch, start-page,
and Mothline asset directories beneath:

```text
~/.local/state/mothline-backups/
```

It runs `niri validate` after installation when Niri is available.

## Personalize before daily use

1. Run `niri msg outputs`, then edit `~/.config/niri/cfg/display.kdl`.
   The repository ships with its sample output disabled so it cannot apply an
   incorrect mode or monitor position.
2. Edit the identity, time zone, city, coordinates, and preferred links in
   `~/.local/share/startpage/start.html`.
3. If using Google Calendar, copy `examples/calendar.toml` to
   `~/.config/noctalia/calendar.toml`, replace `you@example.com`, and enable the
   account. Never commit your edited calendar file.
4. Use Noctalia lock-screen widget edit mode to reposition widgets for your
   connector names and resolutions:

   ```zsh
   noctalia msg lockscreen-widgets-edit
   ```

5. Set Firefox's home page to:

   ```text
   file:///home/YOUR-USER/.local/share/startpage/start.html
   ```

## Zsh

The installer places `fastfetch-popup` in `~/.local/bin`. The included
`shell/zshrc.example` documents the tested Zsh, Starship, and Fastfetch setup;
it is not installed automatically because replacing a shell configuration is
too invasive.

To launch Fastfetch automatically in each interactive Zsh, add:

```zsh
if [[ -o interactive && -z "${FASTFETCH_SHOWN:-}" ]]; then
  export FASTFETCH_SHOWN=1
  command -v fastfetch >/dev/null 2>&1 && fastfetch
fi
```

## Restore

Pass the backup directory printed by the installer:

```zsh
./restore.zsh ~/.local/state/mothline-backups/install-YYYYMMDD-HHMMSS
```

## Publishing to GitHub

Create an empty public repository named `mothline-rice`, without adding a
README or license on GitHub. Then run from this project directory:

```zsh
git init
git branch -M main
git add .
git diff --cached --check
git commit -m "Initial Mothline rice"
git remote add origin https://github.com/wetw3rx/mothline-rice.git
git push -u origin main
```

Review `git diff --cached` before committing. In particular, confirm there are
no email addresses, credentials, coordinates you consider private, public IPs,
or screenshots with personal information.

## License

MIT
