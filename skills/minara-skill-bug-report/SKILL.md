---
name: minara-skill-bug-report
version: 1.0.0
description: "Guided Minara bug report submission. Collects environment info automatically, walks the user through describing the bug, then files a GitHub issue to Minara-AI/skills. Trigger with /minara-skill-bug-report."
metadata:
  requires:
    bins: ["gh", "minara"]
---

# Minara Bug Report — Guided Issue Submission

You are helping the user file a bug report for the Minara skill to https://github.com/Minara-AI/skills/issues.

Follow the steps below **in order**. Do not skip steps. Do not submit until the user has confirmed the final preview.

---

## Step 1 — Check prerequisites

Run the following silently to verify `gh` is authenticated:

```bash
gh auth status 2>&1
```

- If not authenticated → tell the user: "You need to log in to GitHub CLI first. Run `gh auth login` and follow the prompts, then retry `/minara-skill-bug-report`." Stop here.
- If authenticated → continue silently.

---

## Step 2 — Collect environment info automatically

Run all of these commands and store the results:

```bash
uname -srm                        # Platform / OS
echo $SHELL                       # Shell
claude --version 2>/dev/null      # Claude Code version
node --version 2>/dev/null        # Node.js version
minara --version 2>/dev/null      # Minara CLI version
minara account 2>/dev/null        # Wallet type (parse "abstraction-evm" / "solana" etc from output)
```

If a command fails or returns nothing, record the value as `unknown`.

---

## Step 3 — Ask the user, one question at a time

Ask each question separately. Wait for the answer before asking the next one.

**Q1.** "What were you trying to do? (Describe your goal in one sentence, e.g. 'Swap 20 USDC for ETH on Base')"

**Q2.** "What did you tell me (the AI) to do? Paste your exact message."

**Q3.** "What minara commands did I run as a result? Paste them all, one per line."
> If the user doesn't know, run `history | grep minara | tail -20` and show them for reference.

**Q4.** "For each command above, paste the **full terminal output** — errors, warnings, and returned values. Don't summarize."

**Q5.** "What did you expect to happen?"

**Q6.** "What actually happened? Include specific wrong values if any (e.g. fee amounts, error codes)."

**Q7 (optional).** "Anything else to add? (Workarounds tried, related issues, wallet state.) Type 'skip' to leave this blank."

**Q8.** "How severe is this? (Critical / High / Medium / Low)"
> Guide: Critical = funds at risk or unrecoverable state. High = core feature broken. Medium = workaround exists. Low = minor/cosmetic.

---

## Step 4 — Build the issue body

Construct the GitHub issue body using the template below. Fill every field from what you collected in Steps 2–3.

```
## Description

{Q1 answer}

---

## Environment

| Field | Value |
|---|---|
| Platform / OS | {uname output} |
| Shell | {$SHELL} |
| Skill version | {minara --version} |
| Wallet type | {parsed from minara account} |
| Claude Code version | {claude --version} |
| Node.js version | {node --version} |
| Proxy / VPN active? | (ask only if not determinable — otherwise omit row) |
| Severity | {Q8 answer} |

---

## Steps to Reproduce

**User instruction:**

> {Q2 answer}

**Commands executed by AI agent:**

```bash
{Q3 answer}
```

---

## Error Log

{For each command in Q3, create a labeled block:}

**Command:** `{command}`

```
{corresponding output from Q4}
```

---

## Expected Behavior

{Q5 answer}

---

## Actual Behavior

{Q6 answer}

---

## Additional Notes

{Q7 answer — omit section entirely if user typed 'skip'}
```

---

## Step 5 — Show preview and confirm

Display the complete issue body to the user and ask:

"Here's the bug report I'll submit. Does this look correct? (yes / edit / cancel)"

- **yes** → proceed to Step 6.
- **edit** → ask "Which section needs fixing?" and let the user correct it, then re-show the preview.
- **cancel** → stop. Tell the user the report was not submitted.

---

## Step 6 — Submit to GitHub

Generate a short, descriptive title from the description (Q1). Format: `[Bug] {concise summary}`.

Then run:

```bash
gh issue create \
  --repo Minara-AI/skills \
  --title "[Bug] {generated title}" \
  --label "bug" \
  --body "{issue body from Step 4}"
```

After submission, show the user:
- The issue URL returned by `gh issue create`
- "Bug report filed. The Minara team will follow up on the issue."
