# Perps Positions / Close / Cancel / Leverage / Trades

> Execute commands yourself. Use `pty: true` for interactive commands.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| View positions | `minara perps positions` | read-only |
| Close position(s) | `minara perps close` | fund-moving |
| Cancel open order(s) | `minara perps cancel` | fund-moving |
| Set leverage | `minara perps leverage` | config |
| Trade fill history | `minara perps trades` | read-only |

All accept `-w, --wallet <name>` to target a specific sub-wallet.

## `minara perps positions`

**Alias:** `minara perps pos`

```
Wallet: Default
  Equity: $2,000.00 · Unrealized PnL: +$75.00 · Margin Used: $500.00

Open Positions (2):
  Symbol  Side   Size   Entry      Mark       PnL       Leverage
  BTC     LONG   0.01   $65,000    $66,500    +$15.00   10x
  ETH     SHORT  0.5    $3,300     $3,200     +$50.00   5x
```

## `minara perps close`

**Options:** `-a, --all` (close ALL), `-s, --symbol <symbol>` (close by symbol), `-y, --yes`, `-w, --wallet`

| Usage | Effect |
|-------|--------|
| `perps close` | Interactive: pick position from list |
| `perps close --all` | Close all positions at market |
| `perps close --symbol BTC` | Close all BTC positions |

Confirm + Touch ID before execution.

```
$ minara perps close --all
Close ALL Positions: 2 positions
🔒 Transaction confirmation required.
? Confirm? (y/N) y
[Touch ID]
✔ Closed 2 position(s)
```

**Errors:** `No open positions to close`, partial failure reports each position individually.

## `minara perps cancel`

Cancel an open perps order. Interactive picker if no specific order.

**Options:** `-y, --yes`, `-w, --wallet`

```
? Select order to cancel: ETH BUY 0.5 @ $3,000 oid:12345
? Cancel? (y/N) y
✔ Order cancelled
```

**Errors:** `No open orders to cancel`, `Could not find your perps wallet address`

## `minara perps leverage`

Interactive: select asset → leverage (1–max) → margin mode (cross/isolated).

```
? Asset: ETH $3,200 max 50x
? Leverage (1–50x): 20
? Margin mode: Cross
✔ Leverage set to 20x (cross) for ETH
```

## `minara perps trades`

**Options:** `-n, --count <n>` (default 20), `-d, --days <n>` (default 7), `-w, --wallet`

```
Trade Fills (last 30d — 45 fills):
  Realized PnL: +$234.56 · Total Fees: $12.34 · Win Rate: 8/12 (66.7%)
```

Read-only.
