---
name: autopilot
description: "Minara AI autopilot — automated perps trading on Hyperliquid. Enable, disable, or manage AI-driven trading strategies per wallet. Use when: autopilot, auto trade, AI trading, automated strategy."
---

# /autopilot — AI automated perps trading

**Shortcut for `minara perps autopilot`**

## Usage

`/autopilot [WALLET]`

| Arg | Maps to | Default |
|-----|---------|---------|
| WALLET | `--wallet WALLET` | omit (uses default wallet) |

Examples:
- `/autopilot` → open autopilot dashboard (interactive)
- `/autopilot Bot-1` → manage autopilot for wallet Bot-1

## Execution

Run `minara perps autopilot` with `pty: true` (interactive dashboard).

If WALLET is specified, add `--wallet WALLET` to skip the wallet picker.

The autopilot dashboard allows enabling/disabling AI trading and configuring strategy parameters. This is an **interactive** command — the CLI guides the user through options.

**Important:** When autopilot is ON for a wallet, manual orders on that wallet are blocked. If the user tries `/long` or `/short` on an autopilot-active wallet, inform them and use AskUserQuestion:
- Context: "Autopilot is active on wallet [name]. Manual orders are blocked."
- Options:
  - A) Disable autopilot and proceed with manual order
  - B) Use a different wallet
  - C) Cancel

## Reference

For detailed CLI docs: `{baseDir}/../references/perps-trading.md`
