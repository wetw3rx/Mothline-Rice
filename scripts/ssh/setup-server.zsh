#!/usr/bin/env zsh

set -eu

allow_from=""
target_user=""
public_key_file=""
apply=0
harden=0
enable_firewall=0

usage() {
    print "Usage: $0 --allow-from HOST_OR_IP --user USER --public-key-file FILE [--apply] [--harden] [--enable-firewall]"
    print "Run once without --harden, verify key login, then re-run with --harden."
    print "Without --apply, this script reports the proposed policy and changes nothing."
}

while (( $# > 0 )); do
    case "$1" in
        --allow-from) [[ $# -ge 2 ]] || { usage; exit 2; }; allow_from="$2"; shift 2 ;;
        --user) [[ $# -ge 2 ]] || { usage; exit 2; }; target_user="$2"; shift 2 ;;
        --public-key-file) [[ $# -ge 2 ]] || { usage; exit 2; }; public_key_file="$2"; shift 2 ;;
        --apply) apply=1; shift ;;
        --harden) harden=1; shift ;;
        --enable-firewall) enable_firewall=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) print -u2 "Unknown option: $1"; usage; exit 2 ;;
    esac
done

[[ -n "$allow_from" && -n "$target_user" && -n "$public_key_file" ]] || {
    usage
    exit 2
}

public_key_file="${public_key_file/#\~/$HOME}"
id "$target_user" >/dev/null 2>&1 || {
    print -u2 "User does not exist: $target_user"
    exit 1
}
[[ -f "$public_key_file" ]] || {
    print -u2 "Public key file not found: $public_key_file"
    exit 1
}

key_line="$(<"$public_key_file")"
[[ "$key_line" == ssh-* ]] || {
    print -u2 "The supplied file does not look like an OpenSSH public key."
    exit 1
}

print "Proposed Mothline SSH server policy:"
print "  User:              $target_user"
print "  Allowed peer:      $allow_from"
print "  Public key source: $public_key_file"
print "  Password login:    $([[ $harden == 1 ]] && print disabled || print temporarily enabled)"
print "  Enable UFW:        $([[ $enable_firewall == 1 ]] && print yes || print no)"
print "  Router forwarding: never"

(( apply )) || {
    print "Dry run only. Re-run with --apply to install."
    exit 0
}

as_root() {
    if (( EUID == 0 )); then
        command "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    elif command -v pkexec >/dev/null 2>&1; then
        pkexec "$@"
    else
        print -u2 "Need root privileges, but neither sudo nor pkexec is available."
        return 1
    fi
}

if command -v pacman >/dev/null 2>&1; then
    as_root pacman -S --needed --noconfirm openssh ufw
else
    print -u2 "This installer currently supports Arch/CachyOS hosts with pacman."
    exit 1
fi

home_dir="$(getent passwd "$target_user" | cut -d: -f6)"
group_name="$(id -gn "$target_user")"
ssh_dir="$home_dir/.ssh"
authorized_keys="$ssh_dir/authorized_keys"

as_root install -d -m 700 -o "$target_user" -g "$group_name" "$ssh_dir"
as_root touch "$authorized_keys"
if ! as_root grep -qxF "$key_line" "$authorized_keys" 2>/dev/null; then
    print -r -- "$key_line" | as_root tee -a "$authorized_keys" >/dev/null
fi
as_root chown "$target_user:$group_name" "$authorized_keys"
as_root chmod 600 "$authorized_keys"

dropin_dir="/etc/ssh/sshd_config.d"
dropin="$dropin_dir/99-mothline-lan.conf"
stamp="$(date +%Y%m%d-%H%M%S)"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

{
    print "# Managed by Mothline-Rice scripts/ssh/setup-server.zsh"
    print "PermitRootLogin no"
    print "PubkeyAuthentication yes"
    print "X11Forwarding no"
    print "AllowAgentForwarding no"
    print "AllowTcpForwarding no"
    if (( harden )); then
        print "PasswordAuthentication no"
        print "KbdInteractiveAuthentication no"
        print "AuthenticationMethods publickey"
    else
        print "PasswordAuthentication yes"
        print "KbdInteractiveAuthentication yes"
    fi
} > "$tmp"

as_root install -d -m 755 "$dropin_dir"
if as_root test -f "$dropin"; then
    as_root cp -a "$dropin" "$dropin.before-$stamp"
fi
as_root install -m 600 "$tmp" "$dropin"

if ! as_root sshd -t; then
    print -u2 "sshd validation failed. Restoring previous drop-in."
    if as_root test -f "$dropin.before-$stamp"; then
        as_root cp -a "$dropin.before-$stamp" "$dropin"
    else
        as_root rm -f "$dropin"
    fi
    exit 1
fi

if ! as_root ufw status | grep -Fq "$allow_from"; then
    as_root ufw allow proto tcp from "$allow_from" to any port 22 comment "Mothline SSH peer"
fi

if (( enable_firewall )); then
    as_root ufw --force enable
elif as_root ufw status | grep -q '^Status: inactive'; then
    print "NOTICE: UFW rule added, but UFW remains inactive. Re-run with --enable-firewall after reviewing existing rules."
fi

as_root systemctl enable --now sshd
as_root systemctl reload sshd

print "PASS: OpenSSH configured and validated."
if (( harden )); then
    print "PASS: password and keyboard-interactive authentication disabled."
else
    print "NEXT: verify key login from the client before re-running with --harden."
fi
print "Review UFW and remove any older broad LAN SSH rule only after the exact peer rule is proven."
