# Market Discovery

> Execute commands yourself. All read-only — no confirmation needed.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Trending tokens | `minara discover trending --type tokens` | read-only |
| Trending stocks | `minara discover trending --type stocks` | read-only |
| Search tokens | `minara discover search QUERY --type tokens` | read-only |
| Search stocks | `minara discover search QUERY --type stocks` | read-only |
| Fear & Greed index | `minara discover fear-greed` | read-only |
| Bitcoin metrics | `minara discover btc-metrics` | read-only |
| Quick price check | `minara discover search ASSET --type tokens` | read-only |

**Default (no subcommand):** interactive submenu.

## `minara discover trending`

**Options:** `-t, --type <tokens|stocks>` — skip interactive category picker

```
$ minara discover trending --type tokens

Trending Tokens:
  Symbol  Name     Price     24h Change  Volume      Market Cap
  BONK    Bonk     $0.00001  +15.2%      $50M        $600M
  PEPE    Pepe     $0.00001  +8.3%       $120M       $4.2B
```

If no `--type` and no argument: interactive picker (tokens vs stocks). Non-TTY defaults to tokens.

## `minara discover search [keyword]`

**Options:** `-t, --type <tokens|stocks>` — skip interactive type picker

```
$ minara discover search SOL --type tokens

Search Results for "SOL":
  Symbol  Name     Address        Chain    Price    Market Cap
  SOL     Solana   So11...111     solana   $25.00   $10.5B
```

Prompts keyword if missing. Non-TTY defaults type to tokens.

### Price lookup pattern

For `/price ASSET`: run `minara discover search ASSET --type tokens`, then extract and present **only the price** concisely (name, price, 24h change).

### Multiple results — how to pick

Search often returns several tokens with the same symbol (same name, different chains or contract addresses). When this happens:

1. **Pick the highest market cap result** — this is almost always the canonical token the user means.
2. If two results have similar market caps, present both (symbol + chain + market cap) and ask the user to confirm which one.
3. Never silently pick a low-market-cap result when a high-market-cap one exists with the same symbol.

### xStocks vs real stocks

`--type stocks` returns **xStocks** — tokenized stocks on Solana (e.g. NVDAx, AAPLx). These are **not** real NASDAQ/NYSE equities. Before searching for a stock ticker:

1. Clarify to the user: "Minara trades tokenized stocks (xStocks on Solana), not real exchange shares."
2. If the user confirms they want the xStock version, search with `--type stocks`.
3. If the user wants a real stock quote/analysis (no trading intent), use `minara ask` or `minara research` instead.

## `minara discover fear-greed`

```
Fear & Greed Index:
  Value: 72 · Label: Greed
  ████████████████████░░░░░░░░░░  72/100
```

## `minara discover btc-metrics`

```
Bitcoin Metrics:
  Price: $66,500 · Market Cap: $1.3T · Dominance: 52.3%
  Hashrate: 580 EH/s · Supply: 19,650,000 BTC
```

**Errors:**
- `Failed to fetch trending/search` → API unavailable
- `No results found` → empty search
