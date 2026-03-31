# Perps Positions / Close / Cancel / Leverage / Trades

> Execute commands yourself. Use `pty: true` for interactive commands.
>
> **`perps leverage` is fund-moving** — changing leverage directly affects position risk and liquidation price. Present a confirmation summary (asset, current leverage → new leverage, margin mode, Hyperliquid) and STOP. Wait for user's explicit reply before executing.

## ⚠ CRITICAL — Non-interactive mode FIRST (anti-loop)

**ALWAYS prefer non-interactive flags** to avoid interactive picker prompts that can hang and cause retry loops.

| Command | Non-interactive flags | NEVER run bare |
|---------|----------------------|----------------|
| `perps close` | `--all` or `--symbol SYM` | `perps close` (no flags) |
| `perps cancel` | First run `perps positions` to identify the order, then use picker with pty | `perps cancel` blindly |
| `perps leverage` | N/A — always interactive, see section below | — |

**Anti-loop rules:**
1. If a command hangs (no new output for 15 seconds) on an interactive prompt, **STOP — do NOT retry**. Kill the process and report to the user.
2. **Max 1 retry** for any single command. If it fails twice, stop and report.
3. Before running any perps manage command, decide which flags to use. Never run a bare interactive command hoping it will work.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| View positions | `minara perps positions` | read-only |
| Close position(s) | `minara perps close --all` or `--symbol SYM` | fund-moving |
| Cancel open order(s) | `minara perps cancel` (pty) | fund-moving |
| Set leverage | `minara perps leverage` (pty) | config |
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

### Agent execution flow (MUST follow)

1. **Run `minara perps positions`** first to see open positions.
2. **Determine intent** from the user's request:
   - "close all" / "close everything" → use `--all`
   - "close BTC" / "close my ETH position" → use `--symbol SYM`
   - Ambiguous → ask the user which position to close. **Do NOT run bare `perps close`.**
3. Execute with the chosen flags.

| Usage | Effect |
|-------|--------|
| `perps close --all` | Close all positions at market |
| `perps close --symbol BTC` | Close all BTC positions |
| ~~`perps close`~~ | ⛔ **DO NOT USE** — enters interactive picker, causes hang in Claude Code |

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

### Agent execution flow (MUST follow)

This command **always** uses an interactive picker. To avoid hanging:

1. **First**, run `minara perps positions` to list open orders and identify which one to cancel.
2. Tell the user which open orders exist and ask which one to cancel (use structured choices).
3. Run `minara perps cancel` with `pty: true`.
4. When the picker appears, select the matching order.
5. **If the command hangs** (no output for 15s), kill it immediately. Do NOT retry. Report to the user.

```
? Select order to cancel: ETH BUY 0.5 @ $3,000 oid:12345
? Cancel? (y/N) y
✔ Order cancelled
```

**Errors:** `No open orders to cancel`, `Could not find your perps wallet address`

## `minara perps leverage`

Can be run interactively or with non-interactive flags.
Options: `-s, --symbol <TOKEN>` (target token), `-l, --leverage <VALUE>` (leverage multiplier), `-w, --wallet <name>`.

When both `-s` and `-l` are provided, it defaults to cross margin mode.

### Agent execution flow (MUST follow)

This command is **always interactive** (no non-interactive flags). Handle carefully:

1. **Before running**, ask the user for all three inputs: asset, leverage multiplier, margin mode (cross/isolated).
2. Run `minara perps leverage` with `pty: true`.
3. Respond to each prompt in sequence with the user's specified values.
4. **If the command hangs** (no output for 15s at any prompt), kill it immediately. Do NOT retry. Report to the user that the interactive command could not complete and suggest they run it manually.

```
$ minara perps leverage -s ETH -l 20
✔ Leverage set to 20x (cross) for ETH
```

If flags are missing, it falls back to an Interactive prompt: select asset → leverage (1–max) → margin mode (cross/isolated).

## `minara perps trades`

**Options:** `-n, --count <n>` (default 20), `-d, --days <n>` (default 7), `-w, --wallet`

```
Trade Fills (last 30d — 45 fills):
  Realized PnL: +$234.56 · Total Fees: $12.34 · Win Rate: 8/12 (66.7%)
```

Read-only.
