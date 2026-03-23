---
name: assets
description: "View wallet assets — Minara spot holdings and perps balance with positions. Use when: my assets, portfolio, holdings, spot assets, perps balance, what do I own."
---

# /assets — View wallet assets

**Shortcut for `minara assets`**

## Usage

`/assets [spot|perps]`

| Arg | What it does |
|-----|-------------|
| `spot` | View spot wallet assets across chains |
| `perps` | View perps account balance and positions |
| (none) | Ask user which view they want |

## Execution

### When no argument is provided

Use **AskUserQuestion**:
- Context: "Which assets would you like to view?"
- Options:
  - A) Spot wallet assets (token holdings across chains)
  - B) Perps account (balance and positions on Hyperliquid)
  - C) Both (spot + perps overview)

### `/assets spot` — read-only

Run `minara assets spot`. Display holdings.

### `/assets perps` — read-only

Run `minara assets perps`. Display perps balance and positions.

### Both

Run `minara assets spot` then `minara assets perps`. Display combined overview.

This is a **read-only** command — no confirmation needed.
