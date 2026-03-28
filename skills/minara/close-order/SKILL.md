---
name: close-order
description: "Cancel spot limit orders — Minara cancel pending spot limit orders. Use when: cancel spot order, cancel limit order, close spot order, remove spot order."
---

# /close-order — Cancel spot limit orders

Cancel spot limit orders created via `minara limit-order create`.

## Usage

`/close-order [ID]`

| Usage | Maps to |
|-------|---------|
| `/close-order` | `minara limit-order list` then `minara limit-order cancel <id>` |
| `/close-order <ID>` | `minara limit-order cancel <ID>` |

## Execution

**Fund-moving** — requires confirmation:
1. If no ID: run `minara limit-order list` to show active orders, let user pick
2. AskUserQuestion:
   - Context: "Cancel spot limit order [ID / description]"
   - Options: A) Confirm / B) Abort
3. Run `minara limit-order cancel <ID>`

## Note — spot vs perps

This command manages **spot** limit orders only. For closing perps positions or canceling perps orders, use `/perps-close-order`.
