---
name: search
description: "Search crypto tokens and stocks — Minara discover search. Look up any token, coin, or stock ticker with real-time data. Use when: search token, find coin, look up ticker, search AAPL, search SOL."
---

# /search — Search tokens and stocks

**Shortcut for `minara discover search`**

## Usage

`/search QUERY`

| Arg | Maps to | Required |
|-----|---------|----------|
| QUERY | `minara discover search QUERY` | yes |

Examples:
- `/search SOL` → search Solana tokens
- `/search BONK` → find BONK token info
- `/search AAPL` → look up Apple stock
- `/search TSLA` → look up Tesla stock
- `/search ethereum` → search by name

## Execution

1. Run `minara discover search QUERY`
2. Display results to user

This is a **read-only** command — no confirmation needed.

## Reference

For detailed CLI docs: `{baseDir}/../references/ai-market.md`
