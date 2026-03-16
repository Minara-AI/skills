# Minara Examples

## 1 — Login & account

For device login handoff: if CLI outputs a verification URL and/or device code, pass them to the user verbatim, ask user to finish browser verification, then continue only after user confirms completion.

```bash
minara login                       # Interactive (device code default, or email)
minara login --device              # Device code flow: relay URL/code to user for browser verification
minara login -e user@example.com   # Email with verification code
minara account                     # View account info + wallet addresses
minara deposit spot                # Show spot deposit addresses (EVM + Solana)
```

## 2 — Swap tokens

Chain is auto-detected from the token.

```bash
# Interactive: side → token → amount
minara swap

# By ticker (chain auto-detected)
minara swap -s buy -t '$BONK' -a 100
minara swap -s buy -t '$ETH' -a 50
minara swap -s sell -t '$SOL' -a 200

# Sell entire balance
minara swap -s sell -t '$NVDAx' -a all

# By contract address
minara swap -s buy -t DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263 -a 100

# Dry run (simulate without executing)
minara swap -s buy -t '$ETH' -a 50 --dry-run
```

## 3 — Transfer & withdraw

```bash
# Transfer (interactive)
minara transfer

# Withdraw to external wallet
minara withdraw -c solana -t '$SOL' -a 10 --to <address>
minara withdraw   # Interactive (accepts ticker or address)
```

## 4 — Wallet & portfolio

```bash
minara balance                 # Quick total: Spot + Perps USDC/USDT balance
minara assets                  # Full overview: spot holdings + perps account
minara assets spot             # Spot wallet: portfolio value, cost, PnL, holdings
minara assets perps            # Perps: equity, margin, positions
minara assets spot --json      # JSON output

# Deposit
minara deposit                 # Interactive: Spot / Perps / Buy with credit card
minara deposit spot            # Show spot deposit addresses (EVM + Solana)
minara deposit perps           # Perps: show Arbitrum address, or transfer Spot → Perps
minara deposit buy             # Buy crypto with credit card via MoonPay (opens browser)
```

## 5 — Perpetual futures

```bash
# ── Multi-wallet management (v0.4.0+) ──────────────────────────────────
minara perps wallets                    # List all sub-wallets with balances + autopilot info
minara perps create-wallet -n Bot-1     # Create a new sub-wallet
minara perps rename-wallet              # Rename a wallet interactively
minara perps sweep                      # Move funds from sub-wallet → default wallet
minara perps transfer                   # Transfer USDC between any two wallets

# ── Fund perps account ─────────────────────────────────────────────────
minara perps deposit -a 100             # Default wallet
minara perps deposit -a 100 --wallet Bot-1  # Specific wallet

# ── Set leverage ───────────────────────────────────────────────────────
minara perps leverage
minara perps leverage --wallet Bot-1

# ── Place order (interactive: wallet, symbol, side, size, price) ───────
minara perps order                      # Wallet picker if multiple exist
minara perps order --wallet Bot-1       # Target specific wallet

# ── View positions ─────────────────────────────────────────────────────
minara perps positions                  # All wallets
minara perps positions --wallet Bot-1   # Specific wallet only

# ── Close positions ────────────────────────────────────────────────────
minara perps close                      # Interactive: select position to close
minara perps close --all                # Close all positions (non-interactive)
minara perps close --symbol BTC         # Close BTC position (non-interactive)
minara perps close --all --yes          # Close all, skip confirmation

# ── Cancel orders ──────────────────────────────────────────────────────
minara perps cancel
minara perps cancel --wallet Bot-1

# ── Withdraw from perps ────────────────────────────────────────────────
minara perps withdraw -a 50

# ── AI analysis → optional quick order ────────────────────────────────
minara perps ask
minara perps ask --wallet Bot-1

# ── AI autopilot (multi-strategy dashboard, per wallet) ───────────────
minara perps autopilot                  # Pick wallet → view strategy dashboard
minara perps autopilot --wallet Bot-1   # Jump to Bot-1's strategies directly

# ── History ────────────────────────────────────────────────────────────
minara perps trades
minara perps fund-records
```

## 6 — AI chat

```bash
# Single question
minara chat "What is the current BTC price?"

# Quality mode
minara chat --quality "Analyze ETH outlook for next week"

# Reasoning mode
minara chat --thinking "Compare SOL vs AVAX ecosystem growth"

# Interactive REPL
minara chat
# >>> What's the best DeFi yield right now?
# >>> /help
# >>> exit

# Continue existing conversation
minara chat -c <chatId>

# List / replay past conversations
minara chat --list
minara chat --history <chatId>
```

## 7 — Market discovery

```bash
minara discover trending           # Trending tokens
minara discover trending stocks    # Trending stocks
minara discover search SOL         # Search tokens / stocks
minara discover search AAPL        # Search stocks by name
minara discover fear-greed         # Crypto Fear & Greed Index
minara discover btc-metrics        # Bitcoin on-chain metrics
minara discover trending --json    # JSON output
```

## 8 — Limit orders

```bash
minara limit-order create          # Interactive: token, price, side, amount, expiry
minara limit-order list            # List all orders
minara limit-order cancel abc123   # Cancel by ID
```

## 9 — x402 protocol payment

When an HTTP API returns **402 Payment Required** with x402 headers, the agent
can pay using the Minara wallet.

```bash
# 1. Check balance before paying
minara balance

# 2. Pay the x402 service (USDC transfer to the service's payment address)
#    Example: service requires 0.01 USDC on Base
minara transfer
#    → Token: USDC
#    → Amount: 0.01
#    → Recipient: <service payment address from 402 header>
#    → Chain: base

# 3. Ensure wallet is funded for future x402 payments
minara deposit buy                 # Credit card on-ramp via MoonPay
minara deposit spot                # Or show deposit addresses to receive crypto
```

## 10 — Premium & subscription

```bash
minara premium plans               # View plans
minara premium status              # Current subscription
minara premium subscribe           # Subscribe / upgrade
minara premium buy-credits         # Buy credits
minara premium cancel              # Cancel
```
