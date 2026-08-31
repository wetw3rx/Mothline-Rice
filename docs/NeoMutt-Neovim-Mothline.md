# NeoMutt + Neovim Mothline Mail Composer

## Scope

This portable component styles Neovim when NeoMutt launches it to compose email. NeoMutt remains responsible for accounts, recipients, attachments, encryption, postponing, and sending.

## Installed files

```text
~/.config/nvim/init.lua
~/.config/nvim/lazy-lock.json
~/.config/nvim/lua/plugins/mail.lua
~/.config/nvim/after/ftplugin/mail.lua
~/.config/nvim/colors/mothline.lua
```

## Required packages

```bash
sudo pacman -S --needed neovim git wl-clipboard
```

## NeoMutt integration

Add locally to `~/.config/neomutt/neomuttrc`:

```neomutt
set editor="/usr/bin/nvim"
set edit_headers=yes
```

The public rice does not install NeoMutt account configuration or signatures.

## Workflow and keybinds

- `]s` / `[s`: next / previous spelling error
- `z=`: spelling suggestions
- `gqap`: reflow the current paragraph
- `<Space>w`: save and remain in Neovim
- `<Space>q`: save and return to NeoMutt
- `<Space>f`: reflow the current paragraph
- `<Space>z`: toggle Zen Mode
- `\q`: add email quote markers

Saving in Neovim does not send. Review the message in NeoMutt and press `y` only when ready.

## Verification

```bash
nvim --headless \
  -c 'set filetype=mail' \
  -c 'lua print(vim.g.colors_name or "NONE")' \
  -c 'lua print(vim.wo.spell)' \
  -c 'lua print(vim.bo.textwidth)' \
  -c 'qa!'
```

Expected: `mothline`, `true`, and `72`.

## Recovery

The installer creates a timestamped backup beneath `~/.local/state/mothline-backups/`.

```bash
./restore.zsh ~/.local/state/mothline-backups/install-YYYYMMDD-HHMMSS
```

## Exclusions

Never publish NeoMutt accounts, signatures, credentials, OAuth data, Bitwarden sessions, mailboxes, cached messages, drafts, or machine-specific identities.
