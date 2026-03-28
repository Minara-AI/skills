---
name: price
description: "Quick price check — Minara look up current price for any crypto token or stock. Use when: price of ETH, BTC price, how much is SOL, AAPL price, what's the price."
---

# /price — Quick price lookup

**Shortcut for `minara discover search`** — returns a concise price summary.

## Usage

`/price ASSET`

| Arg | Maps to | Required |
|-----|---------|----------|
| ASSET | `minara discover search ASSET` | yes |

Examples:
- `/price BTC` → current Bitcoin price
- `/price ETH` → current Ethereum price
- `/price AAPL` → current Apple stock price
- `/price gold` → current gold price

## Execution

1. Run `minara discover search ASSET`
2. Extract and display **only the price data** in a concise format:
   - Asset name and ticker
   - Current price
   - 24h change (% and absolute)
3. Do NOT display full search results — keep it brief, one-line if possible

This is a **read-only** command — no confirmation needed.

If the user wants more detail, suggest `/fi-search ASSET` for full results or `/fi-ask` for analysis.

## Reference

For detailed CLI docs: `{baseDir}/../references/ai-market.md`
