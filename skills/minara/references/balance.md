# Balance / Assets

> Execute commands yourself. All read-only — no confirmation needed.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Quick balance | `minara balance` | read-only |
| Spot holdings with PnL | `minara assets spot` | read-only |
| Perps account overview | `minara assets perps` | read-only |
| Full portfolio (both) | `minara assets` | read-only |

## `minara balance`

Quick combined balance: Spot (USDC/USDT) + Perps (available).

```
Balance:
  Spot  (USDC/USDT) : $1,234.56
  Perps (available) : $500.00
  ──────────────────────────────
  Total             : $1,734.56
```

No options. Add `--json` to root command for machine-readable output.

## `minara assets spot`

Spot wallet holdings with PnL. Only shows holdings ≥ $0.01.

```
Spot Wallet:
  Portfolio Value: $5,432.10 · Unrealized PnL: +$123.45

Holdings (4):
  Symbol  Balance    Price      Value      Chain      PnL
  ETH     1.5000     $3,200     $4,800     ethereum   +$200
  USDC    500.00     $1.00      $500.00    base       $0.00
  SOL     5.0000     $25.00     $125.00    solana     -$10.00
```

## `minara assets perps`

Perps account: equity, available, margin, positions.

```
Perps Account:
  Equity: $2,000.00 · Available: $1,500.00 · Margin: $500.00
  Unrealized PnL: +$75.00 · Withdrawable: $1,200.00

Open Positions (1):
  BTC  LONG  0.01  @ $65,000  Mark $66,500  PnL +$15.00  10x
```

## `minara assets` (no subcommand)

Runs both spot + perps sequentially.

**Errors:**
- `Could not fetch spot assets` / `Could not fetch perps account` → auth or network issue
- Not logged in → `minara login`
