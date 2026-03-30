# Spot Limit Orders

> Execute commands yourself. Use `pty: true` for interactive prompts.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Create limit order | `minara limit-order create` | fund-moving |
| List active orders | `minara limit-order list` | read-only |
| Cancel order by ID | `minara limit-order cancel [ID]` | fund-moving |

**Alias:** `minara lo` = `minara limit-order`

**Default (no subcommand):** interactive submenu — create / list / cancel.

## `minara limit-order create`

Fully interactive builder. Use `pty: true`.

**Options:** `-y, --yes` — skip confirmation

**Flow:** Chain → Side (buy/sell) → Token → Price condition (above/below) → Target price → Amount (USD) → Expiry (hours)

```
Limit Order:
  Chain: base · Side: buy · Token: PEPE (0xAbc...)
  Condition: price below $0.000012 · Amount: $100
  Expires: 3/17/2026, 2:30 PM
🔒 Transaction confirmation required.
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Limit order created!
```

## `minara limit-order list`

**Alias:** `minara limit-order ls`, `minara lo list`

Lists all active orders in a table. Read-only.

## `minara limit-order cancel [ID]`

**Alias:** `minara lo cancel`

If no ID given → interactive picker from active orders. Confirm before canceling.

**Note:** These are **spot** limit orders. For perps limit orders → see `perps-order.md`.
