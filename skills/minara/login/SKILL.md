---
name: login
description: "Login to Minara — authenticate via device code or email. Use when: login, sign in, authenticate, connect Minara, setup Minara."
---

# /login — Sign in to Minara

**Shortcut for `minara login`**

## Usage

`/login`

No arguments needed.

## Execution

1. Check if already logged in: run `minara account`
   - If succeeds → inform user they are already logged in, show account info
   - If fails → proceed to login
2. Run `minara login --device` (preferred for Claude Code / headless environments)
3. Relay the verification URL and device code to the user verbatim
4. Wait for user to complete browser verification
5. Confirm login success with `minara account`

Use `pty: true` for the login command.

## Reference

For detailed CLI docs: `{baseDir}/../references/auth-account.md`
