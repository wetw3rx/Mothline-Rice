#!/usr/bin/env zsh

set -eu

backup_dir="${1:-}"
if [[ -z "$backup_dir" || ! -d "$backup_dir" ]]; then
    print -u2 "Usage: $0 ~/.local/state/mothline-backups/install-YYYYMMDD-HHMMSS"
    exit 2
fi

print "This replaces installed Mothline directories with the selected backup."
print "Backup: $backup_dir"
print -n "Restore now? [y/N] "
read -r answer
[[ "$answer" == [Yy] ]] || { print "Cancelled."; exit 0; }

for name in niri noctalia gtk-3.0 gtk-4.0 qt6ct kitty fastfetch; do
    if [[ -d "$backup_dir/config/$name" ]]; then
        rm -rf -- "$HOME/.config/$name"
        cp -a "$backup_dir/config/$name" "$HOME/.config/$name"
    fi
done

for name in startpage mothline; do
    if [[ -d "$backup_dir/local-share/$name" ]]; then
        rm -rf -- "$HOME/.local/share/$name"
        cp -a "$backup_dir/local-share/$name" "$HOME/.local/share/$name"
    fi
done

if [[ -f "$backup_dir/local-bin/fastfetch-popup" ]]; then
    cp -a "$backup_dir/local-bin/fastfetch-popup" "$HOME/.local/bin/fastfetch-popup"
fi

if command -v niri >/dev/null 2>&1; then
    niri validate
fi

print "Backup restored."
