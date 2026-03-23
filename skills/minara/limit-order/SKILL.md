---
name: limit-order
description: "Spot limit orders — create, list, cancel crypto limit orders on Minara. Use when: limit order, create limit order, list orders, cancel order, buy at price, sell at price."
---

# /limit-order — Spot limit orders

**Shortcut for `minara limit-order`** (alias: `minara lo`)

## Usage

`/limit-order [create|list|cancel] [ID]`

| Arg | Maps to |
|-----|---------|
| `create` | `minara limit-order create` |
| `list` | `minara limit-order list` |
| `cancel [ID]` | `minara limit-order cancel [ID]` |
| (none) | Ask user what they want |

## Execution

### When no argument is provided

Use **AskUserQuestion**:
- Context: "What would you like to do with spot limit orders?"
- Options:
  - A) Create a new limit order
  - B) List my active limit orders
  - C) Cancel a limit order

### `/limit-order create` — fund-moving

Run `minara limit-order create` with `pty: true` (interactive order builder). Follows standard transaction confirmation flow — never add `-y`.

### `/limit-order list` — read-only

Run `minara limit-order list`. No confirmation needed.

### `/limit-order cancel [ID]` — fund-moving

1. If no ID: run `minara limit-order list` first, let user pick
2. Use **AskUserQuestion**:
   - Context: "Cancel spot limit order [ID / description]"
   - Options:
     - A) Confirm cancellation (Recommended)
     - B) Abort
3. If A → `minara limit-order cancel <ID>`
4. If B → abort

## Note — spot vs perps

This command manages **spot** limit orders only. For **perps** orders on Hyperliquid, use `/close-order perps-order` to cancel or `/perps` to manage.
