---
name: close-order
description: "Close or cancel orders — Minara cancel spot limit orders, close perps positions, cancel perps orders. Use when: close order, cancel order, cancel limit order, close position, exit trade."
---

# /close-order — Close positions or cancel orders

Handles **three distinct operations**. Use AskUserQuestion to disambiguate if unclear.

## Usage

`/close-order [perps-position|perps-order|spot-order] [SYMBOL|all]`

## The three types

### 1. Close perps positions — `/close-order perps-position`

Close open perpetual futures positions.

| Usage | Maps to |
|-------|---------|
| `/close-order perps-position all` | `minara perps close --all` |
| `/close-order perps-position BTC` | `minara perps close --symbol BTC` |
| `/close-order perps-position` | `minara perps close` (interactive picker) |

**Fund-moving** — requires confirmation:
1. Run `minara perps positions` to show current positions
2. AskUserQuestion:
   - Context: "Close {all / SYMBOL} perps positions. Current: [list from step 1]"
   - Options: A) Confirm and close (Recommended) / B) Abort
3. Execute with `pty: true`

### 2. Cancel perps orders — `/close-order perps-order`

Cancel open (unfilled) perpetual futures orders.

| Usage | Maps to |
|-------|---------|
| `/close-order perps-order` | `minara perps cancel` (interactive picker) |

**Fund-moving** — requires confirmation:
1. AskUserQuestion:
   - Context: "Cancel open perps orders"
   - Options: A) Confirm / B) Abort
2. Run `minara perps cancel` with `pty: true`

### 3. Cancel spot limit orders — `/close-order spot-order`

Cancel spot limit orders created via `minara limit-order create`.

| Usage | Maps to |
|-------|---------|
| `/close-order spot-order` | `minara limit-order list` then `minara limit-order cancel <id>` |
| `/close-order spot-order <ID>` | `minara limit-order cancel <ID>` |

**Fund-moving** — requires confirmation:
1. If no ID: run `minara limit-order list` to show active orders, let user pick
2. AskUserQuestion:
   - Context: "Cancel spot limit order [ID / description]"
   - Options: A) Confirm / B) Abort
3. Run `minara limit-order cancel <ID>`

## When type is not specified

If user just says `/close-order` or `/close-order BTC` without specifying the type, use **AskUserQuestion**:

- Context: "What would you like to close or cancel?"
- Options:
  - A) Close perps positions (exit open trades)
  - B) Cancel perps orders (unfilled limit/stop orders on Hyperliquid)
  - C) Cancel spot limit orders (pending spot limit orders)

Then proceed with the selected flow.

## Reference

- Perps positions/orders: `{baseDir}/../references/perps-trading.md`
- Spot limit orders: `{baseDir}/../references/spot-trading.md`
