#!/usr/bin/env zsh

set -eu

host_alias=""
address=""
remote_user=""
identity_file=""
apply=0

usage() {
    print "Usage: $0 --host NAME --address HOST_OR_IP --user USER --identity KEY_PATH [--apply]"
    print "Without --apply, this script only prints the proposed configuration."
}

while (( $# > 0 )); do
    case "$1" in
        --host) [[ $# -ge 2 ]] || { usage; exit 2; }; host_alias="$2"; shift 2 ;;
        --address) [[ $# -ge 2 ]] || { usage; exit 2; }; address="$2"; shift 2 ;;
        --user) [[ $# -ge 2 ]] || { usage; exit 2; }; remote_user="$2"; shift 2 ;;
        --identity) [[ $# -ge 2 ]] || { usage; exit 2; }; identity_file="$2"; shift 2 ;;
        --apply) apply=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) print -u2 "Unknown option: $1"; usage; exit 2 ;;
    esac
done

[[ -n "$host_alias" && -n "$address" && -n "$remote_user" && -n "$identity_file" ]] || {
    usage
    exit 2
}

identity_file="${identity_file/#\~/$HOME}"
[[ -f "$identity_file" ]] || {
    print -u2 "Identity file not found: $identity_file"
    exit 1
}

config_dir="$HOME/.ssh/config.d"
config_file="$HOME/.ssh/config"
target="$config_dir/mothline-$host_alias.conf"

render() {
    print "Host $host_alias"
    print "    HostName $address"
    print "    User $remote_user"
    print "    IdentityFile $identity_file"
    print "    IdentitiesOnly yes"
    print "    ServerAliveInterval 30"
}

print "Proposed SSH client fragment:"
render
print
print "Target: $target"

(( apply )) || {
    print "Dry run only. Re-run with --apply to install."
    exit 0
}

stamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$config_dir"
chmod 700 "$HOME/.ssh" "$config_dir"

if [[ -e "$target" ]]; then
    cp -a "$target" "$target.before-$stamp"
fi

render > "$target"
chmod 600 "$target"

if [[ ! -f "$config_file" ]]; then
    print "Include ~/.ssh/config.d/*" > "$config_file"
elif ! grep -Eq '^[[:space:]]*Include[[:space:]]+~/.ssh/config.d/\*' "$config_file"; then
    cp -a "$config_file" "$config_file.before-mothline-$stamp"
    tmp="$(mktemp)"
    {
        print "Include ~/.ssh/config.d/*"
        cat "$config_file"
    } > "$tmp"
    mv "$tmp" "$config_file"
fi
chmod 600 "$config_file"

resolved="$(ssh -G "$host_alias" | awk '/^hostname / { print $2; exit }')"
[[ "$resolved" == "$address" ]] || {
    print -u2 "Validation failed: alias resolves to '$resolved', expected '$address'."
    exit 1
}

print "PASS: SSH alias '$host_alias' resolves to '$address'."
print "Next: scripts/ssh/verify-connection.zsh --host '$host_alias'"
