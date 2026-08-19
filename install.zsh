#!/usr/bin/env zsh

set -eu

repo_dir="${0:A:h}"
stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$HOME/.local/state/mothline-backups/install-$stamp"

print "Mothline will install Niri, Noctalia, Kitty, Fastfetch and start-page files."
print "Existing configuration will be backed up to:"
print "  $backup_dir"
print -n "Continue? [y/N] "
read -r answer
[[ "$answer" == [Yy] ]] || { print "Cancelled."; exit 0; }

mkdir -p "$backup_dir/config" "$backup_dir/local-share" "$backup_dir/local-bin"

for name in niri noctalia kitty fastfetch; do
    if [[ -e "$HOME/.config/$name" ]]; then
        cp -a "$HOME/.config/$name" "$backup_dir/config/$name"
    fi
done

if [[ -e "$HOME/.local/share/startpage" ]]; then
    cp -a "$HOME/.local/share/startpage" "$backup_dir/local-share/startpage"
fi
if [[ -e "$HOME/.local/share/mothline" ]]; then
    cp -a "$HOME/.local/share/mothline" "$backup_dir/local-share/mothline"
fi
if [[ -e "$HOME/.local/bin/fastfetch-popup" ]]; then
    cp -a "$HOME/.local/bin/fastfetch-popup" "$backup_dir/local-bin/fastfetch-popup"
fi

mkdir -p \
    "$HOME/.config/niri" \
    "$HOME/.config/noctalia" \
    "$HOME/.config/kitty" \
    "$HOME/.config/fastfetch" \
    "$HOME/.local/share/startpage" \
    "$HOME/.local/share/mothline" \
    "$HOME/.local/bin"

cp -a "$repo_dir/config/niri/." "$HOME/.config/niri/"
cp -a "$repo_dir/config/noctalia/." "$HOME/.config/noctalia/"
cp -a "$repo_dir/config/kitty/." "$HOME/.config/kitty/"
cp -a "$repo_dir/config/fastfetch/." "$HOME/.config/fastfetch/"
cp -a "$repo_dir/startpage/." "$HOME/.local/share/startpage/"
cp -a "$repo_dir/assets/mothline-lockscreen.png" "$HOME/.local/share/mothline/"
cp -a "$repo_dir/assets/moth-avatar.png" "$HOME/.local/share/mothline/"
cp -a "$repo_dir/bin/fastfetch-popup" "$HOME/.local/bin/fastfetch-popup"
chmod +x "$HOME/.local/bin/fastfetch-popup"

# Resolve portable asset placeholders only in the installed copy.
sed -i "s|@HOME@|$HOME|g" "$HOME/.config/noctalia/lockscreen.toml"

if command -v niri >/dev/null 2>&1; then
    if ! niri validate; then
        print -u2 "Niri validation failed. Your backup is at: $backup_dir"
        print -u2 "Run: $repo_dir/restore.zsh '$backup_dir'"
        exit 1
    fi
fi

print
print "Mothline installed successfully."
print "Backup: $backup_dir"
print "Start page: file://$HOME/.local/share/startpage/start.html"
print "Log out and back in if ~/.local/bin was not already on PATH."
