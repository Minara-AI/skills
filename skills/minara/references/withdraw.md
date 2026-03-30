# Withdraw

> Execute commands yourself. Fund-moving — require user confirmation.

## `minara withdraw`

Withdraw tokens from Minara to an external address.

**Options:**
- `-c, --chain <chain>` — blockchain network
- `-t, --token <address|ticker>` — token to withdraw
- `-a, --amount <amount>` — amount
- `--to <address>` — destination wallet address
- `-y, --yes` — skip confirmation (never use unless user explicitly requests)

Interactive if any flags are omitted — prompts for each missing field. Use `pty: true`.

```
$ minara withdraw -c solana -t SOL -a 5 --to 5xYz...external

Your current assets:
  SOL  10.5  (solana)  ·  USDC  200  (base)

🔒 Transaction confirmation required.
  Withdraw 5 SOL → 5xYz...external · solana
? Confirm? (y/N) y
[Touch ID]
✔ Withdrawal submitted! Transaction ID: tx_abc123...
ℹ May take a few minutes to confirm on-chain.
```

Shows current assets before prompting.

**Address validation:** EVM → `0x` + 40 hex chars. Solana → base58.

**Errors:**
- `Withdrawal failed` → insufficient balance, invalid address, network issue
