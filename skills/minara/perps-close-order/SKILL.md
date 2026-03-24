---
name: perps-close-order
description: "Close perps positions or cancel perps orders — Minara close perpetual futures positions, cancel open perps orders. Use when: close perps, cancel perps order, exit perps position, close perps position."
---

# /perps-close-order — Close perps positions or cancel perps orders

Handles **two distinct operations**. Use AskUserQuestion to disambiguate if unclear.

## Usage

`/perps-close-order [position|order] [SYMBOL|all]`

## The two types

### 1. Close perps positions — `/perps-close-order position`

Close open perpetual futures positions at market price.

| Usage | Maps to |
|-------|---------|
| `/perps-close-order position all` | `minara perps close --all` |
| `/perps-close-order position BTC` | `minara perps close --symbol BTC` |
| `/perps-close-order position` | `minara perps close` (interactive picker) |

**Fund-moving** — requires confirmation:
1. Run `minara perps positions` to show current positions
2. AskUserQuestion:
   - Context: "Close {all / SYMBOL} perps positions. Current: [list from step 1]"
   - Options: A) Confirm and close (Recommended) / B) Abort
3. Execute with `pty: true`. Add `--wallet WALLET` if specified.

### 2. Cancel perps orders — `/perps-close-order order`

Cancel open (unfilled) perpetual futures orders.

| Usage | Maps to |
|-------|---------|
| `/perps-close-order order` | `minara perps cancel` (interactive picker) |

**Fund-moving** — requires confirmation:
1. AskUserQuestion:
   - Context: "Cancel open perps orders"
   - Options: A) Confirm / B) Abort
2. Run `minara perps cancel` with `pty: true`. Add `--wallet WALLET` if specified.

## When type is not specified

If user just says `/perps-close-order` without specifying the type, use **AskUserQuestion**:

- Context: "What would you like to do?"
- Options:
  - A) Close perps positions (exit open trades at market price)
  - B) Cancel perps orders (unfilled limit/stop orders)

Then proceed with the selected flow.

## Note — perps vs spot

This command manages **perps** positions and orders only. For **spot** limit order cancellation, use `/close-order`.
