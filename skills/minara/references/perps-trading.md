# Perpetual Futures Reference

> **Execute commands yourself.** Use `pty: true` for interactive prompts. Only ask the user for confirmation on fund-moving operations.

## Contents

- [Wallets](#minara-perps-wallets) — list/create/rename sub-wallets
- [Sweep & Transfer](#minara-perps-sweep--transfer) — move USDC between wallets
- [Order](#minara-perps-order) — place market/limit perps orders (multi-wallet)
- [Ask](#minara-perps-ask) — AI long/short analysis + quick order
- [Positions](#minara-perps-positions) — view open positions (per wallet)
- [Close](#minara-perps-close) — close positions (single/all/by symbol)
- [Cancel](#minara-perps-cancel) — cancel open orders
- [Leverage](#minara-perps-leverage) — set leverage and margin mode
- [Trades](#minara-perps-trades) — trade fill history
- [Deposit](#minara-perps-deposit) — deposit USDC to perps
- [Withdraw](#minara-perps-withdraw) — withdraw USDC from perps
- [Fund Records](#minara-perps-fund-records) — deposit/withdrawal history
- [Autopilot](#minara-perps-autopilot) — multi-strategy AI autopilot per wallet
- [Limit Orders](#limit-orders-spot) — spot-level conditional orders

---

## Multi-Wallet Support

**All trading commands** (`order`, `deposit`, `withdraw`, `close`, `cancel`, `leverage`, `trades`, `fund-records`, `ask`) accept a `--wallet <name>` flag to target a specific sub-wallet. If `--wallet` is omitted and multiple wallets exist, an interactive picker is shown displaying available balance per wallet.

```
$ minara perps order --wallet Bot-1
$ minara perps positions --wallet Bot-1
```

---

## Commands

### `minara perps wallets`

List all sub-wallets with equity, margin, PnL, and autopilot status. Alias: `minara perps w`

```
$ minara perps wallets

  Wallet     Equity      Available   Margin    PnL         Autopilot
  Default    $1,200.00   $800.00     $400.00   +$50.00     ON (BTC/ETH)
  Bot-1      $500.00     $500.00     $0.00     $0.00       OFF
  Bot-2      $300.00     $300.00     $0.00     $0.00       OFF
```

Read-only.

---

### `minara perps create-wallet`

Create a new perps sub-wallet.

**Options:**
- `-n, --name <name>` — wallet name

```
$ minara perps create-wallet -n Bot-2
✔ Sub-wallet "Bot-2" created
```

---

### `minara perps rename-wallet`

Rename an existing sub-wallet.

```
$ minara perps rename-wallet
? Select wallet: Bot-1
? New name: Strategy-Alpha
✔ Wallet renamed to "Strategy-Alpha"
```

---

### `minara perps sweep` & `minara perps transfer`

**Sweep:** Consolidate funds from a sub-wallet to the default wallet.

```
$ minara perps sweep
? From wallet: Bot-1  ($500.00 available)
🔒 Transaction confirmation required.
? Confirm sweep all funds from Bot-1 to default? (y/N) y
✔ Swept $500.00 USDC to default wallet
```

**Transfer:** Move USDC between any two wallets.

```
$ minara perps transfer
? From wallet: Default  ($800.00 available)
? To wallet: Bot-1
? Amount (USDC): 200
🔒 Transaction confirmation required.
? Confirm transfer $200 USDC from Default to Bot-1? (y/N) y
✔ Transferred $200.00 USDC
```

⚠️ **Fund-moving commands.**

---

### `minara perps order`

Interactive order builder for Hyperliquid perps.

**Options:**
- `-w, --wallet <name>` — target sub-wallet (interactive picker if omitted)
- `-y, --yes` — skip confirmation

**Flow:**
1. Resolve wallet (via `--wallet` flag or interactive picker)
2. Check autopilot status for that wallet — blocks if autopilot is ON for this wallet
3. Select side: Long (buy) / Short (sell)
4. Select asset from live market data (shows mark price + max leverage + current leverage)
5. Select order type: Market / Limit
6. Enter size (in contracts)
7. Reduce only? (default: No)
8. Grouping: None / Normal TP/SL / Position TP/SL
9. Preview → Confirm → Touch ID → Execute

```
$ minara perps order --wallet Bot-1

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

**Autopilot guard:** If autopilot is ON **for the selected wallet**, manual orders are blocked:
```
⚠ Autopilot is currently ON. Manual order placement is disabled while AI is trading.
ℹ Turn off autopilot first: minara perps autopilot
```

**Errors:**
- `Order placement failed` → insufficient margin, invalid size, API error
- Autopilot active for wallet → disable autopilot for that wallet first

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

View open positions. Alias: `minara perps pos`

**Options:**
- `-w, --wallet <name>` — filter to a specific wallet only

```
$ minara perps positions

  Wallet: Default
  Equity        : $2,000.00
  Unrealized PnL: +$75.00
  Margin Used   : $500.00

Open Positions (2):
  Symbol  Side   Size   Entry      Mark       PnL       Leverage
  BTC     LONG   0.01   $65,000    $66,500    +$15.00   10x
  ETH     SHORT  0.5    $3,300     $3,200     +$50.00   5x

$ minara perps positions --wallet Bot-1
  (shows positions for Bot-1 only)
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

Manage AI autopilot strategies per wallet. Alias: `minara perps ap`

**v0.4.0+:** Autopilot is now **per-wallet** and supports **multiple strategies**. The dashboard shows all strategies across wallets with a performance comparison table. The active strategy is highlighted.

**Interactive flow:**

1. Pick a wallet (or use `--wallet`)
2. View strategy dashboard with performance table
3. Choose action: enable/disable strategy, edit config, create new, view performance

```
$ minara perps autopilot

? Select wallet: Default  ($1,200.00)

Autopilot Dashboard — Default wallet

  Strategy       Status    Symbols         Pattern
  Alpha Trend    ● ACTIVE  BTC/ETH         P2
  Mean Rev       ○ OFF     SOL/ETH         P1
  Scalper        ○ OFF     BTC             P3

Performance (last 7d):
  Strategy       PnL         Win Rate  Trades
  Alpha Trend    +$234.00    67%       45
  Mean Rev       +$89.00     58%       22
  Scalper        -$12.00     44%       18

? What would you like to do?
  Enable Mean Rev
  Disable Alpha Trend
  Edit config
  Create new strategy
  Back
```

**Actions:**
| Action | What it does |
|---|---|
| Enable strategy | Activate a strategy for this wallet |
| Disable strategy | Stop AI trading for that strategy |
| Edit config | Modify strategy parameters (symbols, pattern, etc.) |
| Create new | New strategy with selected symbols and pattern |
| View performance | Full PnL/win-rate breakdown across strategies |

**Critical:** When autopilot is ON **for a wallet**, `minara perps order --wallet <name>` is blocked for that wallet only. Other wallets without autopilot can still trade manually. Turn off autopilot for the specific wallet first.

**Errors:**
- `Failed to enable/disable autopilot` → API error
- Strategy not found → create a new strategy first

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

List all limit orders. Aliases: `minara limit-order ls`, `minara lo list`

### `minara limit-order cancel <id>`

Cancel a specific order by ID. Interactive selection if no ID given. Alias: `minara lo cancel`

---

## Module-Specific Notes

1. **Execute commands yourself** — never show CLI syntax and ask the user to run it
2. **Never auto-confirm** any fund-moving perps command — relay summary, wait for user approval
3. **Check autopilot per wallet** before manual order placement — if ON for the target wallet, inform user and suggest disabling autopilot for that wallet
4. **Multi-wallet commands** (`sweep`, `transfer`) are fund-moving — always confirm before executing
5. Perps withdraw requires a **valid Arbitrum address**
6. All interactive commands use `@inquirer/prompts` — use `pty: true` in exec
7. **Handle errors autonomously** — read error output, diagnose, retry or inform user
8. When user mentions wallet name (e.g. "Bot-1"), pass it via `--wallet Bot-1` flag to avoid interactive picker
