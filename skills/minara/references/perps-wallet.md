# Perps Wallets / Deposit / Withdraw / Fund Records

> Execute commands yourself. Use `pty: true` for interactive prompts.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| List wallets | `minara perps wallets` | read-only |
| Create wallet | `minara perps create-wallet -n NAME` | config |
| Rename wallet | `minara perps rename-wallet` | config |
| Sweep → default | `minara perps sweep` | fund-moving |
| Transfer between wallets | `minara perps transfer` | fund-moving |
| Deposit USDC to perps | `minara perps deposit -a AMT` | fund-moving |
| Withdraw USDC from perps | `minara perps withdraw -a AMT` | fund-moving |
| Deposit/withdraw history | `minara perps fund-records` | read-only |

All accept `-w, --wallet <name>` where applicable.

## `minara perps wallets`

**Alias:** `minara perps w`

```
  Wallet     Equity      Available   Margin    PnL         Autopilot
  Default    $1,200.00   $800.00     $400.00   +$50.00     ON (BTC/ETH)
  Bot-1      $500.00     $500.00     $0.00     $0.00       OFF
```

## `minara perps create-wallet`

**Options:** `-n, --name <name>`. Prompts if omitted.

## `minara perps rename-wallet`

Interactive: pick wallet → enter new name (max 10 chars).

## `minara perps sweep`

Consolidate funds from sub-wallet to default. Blocked if autopilot ON on source wallet.

**Options:** `-y, --yes`

```
? From wallet: Bot-1 ($500.00 available)
🔒 Confirm sweep all funds from Bot-1 to default? (y/N) y
✔ Swept $500.00 USDC to default wallet
```

## `minara perps transfer`

Move USDC between any two sub-wallets. Requires ≥2 wallets.

**Options:** `-a, --amount`, `-y, --yes`

```
? From wallet: Default ($800.00) → To wallet: Bot-1
? Amount (USDC): 200
🔒 Confirm transfer $200 USDC? (y/N) y
✔ Transferred $200.00 USDC
```

## `minara perps deposit`

Deposit USDC into Hyperliquid perps. **Minimum 5 USDC.**

**Options:** `-a, --amount`, `-w, --wallet`, `-y, --yes`

Also accessible via `minara deposit perps`.

```
$ minara perps deposit -a 500
🔒 Deposit 500 USDC → Perps. Confirm? (y/N) y
[Touch ID]
✔ Deposited 500 USDC
```

## `minara perps withdraw`

Withdraw USDC from perps.

**Options:** `-a, --amount`, `--to <address>` (Arbitrum), `-w, --wallet`, `-y, --yes`

```
$ minara perps withdraw -a 200 --to 0xMyWallet...
⚠ Withdrawals may take time to process.
? Confirm withdrawal? (y/N) y
[Touch ID]
✔ Withdrawal submitted
```

## `minara perps fund-records`

**Options:** `-p, --page <n>` (default 1), `-l, --limit <n>` (default 20), `-w, --wallet`

Paginated deposit/withdrawal history. Read-only.
