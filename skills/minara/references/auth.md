# Auth / Account / Config

> Execute commands yourself. Only relay verification URLs/codes for user to complete in browser.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Login (device code) | `minara login --device` | auth |
| Login (email) | `minara login --email user@example.com` | auth |
| Logout | `minara logout` | auth |
| Account info | `minara account` | read-only |
| Account (all wallets) | `minara account --show-all` | read-only |
| Config settings | `minara config` | config |

## `minara login`

**Options:** `--email <email>`, `--device`

### Device code flow (preferred for agents)

```
$ minara login --device
ℹ To complete login:
  1. Visit: https://minara.ai/auth/device
  2. Enter code: ABCD-1234
ℹ Waiting for authentication (expires in 15 minutes)...
```

1. Run `minara login --device` with `pty: true`
2. Extract and relay URL + code to user — the **only** manual step
3. Wait for user to confirm browser verification
4. CLI auto-detects completion and saves to `~/.minara/`

### Email flow

```
$ minara login --email user@example.com
ℹ Verification code sent. Check inbox.
? Verification code: ______
✔ Welcome, Alice!
```

**Post-login:** On macOS, CLI offers Touch ID setup for fund operations.

If already logged in, CLI confirms and shows current account.

**Errors:** `Failed to send verification code`, `Verification failed`, `Device login expired`

## `minara logout`

**Options:** `-y, --yes`

```
$ minara logout
? Are you sure? (y/N) y
✔ Logged out. Local credentials cleared.
```

## `minara account`

**Alias:** `minara me`

**Options:** `--show-all` — show all wallet types (default filters to primary wallets)

```
Account Info:
  Name: Alice · Email: alice@example.com · User ID: 6507abc...
  Wallets:
    evm:           0xAbC...123
    solana:        5xYz...789
    perpetual-evm: 0xDeF...456
  Linked: ✔ google
```

**Errors:** `Not logged in`, `Failed to fetch account info`

## `minara config`

Fully interactive settings menu. No CLI flags.

**Settings:**
| Setting | Description |
|---------|-------------|
| Base URL | API endpoint (default `https://api.minara.ai`) |
| Touch ID | Fingerprint for fund ops (macOS only) |
| Transaction Confirmation | Second confirm before fund ops |

## Auth state detection

Check login before authenticated commands:
```bash
minara account --json
```
If fails → user needs `minara login`.

Credentials: `~/.minara/credentials.json`. `MINARA_API_KEY` env var bypasses login.
