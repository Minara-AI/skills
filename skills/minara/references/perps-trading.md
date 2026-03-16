# Perpetual Futures Reference

> **You are the executor.** Run all commands yourself via shell exec (`pty: true` for interactive prompts). Read CLI output, respond to prompts autonomously, and only ask the user for confirmation on fund-moving operations. Never tell the user to run commands themselves.

## Overview

Hyperliquid perpetual futures: order placement, position management, leverage, autopilot AI trading, and analysis. All perps commands live under `minara perps <subcommand>`.

---

## Commands

### `minara perps order`

Interactive order builder for Hyperliquid perps.

**Options:**
- `-y, --yes` — skip confirmation

**Flow:**
1. Check autopilot status — blocks if autopilot is ON
2. Select side: Long (buy) / Short (sell)
3. Select asset from live market data (shows mark price + max leverage + current leverage)
4. Select order type: Market / Limit
5. Enter size (in contracts)
6. Reduce only? (default: No)
7. Grouping: None / Normal TP/SL / Position TP/SL
8. Preview → Confirm → Touch ID → Execute

```
$ minara perps order

ℹ Building a Hyperliquid perps order…

? Side: Long (buy)
? Asset: ETH      $3,200  max 50x  10x cross
? Order type: Market
ℹ Market order at ~$3200
? Size (in contracts): 0.5
? Reduce only? No
? Grouping: None

Order Preview:
  Asset        : ETH
  Side         : 🟢 LONG
  Leverage     : 10x (cross)
  Type         : Market
  Price        : Market (~$3,200)
  Size         : 0.5
  Reduce Only  : No
  Grouping     : na

🔒 Transaction confirmation required.
  Perps LONG ETH · size 0.5 @ Market (~$3,200)
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Order submitted!
```

**Autopilot guard:** If autopilot is ON, manual orders are blocked:
```
⚠ Autopilot is currently ON. Manual order placement is disabled while AI is trading.
ℹ Turn off autopilot first: minara perps autopilot
```

**Errors:**
- `Order placement failed` → insufficient margin, invalid size, API error
- Autopilot active → disable autopilot first

---

### `minara perps ask`

AI-powered long/short analysis with optional quick order.

**Flow:**
1. Select asset from market list
2. Select analysis style: Scalping (5m) / Day Trading (1h) / Swing Trading (4h)
3. Enter margin in USD (default: 1000)
4. Enter leverage (default: 10)
5. AI returns analysis with recommendation
6. If recommendation found → offers quick order placement

```
$ minara perps ask

? Asset to analyze: BTC
? Analysis style: Day Trading (hours–day)
? Margin in USD: 1000
? Leverage: 10

AI Analysis — BTC (day-trading):
  recommendation: Long
  entryPrice: $65,200
  confidence: 72%
  reasoning: Bullish divergence on RSI...

Quick Order:
  🟢 LONG BTC  |  Entry ~$65,200  |  Size 0.1534  |  10x
? Place this order now? (y/N)
```

**Errors:**
- `Analysis failed` → AI service unavailable, retry later
- No recommendation extracted → analysis returned but no clear signal

---

### `minara perps positions`

View all open positions. Alias: `minara perps pos`

```
$ minara perps positions

  Equity        : $2,000.00
  Unrealized PnL: +$75.00
  Margin Used   : $500.00

Open Positions (2):
  Symbol  Side   Size   Entry      Mark       PnL       Leverage
  BTC     LONG   0.01   $65,000    $66,500    +$15.00   10x
  ETH     SHORT  0.5    $3,300     $3,200     +$50.00   5x
```

Read-only, no confirmation needed.

---

### `minara perps close`

Close positions at market price.

**Options:**
- `-y, --yes` — skip confirmation
- `-a, --all` — close ALL positions (non-interactive)
- `-s, --symbol <symbol>` — close by symbol (non-interactive, e.g. `BTC`, `ETH`)

#### Interactive (default)

Shows position list with "[CLOSE ALL POSITIONS]" option at top:

```
? Select position to close:
  [ CLOSE ALL POSITIONS ]
  BTC    🟢 LONG   0.01 @ $65,000  PnL: +$15.00
  ETH    🟥 SHORT  0.5  @ $3,300   PnL: +$50.00
```

#### Close all

```
$ minara perps close --all

Close ALL Positions:
  Positions to close: 2
    - BTC LONG 0.01
    - ETH SHORT 0.5

🔒 Transaction confirmation required.
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Closed 2 position(s):
  ✓ BTC LONG
  ✓ ETH SHORT
```

#### Close by symbol

```
$ minara perps close --symbol BTC
```

**Errors:**
- `No open positions to close` → nothing to do
- `Could not fetch current price` → cannot place market close order
- Partial failure → reports each position's success/failure individually

---

### `minara perps cancel`

Cancel an open perps order.

**Options:**
- `-y, --yes` — skip confirmation

```
$ minara perps cancel

? Select order to cancel:
  ETH    BUY   0.5 @ $3,000  oid:12345
? Cancel BUY ETH 0.5 @ $3,000? (y/N) y
✔ Order cancelled
```

**Errors:**
- `No open orders to cancel` → nothing to do
- `Could not find your perps wallet address` → perps account not initialized

