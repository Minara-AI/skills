---
name: logout
description: "Logout from Minara — clear credentials and session. Use when: logout, sign out, disconnect Minara."
---

# /logout — Sign out of Minara

**Shortcut for `minara logout`**

## Usage

`/logout`

No arguments needed.

## Execution

1. Use **AskUserQuestion** to confirm:
   - Context: "This will clear your Minara session. You will need to login again to use trading commands."
   - Options:
     - A) Logout (Recommended)
     - B) Cancel
2. If A → run `minara logout`, confirm success
3. If B → abort

## Reference

For detailed CLI docs: `{baseDir}/../references/auth-account.md`
