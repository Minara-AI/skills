# Premium & Subscription Reference

> **Execute commands yourself.** Relay checkout URLs to the user for browser completion.

## Contents

- [Plans](#minara-premium-plans) — view available plans
- [Status](#minara-premium-status) — current subscription
- [Subscribe](#minara-premium-subscribe) — subscribe or upgrade
- [Buy Credits](#minara-premium-buy-credits) — one-time credit package
- [Cancel](#minara-premium-cancel) — cancel subscription

---

## Commands

### `minara premium plans`

View all available subscription plans and credit packages.

```
$ minara premium plans

Subscription Plans:

  Plan      Monthly    Yearly           Credits    Workflows  Invites
  Free      Free       —                1,000      1          0
  Pro       $19/mo     $190/yr (save 17%)  50,000    10         3
  Ultra     $49/mo     $490/yr (save 17%)  200,000   50         10

Credit Packages (one-time):

  Price     Credits
  $5        5,000
  $20       25,000
  $50       75,000

  Subscribe: minara premium subscribe
```

Read-only.

---

### `minara premium status`

View current subscription and billing info.

```
$ minara premium status

Subscription Status:

  Plan             : Pro
  Status           : Active
  Billing          : Monthly
  Price            : $19/mo
  Credits          : 50,000
  Renews On        : 4/16/2026
```

If on free plan:

```
  Plan             : Free
  Status           : Active

  Upgrade with: minara premium subscribe
```

Read-only.

---

### `minara premium subscribe`

Subscribe to a plan or change plan. Interactive flow.

**Flow:**
1. Select plan (shows name, interval, price, credits, workflows)
2. Select payment method: Credit Card (Stripe) / Crypto (USDC)
3. Confirm order summary
4. Opens browser for checkout

```
$ minara premium subscribe

? Select a plan: Pro (Monthly) — $19/mo  [50,000 credits, 10 workflows]
? Payment method: Credit Card (Stripe)

Order Summary:
  Plan    : Pro (Monthly)
  Price   : $19/mo
  Payment : Credit Card (Stripe)

? Proceed to checkout? (Y/n) y
✔ Checkout session created!
  Opening browser for payment…
  https://checkout.stripe.com/pay/cs_live_...
ℹ Complete the payment in your browser. Your subscription will activate automatically.
```

For crypto payment:

```
? Payment method: Crypto (USDC on-chain)
✔ Crypto checkout created!
  Opening browser for crypto payment…
  https://minara.ai/payment/crypto/...
```

**Errors:**
- `No paid plans available` → API returned no active plans
- `Failed to create checkout session` → Stripe/API error

---

### `minara premium buy-credits`

Buy a one-time credit package.

```
$ minara premium buy-credits

? Select a credit package: $20 — 25,000 credits
? Payment method: Credit Card (Stripe)

Package Summary:
  Price      : $20
  Credits    : 25,000
  Payment    : Credit Card (Stripe)

? Proceed to checkout? (Y/n) y
✔ Opening browser for payment…
```

Same Stripe / Crypto payment options as subscribe.

---

### `minara premium cancel`

Cancel current subscription. Downgrades to Free at end of billing period.

**Options:**
- `-y, --yes` — skip confirmation

```
$ minara premium cancel

⚠ Cancelling your subscription will downgrade you to the Free plan at the end of your billing period.
? Are you sure you want to cancel your subscription? (y/N) y
✔ Subscription cancelled.
ℹ You will continue to have access until the end of your current billing period.
```

**Errors:**
- `Failed to cancel subscription` → no active subscription or API error

---

## Module-Specific Notes

- **Execute commands yourself** — never tell the user to run `minara premium` commands
- Checkout flows open browser — run the command, capture the URL, and relay it to the user
- Crypto payment requires on-chain confirmation before activation
- Cancellation is effective at end of billing period, not immediate
- Credit purchases are one-time, non-refundable
- **Handle errors autonomously** — if checkout fails, diagnose and retry or inform user
