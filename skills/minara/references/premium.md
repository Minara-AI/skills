# Premium / Subscription

> Execute commands yourself. Relay checkout URLs to user for browser completion.

## Commands

| Intent | CLI | Type |
|--------|-----|------|
| View plans | `minara premium plans` | read-only |
| Subscription status | `minara premium status` | read-only |
| Subscribe / change plan | `minara premium subscribe` | opens browser |
| Cancel subscription | `minara premium cancel` | destructive |

**Default (no subcommand):** interactive submenu.

## `minara premium plans`

```
Subscription Plans:
  Plan      Monthly   Yearly                Credits   Workflows  Invites
  Free      —         Free                  300       0          0
  Lite      $19/mo    $192/yr (save 16%)    1,400     5          5
  Starter   $49/mo    $480/yr (save 18%)    4,000     20         10
  Pro       $199/mo   $1980/yr (save 17%)   20,000    50         15
  Partner   $599/mo   $5964/yr (save 17%)   60,000    200        20

Credit Packages (one-time):
  $19 → 800 · $49 → 2,200 · $89 → 4,400
```

> **Snapshot only.** Plans, prices, credits, and workflow limits are fetched
> live from the server and rendered dynamically — the table above is a snapshot
> (as of CLI v0.4.7). Always run `minara premium plans` for current values; do
> not quote these numbers as authoritative.

> **Workflows gate `research`.** The `minara research` endpoint (and other
> workflow-backed features) consumes a **workflow**, not just credits. The
> **Free tier has 0 workflows**, so free users cannot run `research` — it
> errors with "Quota is still exhausted on the Free tier … Lite+ unlocks
> workflows". **Lite+ unlocks workflows** (Lite = 5). `ask` / `chat` (fast
> mode) still work on Free, drawing only on the 300 credits.

## `minara premium status`

```
Subscription Status:
  Plan       : Pro · Status: Active · Billing: Monthly · $199/mo
  Credits    : 20,000 · Renews: 4/16/2026
```

## `minara premium subscribe`

Interactive: plan → payment method (Stripe / crypto USDC) → confirm → browser checkout.

```
? Select plan: Lite (Monthly) — $19/mo
? Payment method: Credit Card (Stripe)
✔ Opening browser for payment…
  https://checkout.stripe.com/pay/cs_live_...
```

Relay the checkout URL to user.

## `minara premium cancel`

**Options:** `-y, --yes`

Cancels at end of billing period (not immediate).

```
⚠ This will downgrade to Free at end of billing period.
? Are you sure? (y/N) y
✔ Subscription cancelled.
```

**Errors:** `No paid plans available`, `Failed to create checkout session`, `Failed to cancel subscription`
