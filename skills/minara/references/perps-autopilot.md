# Perps Autopilot / AI Analysis

> Execute commands yourself. Use `pty: true` — fully interactive dashboards.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Autopilot dashboard | `minara perps autopilot` | config |
| AI long/short analysis | `minara perps ask` | read-only (+ optional order) |

Both accept `-w, --wallet <name>`.

## `minara perps autopilot`

**Alias:** `minara perps ap`

Per-wallet, multi-strategy AI trading. Interactive dashboard.

**Flow:** Pick wallet → view strategy dashboard → choose action

```
$ minara perps autopilot --wallet Default

Autopilot Dashboard — Default wallet

  Strategy       Status    Symbols         Pattern
  Alpha Trend    ● ACTIVE  BTC/ETH         P2
  Mean Rev       ○ OFF     SOL/ETH         P1

Performance (last 7d):
  Strategy       PnL         Win Rate  Trades
  Alpha Trend    +$234.00    67%       45
  Mean Rev       +$89.00     58%       22

? What would you like to do?
  Enable Mean Rev / Disable Alpha Trend / Edit config / Create new / Back
```

**Actions:** Enable/Disable strategy, Edit config (symbols, pattern, params), Create new strategy, View performance.

**Critical rule:** When autopilot is ON for a wallet, `minara perps order --wallet <name>` is **blocked** for that wallet. Other wallets without autopilot can still trade manually. Agent must check and inform user.

## `minara perps ask`

AI-powered long/short analysis with optional quick order. **Different from top-level `minara ask`** (which is general AI chat).

Blocked if autopilot ON for the selected wallet.

**Flow:** Select asset → analysis style → margin → leverage → AI analysis → optional quick order

```
$ minara perps ask --wallet Bot-1

? Asset to analyze: BTC
? Analysis style: Day Trading (hours–day)
? Margin in USD: 1000
? Leverage: 10

AI Analysis — BTC (day-trading):
  recommendation: Long · entryPrice: $65,200 · confidence: 72%
  reasoning: Bullish divergence on RSI...

Quick Order:
  🟢 LONG BTC | Entry ~$65,200 | Size 0.1534 | 10x
? Place this order now? (y/N)
```

**Errors:** `Analysis failed` → AI service unavailable.
