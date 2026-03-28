---
name: deposit
description: "Deposit crypto — Minara fund wallet via deposit address, spot-to-perps transfer, or credit card (MoonPay). Use when: deposit, fund wallet, on-ramp, credit card, add funds."
---

# /deposit — Fund your Minara wallet

**Shortcut for `minara deposit`**

## Usage

`/deposit [spot|perps|buy]`

| Arg | What it does |
|-----|-------------|
| `spot` | Show deposit addresses (receive crypto from external wallet) |
| `perps` | Transfer USDC from spot to perps account |
| `buy` | Buy crypto with credit card (MoonPay) |
| (none) | Ask user which method they want |

Examples:
- `/deposit` → ask which deposit method
- `/deposit spot` → show deposit addresses
- `/deposit perps` → transfer spot → perps
- `/deposit buy` → credit card on-ramp

## Execution

### When no argument is provided

Use **AskUserQuestion** to ask which deposit method:
- Context: "How would you like to fund your Minara wallet?"
- Options:
  - A) Show deposit addresses (receive crypto from external wallet)
  - B) Transfer from spot to perps account
  - C) Buy crypto with credit card (MoonPay)

### `/deposit spot` — read-only

Run `minara deposit spot`. Displays deposit addresses per chain. No confirmation needed.

### `/deposit perps` — fund-moving

1. Run `minara balance` to check spot balance
2. Use **AskUserQuestion** to confirm:
   - Context: "Transfer USDC from spot to perps account"
   - Options:
     - A) Confirm transfer (Recommended)
     - B) Abort
3. If A → `minara deposit perps -a AMOUNT` (use `pty: true`, add `--wallet WALLET` if specified)
4. If B → abort

### `/deposit buy` — opens browser

Run `minara deposit buy` (opens MoonPay in browser). Inform the user to complete the purchase in the browser window.

## Reference

For detailed CLI docs: `{baseDir}/../references/wallet-funds.md`
