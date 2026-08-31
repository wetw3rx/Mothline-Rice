# Mothline LAN-Only SSH

This opt-in module configures a trusted Linux client and a CachyOS/Arch server for key-based SSH over a private LAN. It is intentionally separate from `install.zsh` because SSH, firewall, and authentication changes require explicit review.

## Security model

- No router port-forwarding for TCP/22.
- One explicitly supplied client address is allowed through UFW.
- Private keys, public keys, `authorized_keys`, `known_hosts`, passwords, and live addresses are never stored in this repository.
- Server hardening occurs only after key login has been proven.
- Existing files are backed up before replacement.
- `sshd -t` must pass before reload.

## 1. Client alias

On the client machine:

```zsh
./scripts/ssh/setup-client.zsh \
  --host covenant \
  --address CURRENT_SERVER_ADDRESS \
  --user YOUR_USER \
  --identity ~/.ssh/YOUR_DEDICATED_PRIVATE_KEY
```

Review the dry run, then add `--apply`.

The script writes a managed fragment beneath `~/.ssh/config.d/` and adds the corresponding `Include` line to `~/.ssh/config` when needed.

## 2. Initial server setup

Securely place only the client's public key on the server, then run:

```zsh
./scripts/ssh/setup-server.zsh \
  --allow-from CURRENT_CLIENT_ADDRESS \
  --user YOUR_USER \
  --public-key-file /path/to/client-key.pub
```

Review the dry run, then add `--apply`. Add `--enable-firewall` only after reviewing existing UFW rules.

The first pass deliberately leaves password authentication available as an emergency path while key access is being established.

## 3. Prove key access

From the client:

```zsh
./scripts/ssh/verify-connection.zsh --host covenant
```

Do not proceed unless this succeeds.

## 4. Harden the server

On the server, repeat the setup command with `--apply --harden`. This disables password and keyboard-interactive authentication and requires public-key authentication.

From the client, verify the final policy:

```zsh
./scripts/ssh/verify-connection.zsh --host covenant --expect-hardened
```

Keep the successful client session open until a second independent connection also succeeds.

## 5. Final firewall review

Run `ufw status numbered` on the server. Keep the exact trusted-client rule. Remove an older broad subnet rule only after the exact rule and key-only login are proven.

## Address stability

A source-address firewall rule depends on stable LAN addressing. Use DHCP reservations for both peers or re-run the module after an address change.

## Recovery

Backups use a `.before-YYYYMMDD-HHMMSS` suffix. If a validation step fails, the server installer automatically restores or removes its managed SSH drop-in. Recovery may also be performed locally through the server console.
