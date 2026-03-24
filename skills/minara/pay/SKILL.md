---
name: pay
description: "Pay with USDC — Minara send USDC to an address, default stablecoin payment, x402 API payment. Use when: pay, pay USDC, send USDC, pay someone, USDC payment, x402, paid API, 402 payment required."
---

# /pay — Pay with USDC

**Shortcut for `minara transfer -t USDC`** — defaults to USDC so the user only needs to provide a recipient address and amount.

## Usage

`/pay [AMOUNT] [ADDRESS] [CHAIN]`

| Arg | Description |
|-----|-------------|
| `AMOUNT` | USDC amount to send |
| `ADDRESS` | Recipient wallet address |
| `CHAIN` | Target chain (optional — auto-detected from address if omitted) |

## Execution

### When all parameters are provided

```bash
minara transfer -t USDC -a <AMOUNT> --to <ADDRESS>
```

Add `-c <CHAIN>` if user specifies a chain.

**Fund-moving** — requires confirmation:
1. Run `minara balance` to check available USDC
2. AskUserQuestion:
   - Context: "Pay {AMOUNT} USDC to {ADDRESS}{on CHAIN}"
   - Options:
     - A) Confirm and send (Recommended)
     - B) Dry-run (simulate only)
     - C) Abort
3. If A → execute `minara transfer -t USDC -a <AMOUNT> --to <ADDRESS>`
4. If B → execute with `--dry-run`
5. If C → abort

Never add `-y`. Always require explicit confirmation.

### When parameters are missing

Use **AskUserQuestion** to gather missing values:
- If no amount: "How much USDC would you like to send?"
- If no address: "What is the recipient address?"

### Using a different stablecoin

If the user explicitly requests a different token (e.g. USDT, DAI), use that token instead:
```bash
minara transfer -t <TOKEN> -a <AMOUNT> --to <ADDRESS>
```

## x402 API payment

When the agent receives an HTTP **402 Payment Required** response with x402 headers, use this command to pay:

1. Parse the `PAYMENT-REQUIRED` header (amount, token, recipient, chain)
2. Execute `/pay <amount> <recipient>` with the parsed values
3. After payment confirmation, retry the original request

See [x402 spec](https://docs.cdp.coinbase.com/x402/quickstart-for-buyers).

## Note

This is a convenience wrapper around `minara transfer` that defaults to USDC. Also used for x402 protocol payments. For sending any arbitrary token, use `/send`.
