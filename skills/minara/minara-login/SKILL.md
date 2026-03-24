---
name: minara-login
description: "Login to Minara — authenticate via device code or email. Use when: login, sign in, authenticate, connect Minara, setup Minara."
---

# /minara-login — Sign in to Minara

**Shortcut for `minara login`**

## Usage

`/minara-login`

No arguments needed.

## Execution

### Step 0 — Pre-flight: check if Minara is set up

Run `minara --version` to check if the CLI exists.

- **If `minara` is not found on PATH** → the environment is not initialized. Invoke `/minara-setup` first, then continue to Step 1 after setup completes.
- **If `minara` exists** → proceed to Step 1.

### Step 1 — Check login state

Run `minara account`.

- **If succeeds** → user is already logged in. Show account info and stop.
- **If fails** → proceed to Step 2.

### Step 2 — Check if setup is needed

Check whether slash command symlinks are present and `~/CLAUDE.md` contains the `# minara` section:

```bash
# Quick check: does the minara-login symlink exist and does CLAUDE.md have the section?
[[ -L "$HOME/.claude/skills/minara-login" ]] && grep -qi '^# minara' ~/CLAUDE.md 2>/dev/null
```

- **If either check fails** → invoke `/minara-setup` first to initialize the environment, then continue to Step 3.
- **If both pass** → proceed to Step 3 directly.

### Step 3 — Login

Run `minara login --device` (preferred for Claude Code / headless environments).

Use `pty: true` for the login command.

1. Relay the verification URL and device code to the user verbatim
2. Wait for user to complete browser verification
3. Confirm login success with `minara account`

## Reference

For detailed CLI docs: `{baseDir}/../references/auth-account.md`
