#!/usr/bin/env zsh

set -eu

host_alias=""
expect_hardened=0

usage() {
    print "Usage: $0 --host SSH_ALIAS [--expect-hardened]"
}

while (( $# > 0 )); do
    case "$1" in
        --host) [[ $# -ge 2 ]] || { usage; exit 2; }; host_alias="$2"; shift 2 ;;
        --expect-hardened) expect_hardened=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) print -u2 "Unknown option: $1"; usage; exit 2 ;;
    esac
done

[[ -n "$host_alias" ]] || { usage; exit 2; }

hostname_value="$(ssh -G "$host_alias" | awk '/^hostname / { print $2; exit }')"
user_value="$(ssh -G "$host_alias" | awk '/^user / { print $2; exit }')"
identity_value="$(ssh -G "$host_alias" | awk '/^identityfile / { print $2; exit }')"

print "Resolved alias:"
print "  HostName: $hostname_value"
print "  User:     $user_value"
print "  Identity: $identity_value"

ssh -o BatchMode=yes -o ConnectTimeout=5 "$host_alias" true
print "PASS: key-only batch login succeeded."

if (( expect_hardened )); then
    auth_probe="$(ssh -o ConnectTimeout=5 -o PubkeyAuthentication=no -o PreferredAuthentications=none "$host_alias" true 2>&1 || true)"
    if print -r -- "$auth_probe" | grep -Eq 'Permission denied \(publickey\)'; then
        print "PASS: server advertises public-key authentication only."
    else
        print -u2 "FAIL: server did not prove a public-key-only policy."
        print -u2 "$auth_probe"
        exit 1
    fi
fi

print "PASS: Mothline LAN SSH verification complete."
