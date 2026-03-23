---
name: withdraw
description: "Withdraw crypto from Minara wallet to external address. Use when: withdraw, send to external wallet, withdraw ETH, withdraw USDC, cash out."
---

# /withdraw — Withdraw to external address

**Shortcut for `minara withdraw`**

## Usage

`/withdraw [AMOUNT TOKEN to ADDRESS]`

| Arg | Maps to | Required |
|-----|---------|----------|
| AMOUNT | `-a AMOUNT` | yes |
| TOKEN | `-t TOKEN` | yes |
| ADDRESS | `--to ADDRESS` | yes |
| CHAIN | `-c CHAIN` | optional (auto-detected) |

Examples:
- `/withdraw 10 USDC to 0x1234...` → withdraw 10 USDC
- `/withdraw 0.5 ETH to 0xabcd...` → withdraw 0.5 ETH
- `/withdraw` → interactive mode

## Execution

This is a **fund-moving** command — requires confirmation.

1. Run `minara balance` to verify sufficient funds
2. Use **AskUserQuestion** to confirm:
   - Context: "Withdraw {AMOUNT} {TOKEN} to {ADDRESS}"
   - Options:
     - A) Confirm and execute (Recommended)
     - B) Abort
3. If A → `minara withdraw -t TOKEN -a AMOUNT --to ADDRESS` (add `-c CHAIN` if specified)
4. If B → abort, report "Withdrawal cancelled."

If no arguments provided, run `minara withdraw` with `pty: true` (interactive mode).

**Never add `-y`** unless user explicitly asks.
