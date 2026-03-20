# Auth & Account Reference

> **Execute commands yourself.** Only relay verification URLs/codes for user to complete in browser.

## Contents

- [Login](#minara-login) — authenticate (device code preferred)
- [Logout](#minara-logout) — clear credentials
- [Account](#minara-account) — view profile and wallets
- [Config](#minara-config) — CLI settings (Touch ID, base URL)

---

## Commands

### `minara login`

Authenticate with Minara. Two methods available.

**Options:**
- `--email <email>` — email verification code flow
- `--device` — device code flow (opens browser, ideal for headless/agent use)

**Device code flow (preferred for agents):**

```
$ minara login --device
ℹ Starting device login...
ℹ To complete login:
  1. Visit: https://minara.ai/auth/device
  2. Enter code: ABCD-1234
ℹ Waiting for authentication (expires in 15 minutes)...
```

Agent behavior:
1. Execute `minara login --device` yourself.
2. Read the output, extract the verification URL and user code.
3. Relay the URL and code to the user — this is the **only** step the user does manually.
4. Wait for user to confirm browser verification is complete.
5. CLI auto-detects completion and saves credentials to `~/.minara/`.

**Email flow:**

```
$ minara login --email user@example.com
ℹ Verification code sent to user@example.com. Check your inbox.
? Verification code: ______
✔ Welcome, Alice! Credentials saved to ~/.minara/
```

**Post-login:** On macOS with Touch ID, CLI offers to enable fingerprint protection for fund operations.

**Errors:**
- `Failed to send verification code` → invalid email or rate limit
- `Verification failed` → wrong code or expired
- `Device login expired` → re-run `minara login --device`

---

### `minara logout`

Clear local credentials.

**Options:**
- `-y, --yes` — skip confirmation

```
$ minara logout
? Are you sure you want to logout? (y/N) y
✔ Logged out
✔ Local credentials cleared.
```

**Errors:**
- `You are not logged in.` → no credentials found, nothing to do

---

### `minara account`

Display current user profile: name, email, wallet addresses, linked accounts.

Alias: `minara me`

```
$ minara account

Account Info:
  Name        : Alice
  Email       : alice@example.com
  User ID     : 6507abc123...
  Invite Code : INV-XYZ
  Wallets:
    evm           : 0xAbC...123
    solana        : 5xYz...789
    perpetual-evm : 0xDeF...456
  Linked:
    ✔ google
```

**Errors:**
- `Not logged in` → run `minara login` first
- `Failed to fetch account info` → network issue or expired token, re-login

---

### `minara config`

Interactive configuration menu.

**Settings:**
| Setting | Description | Default |
|---|---|---|
| Base URL | API endpoint | `https://api.minara.ai` |
| Touch ID | Require fingerprint for fund ops (macOS only) | OFF |
| Transaction Confirmation | Second confirmation before fund ops | ON |

```
$ minara config
? Configuration: Show current config

Current Configuration:
  Base URL      : https://api.minara.ai
  Touch ID      : Enabled
  Confirm Tx    : Enabled
  Config Dir    : /Users/alice/.minara
```

**Errors:**
- `Touch ID is not available on this device.` → non-macOS or no fingerprint enrolled
- `Base URL must use HTTPS` → HTTP only allowed for localhost

---

## Auth State Detection

Before any authenticated command, check login state:

```bash
minara account --json
```

If it fails → user needs to `minara login`.

## Credential Storage

Credentials stored in `~/.minara/credentials.json`. If `MINARA_API_KEY` env var is set, CLI authenticates automatically without login.
