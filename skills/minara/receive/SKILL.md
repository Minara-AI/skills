---
name: receive
description: "Receive crypto — alias for /deposit. Show deposit addresses, spot-to-perps transfer, or credit card on-ramp. Use when: receive, receive crypto, get deposit address, fund wallet."
---

# /receive — Fund your Minara wallet

**Alias for `/deposit`.** Identical behavior — see `{baseDir}/../deposit/SKILL.md` for full docs.

## Usage

`/receive [spot|perps|buy]`

| Arg | What it does |
|-----|-------------|
| `spot` | Show deposit addresses (receive crypto from external wallet) |
| `perps` | Transfer USDC from spot to perps account |
| `buy` | Buy crypto with credit card (MoonPay) |
| (none) | Ask user which method they want |

## Execution

Follow the exact same flow as `/deposit`:

### When no argument is provided

Use **AskUserQuestion**:
- Context: "How would you like to fund your Minara wallet?"
- Options:
  - A) Show deposit addresses (receive crypto from external wallet)
  - B) Transfer from spot to perps account
  - C) Buy crypto with credit card (MoonPay)

### `/receive spot` — read-only
Run `minara deposit spot`. No confirmation needed.

### `/receive perps` — fund-moving
1. `minara balance` → verify funds
2. AskUserQuestion: A) Confirm transfer / B) Abort
3. `minara deposit perps -a AMOUNT`

### `/receive buy` — opens browser
Run `minara deposit buy` (MoonPay).
