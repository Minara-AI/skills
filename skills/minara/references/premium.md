# Premium / Subscription

> Execute commands yourself. Relay checkout URLs to user for browser completion.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| View plans | `minara premium plans` | read-only |
| Subscription status | `minara premium status` | read-only |
| Subscribe / change plan | `minara premium subscribe` | opens browser |
| Buy credit package | `minara premium buy-credits` | opens browser |
| Cancel subscription | `minara premium cancel` | destructive |

**Default (no subcommand):** interactive submenu.

## `minara premium plans`

```
Subscription Plans:
  Plan   Monthly   Yearly              Credits   Workflows  Invites
  Free   Free      —                   1,000     1          0
  Pro    $19/mo    $190/yr (save 17%)  50,000    10         3
  Ultra  $49/mo    $490/yr (save 17%)  200,000   50         10

Credit Packages (one-time):
  $5 → 5,000 · $20 → 25,000 · $50 → 75,000
```

## `minara premium status`

```
Subscription Status:
  Plan: Pro · Status: Active · Billing: Monthly · $19/mo
  Credits: 50,000 · Renews: 4/16/2026
```

## `minara premium subscribe`

Interactive: plan → payment method (Stripe / crypto USDC) → confirm → browser checkout.

```
? Select plan: Pro (Monthly) — $19/mo
? Payment method: Credit Card (Stripe)
✔ Opening browser for payment…
  https://checkout.stripe.com/pay/cs_live_...
```

Relay the checkout URL to user.

## `minara premium buy-credits`

Interactive: package → payment method → browser checkout.

## `minara premium cancel`

**Options:** `-y, --yes`

Cancels at end of billing period (not immediate).

```
⚠ This will downgrade to Free at end of billing period.
? Are you sure? (y/N) y
✔ Subscription cancelled.
```

**Errors:** `No paid plans available`, `Failed to create checkout session`, `Failed to cancel subscription`
