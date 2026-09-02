#!/usr/bin/env zsh

set -eu

repo_dir="${0:A:h}"
profile=""

while (( $# > 0 )); do
    case "$1" in
        --profile)
            (( $# >= 2 )) || {
                print -u2 "Missing profile name after --profile."
                exit 2
            }
            profile="$2"
            shift 2
            ;;
        -h|--help)
            print "Usage: ./install.zsh [--profile NAME]"
            print
            print "Available profiles:"
            if [[ -d "$repo_dir/profiles" ]]; then
                find "$repo_dir/profiles" -mindepth 1 -maxdepth 1 \
                    -type d -printf "  %f\n" | sort
            fi
            exit 0
            ;;
        *)
            print -u2 "Unknown option: $1"
            exit 2
            ;;
    esac
done

profile_dir=""
if [[ -n "$profile" ]]; then
    profile_dir="$repo_dir/profiles/$profile"
    [[ -d "$profile_dir" ]] || {
        print -u2 "Unknown Mothline profile: $profile"
        exit 2
    }
fi

stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$HOME/.local/state/mothline-backups/install-$stamp"

print "Mothline will install Niri, Noctalia, GTK, Qt6ct, Kitty, Fastfetch, Fluxer, Obsidian theme assets, SDDM staging files, and start-page files."
[[ -n "$profile" ]] && print "Machine profile: $profile"
print "Existing configuration will be backed up to:"
print "  $backup_dir"
print -n "Continue? [y/N] "
read -r answer
[[ "$answer" == [Yy] ]] || { print "Cancelled."; exit 0; }

mkdir -p "$backup_dir/config" "$backup_dir/local-share" "$backup_dir/local-bin"

for name in niri noctalia gtk-3.0 gtk-4.0 qt6ct kitty fastfetch fluxer; do
    if [[ -e "$HOME/.config/$name" ]]; then
        cp -a "$HOME/.config/$name" "$backup_dir/config/$name"
    fi
done

if [[ -e "$HOME/.config/obsidian" ]]; then
    cp -a "$HOME/.config/obsidian" "$backup_dir/config/obsidian"
fi

if [[ -e "$HOME/.local/share/startpage" ]]; then
    cp -a "$HOME/.local/share/startpage" "$backup_dir/local-share/startpage"
fi

if [[ -e "$HOME/.local/share/mothline" ]]; then
    cp -a "$HOME/.local/share/mothline" "$backup_dir/local-share/mothline"
fi

if [[ -e "$HOME/.local/share/mothline-sddm" ]]; then
    cp -a "$HOME/.local/share/mothline-sddm" "$backup_dir/local-share/mothline-sddm"
fi

for name in fastfetch-popup nocta-v5-restart mothline-check-update; do
    [[ -e "$HOME/.local/bin/$name" ]] && cp -a "$HOME/.local/bin/$name" "$backup_dir/local-bin/$name"
done

if [[ -e "$HOME/.local/share/applications/nv5restart.desktop" ]]; then
    mkdir -p "$backup_dir/local-share/applications"
    cp -a "$HOME/.local/share/applications/nv5restart.desktop" \
        "$backup_dir/local-share/applications/nv5restart.desktop"
fi

mkdir -p \
    "$HOME/.config/niri" \
    "$HOME/.config/noctalia" \
    "$HOME/.config/gtk-3.0" \
    "$HOME/.config/gtk-4.0" \
    "$HOME/.config/qt6ct" \
    "$HOME/.config/kitty" \
    "$HOME/.config/fastfetch" \
    "$HOME/.config/fluxer" \
    "$HOME/.config/obsidian/snippets" \
    "$HOME/.local/share/startpage" \
    "$HOME/.local/share/mothline" \
    "$HOME/.local/share/mothline-sddm" \
    "$HOME/.local/share/applications" \
    "$HOME/.local/bin"

cp -a "$repo_dir/config/niri/." "$HOME/.config/niri/"
cp -a "$repo_dir/config/noctalia/." "$HOME/.config/noctalia/"
cp -a "$repo_dir/config/gtk-3.0/." "$HOME/.config/gtk-3.0/"
cp -a "$repo_dir/config/gtk-4.0/." "$HOME/.config/gtk-4.0/"
cp -a "$repo_dir/config/qt6ct/." "$HOME/.config/qt6ct/"
cp -a "$repo_dir/config/kitty/." "$HOME/.config/kitty/"
cp -a "$repo_dir/config/fastfetch/." "$HOME/.config/fastfetch/"
cp -a "$repo_dir/config/fluxer/." "$HOME/.config/fluxer/"
cp -a "$repo_dir/config/obsidian/.obsidian/snippets/mothline.css" "$HOME/.config/obsidian/snippets/mothline.css"
cp -a "$repo_dir/config/sddm-mothline/." "$HOME/.local/share/mothline-sddm/"
cp -a "$repo_dir/startpage/." "$HOME/.local/share/startpage/"
cp -a "$repo_dir/assets/mothline-lockscreen.png" "$HOME/.local/share/mothline/"
cp -a "$repo_dir/assets/moth-avatar.png" "$HOME/.local/share/mothline/"
if [[ -d "$repo_dir/assets/wallpapers" ]]; then
    cp -a "$repo_dir/assets/wallpapers/." "$HOME/.local/share/mothline/"
fi

if [[ -n "$profile_dir" && -d "$profile_dir/config" ]]; then
    cp -a "$profile_dir/config/." "$HOME/.config/"
fi

for name in fastfetch-popup nocta-v5-restart mothline-check-update; do
    cp -a "$repo_dir/bin/$name" "$HOME/.local/bin/$name"
    chmod +x "$HOME/.local/bin/$name"
done

cp -a "$repo_dir/examples/nv5restart.desktop" \
    "$HOME/.local/share/applications/nv5restart.desktop"

# Resolve portable asset placeholders only in the installed copy.
find "$HOME/.config/noctalia" -type f -name "*.toml" -exec \
    sed -i "s|@HOME@|$HOME|g" {} +
sed -i "s|@HOME@|$HOME|g" "$HOME/.config/qt6ct/qt6ct.conf"

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
print "Fluxer CSS: $HOME/.config/fluxer/mothline-fluxer-canary.css"
print "Obsidian CSS snippet: $HOME/.config/obsidian/snippets/mothline.css"
print "SDDM theme staged at: $HOME/.local/share/mothline-sddm"
print
print "System-wide SDDM installation requires administrator privileges."
print "The bundled installer resolves assets relative to itself and does not rely on root's HOME."
print "It will not restart SDDM automatically."
print -n "Install the Mothline SDDM theme system-wide now? [y/N] "
read -r sddm_answer
if [[ "$sddm_answer" == [Yy] ]]; then
    sudo "$HOME/.local/share/mothline-sddm/install.sh"
else
    print "SDDM system installation skipped."
    print "Later run: sudo \"$HOME/.local/share/mothline-sddm/install.sh\""
fi
print
print "Run: noctalia msg templates-apply after enabling GTK 3/4 and KColorScheme templates."
print "Log out and back in to apply Qt platform-theme or PATH changes."
