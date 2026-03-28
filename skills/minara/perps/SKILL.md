---
name: perps
description: "Hyperliquid perpetual futures — order, positions, wallets, autopilot, leverage, deposit, withdraw, analysis, trade history. Use when: perps, perpetual, futures, Hyperliquid, perps wallet, perps deposit."
---

# /perps — Hyperliquid perpetual futures

**Unified router for `minara perps` subcommands.** Routes to the correct subcommand based on user intent.

## Usage

`/perps [subcommand] [args...]`

| Subcommand | Maps to | Type |
|-----------|---------|------|
| `order` | `minara perps order` | fund-moving |
| `positions` / `pos` | `minara perps positions` | read-only |
| `close [SYMBOL\|all]` | `minara perps close` | fund-moving |
| `cancel` | `minara perps cancel` | fund-moving |
| `wallets` / `w` | `minara perps wallets` | read-only |
| `autopilot` / `ap` | `minara perps autopilot` | config |
| `ask [SYMBOL]` | `minara perps ask` | read-only |
| `leverage` | `minara perps leverage` | config |
| `deposit [AMOUNT]` | `minara perps deposit` | fund-moving |
| `withdraw [AMOUNT]` | `minara perps withdraw` | fund-moving |
| `trades` | `minara perps trades` | read-only |
| `fund-records` | `minara perps fund-records` | read-only |
| `create-wallet [NAME]` | `minara perps create-wallet` | config |
| `rename-wallet` | `minara perps rename-wallet` | config |
| `sweep` | `minara perps sweep` | fund-moving |
| `transfer [AMOUNT]` | `minara perps transfer` | fund-moving |
| (none) | Ask user what they want | — |

## When no subcommand is provided

Use **AskUserQuestion**:
- Context: "What would you like to do with Hyperliquid perps?"
- Options:
  - A) Place an order (long/short)
  - B) View positions
  - C) Close a position
  - D) Manage wallets
  - E) Deposit / withdraw USDC
  - F) View trade history
  - G) AI trading analysis
  - H) Manage autopilot

Then route to the matching subcommand below.

## Subcommand execution

### `/perps order` — fund-moving

Place a perps order (long or short).

1. Use **AskUserQuestion** to gather missing params if not provided:
   - Context: "Place a perps order"
   - Options: A) Long / B) Short
2. Run `minara perps order` with `pty: true` (interactive order builder)
3. Add `--wallet WALLET` if user specifies a wallet

Follows standard transaction confirmation — never add `-y`.

**Autopilot check:** If autopilot is ON for the target wallet, manual orders are blocked. Inform user and offer: A) Disable autopilot first / B) Use a different wallet / C) Cancel.

### `/perps positions` — read-only

Run `minara perps positions`. Add `--wallet WALLET` if specified.

### `/perps close` — fund-moving

Close open perps positions at market price.

| Usage | Maps to |
|-------|---------|
| `/perps close all` | `minara perps close --all` |
| `/perps close BTC` | `minara perps close --symbol BTC` |
| `/perps close` | `minara perps close` (interactive picker) |

1. Run `minara perps positions` to show current positions
2. Use **AskUserQuestion**:
   - Context: "Close {all / SYMBOL} perps position(s)"
   - Options: A) Confirm and close (Recommended) / B) Abort
3. Execute with `pty: true`. Add `--wallet WALLET` if specified.

### `/perps cancel` — fund-moving

Cancel open (unfilled) perps orders.

1. Use **AskUserQuestion**:
   - Context: "Cancel open perps orders"
   - Options: A) Confirm / B) Abort
2. Run `minara perps cancel` with `pty: true`

### `/perps wallets` — read-only

Run `minara perps wallets`. Lists all sub-wallets with balances, positions, and autopilot status.

### `/perps autopilot` — config

Run `minara perps autopilot` with `pty: true` (interactive dashboard). Add `--wallet WALLET` if specified. See also `/autopilot`.

### `/perps ask` — read-only

AI trading analysis for an asset (long/short recommendation).

Run `minara perps ask` with `pty: true`. Add `--wallet WALLET` if specified.

### `/perps leverage` — config

Update leverage for a symbol.

Run `minara perps leverage` with `pty: true`. Add `--wallet WALLET` if specified.

### `/perps deposit` — fund-moving

Deposit USDC into Hyperliquid perps (min 5 USDC).

1. Run `minara balance` to check available USDC
2. Use **AskUserQuestion**:
   - Context: "Deposit {AMOUNT} USDC to perps account"
   - Options: A) Confirm (Recommended) / B) Abort
3. If A → `minara perps deposit -a AMOUNT` (add `--wallet WALLET` if specified)
4. If B → abort

### `/perps withdraw` — fund-moving

Withdraw USDC from Hyperliquid perps.

1. Use **AskUserQuestion**:
   - Context: "Withdraw {AMOUNT} USDC from perps"
   - Options: A) Confirm (Recommended) / B) Abort
2. If A → `minara perps withdraw -a AMOUNT` (add `--wallet WALLET` and `--to ADDRESS` if specified)
3. If B → abort

### `/perps trades` — read-only

Run `minara perps trades`. Add `--count N`, `--days N`, `--wallet WALLET` if specified.

### `/perps fund-records` — read-only

Run `minara perps fund-records`. Add `--wallet WALLET`, `--page N`, `--limit N` if specified.

### `/perps create-wallet` — config

1. If name provided: `minara perps create-wallet -n NAME`
2. If no name: use **AskUserQuestion** to ask for wallet name, then execute

### `/perps rename-wallet` — config

Run `minara perps rename-wallet` with `pty: true` (interactive picker).

### `/perps sweep` — fund-moving

Consolidate funds from a sub-wallet to the default wallet.

1. Use **AskUserQuestion**:
   - Context: "Sweep funds from sub-wallet to default wallet"
   - Options: A) Confirm (Recommended) / B) Abort
2. If A → `minara perps sweep` with `pty: true`
3. If B → abort

### `/perps transfer` — fund-moving

Transfer USDC between perps sub-wallets.

1. Use **AskUserQuestion**:
   - Context: "Transfer {AMOUNT} USDC between perps wallets"
   - Options: A) Confirm (Recommended) / B) Abort
2. If A → `minara perps transfer -a AMOUNT` with `pty: true`
3. If B → abort