---

### `minara perps leverage`

Update leverage and margin mode for a symbol.

```
$ minara perps leverage

? Asset: ETH      $3,200  max 50x
? Leverage (1–50x): 20
? Margin mode: Cross
✔ Leverage set to 20x (cross) for ETH
```

**Errors:**
- `Failed to update leverage` → invalid value or API error

---

### `minara perps trades`

View trade fill history.

**Options:**
- `-n, --count <n>` — number of recent fills (default: 20)
- `-d, --days <n>` — lookback period in days (default: 7)

```
$ minara perps trades -d 30

Trade Fills (last 30d — 45 fills):
  Realized PnL : +$234.56
  Total Fees   : $12.34
  Win Rate     : 8/12 (66.7%)

Showing 20 most recent:
  Time          Symbol  Side  Size  Price    PnL      Fee
  03/15 14:30   BTC     SELL  0.01  $66,500  +$15.00  $0.50
  ...
```

Read-only.

---

### `minara perps deposit`

Deposit USDC into Hyperliquid perps account. Minimum 5 USDC.

**Options:**
- `-a, --amount <amount>` — USDC amount
- `-y, --yes` — skip confirmation

```
$ minara perps deposit -a 500

  Deposit : 500 USDC → Perps

🔒 Transaction confirmation required.
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Deposited 500 USDC
```

Also accessible via `minara deposit perps`.

⚠️ **Fund-moving command.**

**Errors:**
- `Minimum deposit is 5 USDC` → amount too low

---

### `minara perps withdraw`

Withdraw USDC from perps.

**Options:**
- `-a, --amount <amount>` — USDC amount
- `--to <address>` — destination address (Arbitrum)
- `-y, --yes` — skip confirmation

```
$ minara perps withdraw -a 200 --to 0xMyWallet...

  Withdraw : 200 USDC → 0xMyWallet...
⚠ Withdrawals may take time to process.
? Confirm withdrawal? (y/N) y
[Touch ID]
✔ Withdrawal submitted
```

⚠️ **Fund-moving command.**

---

### `minara perps fund-records`

View deposit/withdrawal history.

**Options:**
- `-p, --page <n>` — page number (default: 1)
- `-l, --limit <n>` — per page (default: 20)

Read-only.

---

### `minara perps autopilot`

Manage AI autopilot trading strategy. Alias: `minara perps ap`

**Interactive menu:**

```
Autopilot Status: ON
  Symbols : BTC, ETH, SOL

? What would you like to do?
  Turn OFF autopilot
  Update symbols
  View performance
  Back
```

**Actions:**
| Action | What it does |
|---|---|
| Turn ON | Enable existing strategy |
| Turn OFF | Disable strategy (stops AI trading) |
| Create | New strategy with selected symbols |
| Update symbols | Change which assets AI trades |
| View performance | Show PnL metrics |

**Critical:** When autopilot is ON, `minara perps order` is blocked. Must turn off autopilot first.

**Errors:**
- `Failed to enable/disable autopilot` → API error

---

## Limit Orders (Spot)

Separate from perps — these are spot-level conditional orders.

### `minara limit-order create`

Create a limit order triggered by price condition.

**Options:**
- `-y, --yes` — skip confirmation

**Flow:** Chain → Side (buy/sell) → Token → Price condition (above/below) → Target price → Amount (USD) → Expiry (hours)

```
Limit Order:
  Chain     : base
  Side      : buy
  Token     : PEPE (0xAbc...)
  Condition : price below $0.000012
  Amount    : $100
  Expires   : 3/17/2026, 2:30 PM

🔒 Transaction confirmation required.
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Limit order created!
```

⚠️ **Fund-moving command.**

### `minara limit-order list`

List all limit orders. Alias: `minara limit-order ls`

### `minara limit-order cancel <id>`

Cancel a specific order by ID. Interactive selection if no ID given.

---

## Agent Command Construction

| User says | Command |
|---|---|
| "open a long ETH perp" | `minara perps order` (interactive) |
| "short BTC with 20x leverage" | First `minara perps leverage` for BTC, then `minara perps order` |
| "should I long or short SOL?" | `minara perps ask` |
| "check my perp positions" | `minara perps positions` |
| "close my BTC position" | `minara perps close --symbol BTC` |
| "close all positions" | `minara perps close --all` |
| "turn on autopilot" | `minara perps autopilot` |
| "deposit 500 to perps" | `minara perps deposit -a 500` |
| "withdraw 200 from perps" | `minara perps withdraw -a 200 --to <address>` |
| "show my trade history" | `minara perps trades` |
| "create limit order for PEPE at $0.000012" | `minara limit-order create` |

---

## Execution Rules

1. **Execute commands yourself** — never show CLI syntax and ask the user to run it
2. **Never auto-confirm** any fund-moving perps command — relay summary, wait for user approval
3. **Check autopilot** before manual order placement — if ON, inform user and suggest disabling
4. Perps withdraw requires a **valid Arbitrum address**
5. All interactive commands use `@inquirer/prompts` — use `pty: true` in exec
6. **Handle errors autonomously** — read error output, diagnose, retry or inform user
