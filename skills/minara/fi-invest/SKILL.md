---
name: fi-invest
description: "Buy crypto with USDC — Minara spot buy. Purchase any token by ticker, name, or address. Use when: buy crypto, invest in ETH, buy SOL, purchase tokens, invest USDC."
---

# /fi-invest — Buy crypto with USDC

**Shortcut for `minara swap -s buy`** — buy any token using USDC.

## Usage

`/fi-invest TOKEN AMOUNT`

| Arg | Description | Required |
|-----|-------------|----------|
| TOKEN | Token ticker, name, or contract address | yes |
| AMOUNT | USDC amount to spend | yes |

Examples:
- `/fi-invest ETH 100` — buy 100 USDC worth of ETH
- `/fi-invest SOL 50` — buy 50 USDC worth of SOL
- `/fi-invest BONK 20` — buy 20 USDC worth of BONK

## Execution

1. Parse TOKEN and AMOUNT from user input
2. Run `minara swap -s buy -t 'TOKEN' -a AMOUNT`
3. **This is a fund-moving command** — CLI will show transaction details and ask for confirmation. Relay the confirmation prompt to the user verbatim. Never auto-confirm or use `-y`.
4. Display transaction result

Chain is auto-detected from the token. If a token exists on multiple chains, the CLI prompts the user to pick one.

## Reference

For detailed CLI docs: `{baseDir}/../references/spot-trading.md`
