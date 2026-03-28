---
name: fi-exit
description: "Sell crypto to USDC — Minara spot sell. Sell any token by ticker, name, or address. Supports selling all. Use when: sell crypto, exit position, sell ETH, sell all SOL, cash out."
---

# /fi-exit — Sell crypto to USDC

**Shortcut for `minara swap -s sell`** — sell any token for USDC.

## Usage

`/fi-exit TOKEN AMOUNT`

| Arg | Description | Required |
|-----|-------------|----------|
| TOKEN | Token ticker, name, or contract address | yes |
| AMOUNT | Token amount to sell, or `all` to sell entire balance | yes |

Examples:
- `/fi-exit ETH 0.5` — sell 0.5 ETH for USDC
- `/fi-exit SOL all` — sell entire SOL balance
- `/fi-exit BONK 1000000` — sell 1M BONK for USDC

## Execution

1. Parse TOKEN and AMOUNT from user input
2. If AMOUNT is `all` → run `minara swap -s sell -t 'TOKEN' -a all`
3. Otherwise → run `minara swap -s sell -t 'TOKEN' -a AMOUNT`
4. **This is a fund-moving command** — CLI will show transaction details and ask for confirmation. Relay the confirmation prompt to the user verbatim. Never auto-confirm or use `-y`.
5. Display transaction result

Chain is auto-detected from the token. If a token exists on multiple chains, the CLI prompts the user to pick one.

## Reference

For detailed CLI docs: `{baseDir}/../references/spot-trading.md`
