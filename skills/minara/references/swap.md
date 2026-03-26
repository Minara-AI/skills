# Swap (Buy / Sell)

> Execute commands yourself. Never show CLI and ask the user to run it.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Buy TOKEN with USDC | `minara swap -s buy -t TOKEN -a AMT` | fund-moving |
| Sell TOKEN to USDC | `minara swap -s sell -t TOKEN -a AMT` | fund-moving |
| Sell entire balance | `minara swap -s sell -t TOKEN -a all` | fund-moving |
| Swap IN → OUT | see parsing rules below | fund-moving |
| Simulate first | add `--dry-run` | read-only |

## `minara swap`

**Options:**
- `-s, --side <buy|sell>` — buy = spend USDC, sell = sell token for USDC
- `-t, --token <address|ticker>` — token contract address, ticker symbol, or `$TICKER`
- `-a, --amount <amount>` — USD amount (buy) or token amount (sell); `all` to sell entire balance
- `-y, --yes` — skip confirmation (⚠️ never use unless user explicitly requests)
- `--dry-run` — simulate without executing

### Token resolution

`-t` accepts: ticker (`ETH`, `SOL`), dollar-prefixed (`'$BONK'` — quote the `$`!), contract address (`0xAbC...`), or name (`ethereum`). CLI resolves to chain + address via `lookupToken()`.

### Chain auto-detection

Chain is derived from token lookup. If token exists on multiple chains, CLI shows a picker sorted by gas cost. No manual chain flag needed.

### Buy example

```
$ minara swap -s buy -t '$BONK' -a 50
🔒 Transaction confirmation required.
  BUY swap · 50 USD · solana
  Token: BONK (DezX...abc) · Chain: solana
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Swap submitted! Transaction ID: tx_xyz...
```

### Sell example

```
$ minara swap -s sell -t ETH -a 0.5
ℹ Available balance: 1.5 ETH
🔒 Transaction confirmation required.
  SELL swap · 0.5 tokens · ethereum
? Confirm this transaction? (y/N) y
✔ Swap submitted!
```

### Sell all

```
$ minara swap -s sell -t '$BONK' -a all
ℹ Selling all: 1000000 BONK
```

If amount exceeds balance, CLI auto-caps to max.

### Dry-run

```
$ minara swap -s buy -t SOL -a 100 --dry-run
ℹ Simulating swap (dry-run)…
  estimatedOutput: 4.0123 · priceImpact: 0.02% · route: Jupiter · gasFee: $0.001
```

No confirmation needed.

### Swap parsing (any-to-any)

When user says "swap AMT IN to OUT":
- If IN is a stablecoin (USDC/USDT) and OUT is not → **buy**: `swap -s buy -t 'OUT' -a AMT`
- Otherwise → **sell**: `swap -s sell -t 'IN' -a AMT`

**Errors:**
- `Unable to determine chain for token` → token not found or ambiguous
- `Swap failed` → insufficient balance, slippage, or API error
- `Could not determine balance` → balance lookup failed when selling all
