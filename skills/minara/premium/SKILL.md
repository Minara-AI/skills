---
name: premium
description: "Manage Minara subscription — view plans, subscribe, buy credits, check status, cancel. Use when: Minara plan, subscription, pricing, credits, upgrade, downgrade."
---

# /premium — Manage Minara subscription

**Shortcut for `minara premium`**

## Usage

`/premium [plans|status|subscribe|buy-credits|cancel]`

| Arg | Maps to |
|-----|---------|
| `plans` | `minara premium plans` |
| `status` | `minara premium status` |
| `subscribe` | `minara premium subscribe` |
| `buy-credits` | `minara premium buy-credits` |
| `cancel` | `minara premium cancel` |
| (none) | Ask user what they want |

## Execution

### When no argument is provided

Use **AskUserQuestion**:
- Context: "What would you like to do with your Minara subscription?"
- Options:
  - A) View available plans
  - B) Check my subscription status
  - C) Subscribe or change plan
  - D) Buy a credit package
  - E) Cancel subscription

### `/premium plans` — read-only

Run `minara premium plans`. Display plan options.

### `/premium status` — read-only

Run `minara premium status`. Display current subscription info.

### `/premium subscribe` — payment action

1. Run `minara premium plans` to show options first
2. Run `minara premium subscribe` with `pty: true` (interactive plan picker)

### `/premium buy-credits` — payment action

Run `minara premium buy-credits` with `pty: true`.

### `/premium cancel` — destructive

1. Use **AskUserQuestion**:
   - Context: "This will cancel your Minara subscription. You will lose access to premium features at the end of the billing period."
   - Options:
     - A) Confirm cancellation
     - B) Keep my subscription
2. If A → `minara premium cancel`
3. If B → abort
