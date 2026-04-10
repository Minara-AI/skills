# Transfer / Send / Pay

> Execute commands yourself. All fund-moving — require user confirmation.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| Send tokens to address | `minara transfer -c CHAIN -t TOKEN -a AMT --to ADDR` | fund-moving |
| Pay with USDC | `minara transfer -t USDC -a AMT --to ADDR` | fund-moving |
| x402 payment | parse 402 headers → transfer | fund-moving |

**Alias:** `minara send` = `minara transfer`

## `minara transfer`

**Options:**
- `-c, --chain <chain>` — blockchain network
- `-t, --token <address|ticker>` — token to send
- `-a, --amount <amount>` — amount to send
- `--to <address>` — recipient address
- `-y, --yes` — skip confirmation (never use unless user explicitly requests)

Interactive if any flags are omitted — prompts for each missing field. Use `pty: true`.

```
$ minara transfer -c base -t USDC -a 100 --to 0xRecipient...
🔒 Transaction confirmation required.
  Transfer 100 → 0xRecipient... · base
  Token: USDC (0x833...abc)
? Confirm this transaction? (y/N) y
[Touch ID]
✔ Transfer submitted! Transaction ID: tx_abc...
```

**Address validation (MUST check before executing):**
- **EVM:** `0x` + 40 hex chars (42 total). Reject truncated addresses (e.g. `0x123`).
- **Solana:** base58 encoded, typically 32-44 chars.
- **TRON:** starts with `T` — this is NOT an EVM address. If user provides a `T`-prefixed address for an EVM chain, warn and abort.
- **Invalid strings:** reject non-hex, non-base58 strings (e.g. `not_a_valid_eth_address`).
If the address format does not match the target chain, warn the user and do NOT proceed.

**Errors:**
- `Transfer failed` → insufficient balance, invalid address, network error

## Pay with USDC

Default stablecoin payment: `minara transfer -t USDC -a AMT --to ADDR`. If user wants a different stablecoin, substitute token.

## x402 Protocol

When an HTTP request returns **402 Payment Required** with x402 headers:
1. Parse headers: `amount`, `token`, `recipient`, `chain`
2. `minara balance` to verify funds
3. Ask user to confirm, then `minara transfer -c <chain> -t <token> -a <amount> --to <recipient>`
4. Retry the original request after payment confirms
