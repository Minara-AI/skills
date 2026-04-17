
<div style="display: flex; flex-direction: column; align-items: center; gap: 12px; margin: 20px auto; width: fit-content;">
  <h1 align="center"; style="margin: 0; line-height: 1.2; border: none; text-align: center;">Minara Skills</h1>
  <img src="assets/minara_banner.png" alt="Xneuro" width=100% style="display: block;">
</div>

[![version](https://img.shields.io/github/v/release/Minara-AI/skills)](https://github.com/Minara-AI/skills/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Benchmark](https://img.shields.io/badge/benchmark-88%2F100-brightgreen)](https://github.com/Minara-AI/crypto-skill-benchmark)
[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-blueviolet)](https://claude.com/claude-code)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-compatible-blue)](https://docs.openclaw.ai/tools/skills)
[![Static Badge](https://img.shields.io/badge/Hermes_Agent-compatible-yellow)](https://hermes-agent.nousresearch.com/)


Turn your AI agent into a personal AI CFO. [Minara](https://minara.ai) skills give your agent the ability to analyze and trade crypto, US stocks, commodities, forex, and more. Execute on-chain transactions, manage wallets, and get real-time market intelligence across EVM, Solana, and Hyperliquid.

<table>
  <tr>
    <td align="center" width="140"><h3>Works<br>with</h3></td>
    <td align="center" width="140">
      <a href="https://openclaw.ai/"><img src="assets/openclaw-logo.png" alt="OpenClaw" height="56"></a><br>
      <a href="https://openclaw.ai/">OpenClaw</a>
    </td>
    <td align="center" width="140">
      <a href="https://www.anthropic.com/product/claude-code"><img src="assets/claudecode-color.png" alt="Claude Code" height="56"></a><br>
      <a href="https://www.anthropic.com/product/claude-code">Claude Code</a>
    </td>
    <td align="center" width="140">
      <a href="https://hermes-agent.nousresearch.com/"><img src="assets/hermes-logo.png" alt="Hermes Agent" height="56"></a><br>
      <a href="https://hermes-agent.nousresearch.com/">Hermes Agent</a>
    </td>
  </tr>
</table>

<p align="center"><em>If it can receive a heartbeat, it's hired.</em></p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Supported Networks](#supported-networks)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Basic flow](#basic-flow)
  - [Perps and limit orders](#perps-and-limit-orders)
  - [More examples](#more-examples)
- [Benchmark](#benchmark)
- [Scripts](#scripts)
- [Security](#security)
- [Links](#links)
- [License](#license)

## Features

- **Spot Trading** — Buy, sell, swap, convert, and transfer by ticker, token name, or contract address across supported chains.
- **Perpetual Futures** — Open/close positions, leverage, multi-wallet management, trade history, and AI autopilot on Hyperliquid.
- **Limit Orders** — Create, list, and cancel spot and perps limit orders.
- **Wallet & Funds** — Built-in wallet, balance, portfolio, deposit addresses, spot/perps funding, withdrawals, transfers, and credit card on-ramp via MoonPay.
- **AI Insights & Market** — Real-time on-chain data, token fundamentals, whale flows, trending tokens/stocks, equity research, commodities, and forex.
- **x402 Payment** — Pay x402-enabled HTTP APIs directly from the Minara wallet.
- **Premium** — Plans, credits, and subscription management.

## Supported Networks

Ethereum, Base, Arbitrum, Optimism, Polygon, Avalanche, Solana, BSC, Berachain, Blast, Manta, Mode, Sonic, Conflux, Merlin, Monad, Polymarket, XLayer, and Hyperliquid (perps).

## Installation

<details open>
<summary>Claude Code</summary>

**One-click (recommended):** Send this prompt to your Claude Code agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/claudecode-minara-skill-setup.sh | bash" to install Minara CLI, Minara Skills and set following config. Follow the login URL when prompted.
```

This installs the Minara CLI, copies skill files to `~/.claude/skills/minara` and starts the login flow.

**Manual:**

```bash
npm install -g minara@latest
git clone https://github.com/Minara-AI/skills.git /tmp/minara-skills
cp -r /tmp/minara-skills/skills/minara ~/.claude/skills/minara
```

</details>

<details>
<summary>OpenClaw</summary>
**One-click (recommended):** Send this prompt to your OpenClaw agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/openclaw-minara-skill-setup.sh | bash" to install Minara CLI, Minara Skills and set following config. Follow the login URL when prompted.
```

This installs the CLI, copies skill files to `~/.openclaw/skills/minara`, registers the skill in `openclaw.json`, starts login.

**ClawHub:**

```bash
clawhub install lowesyang/minara
```

**Manual:**

```bash
git clone --branch main https://github.com/Minara-AI/skills.git /tmp/minara-skills
cp -r /tmp/minara-skills/skills/minara ~/.openclaw/workspace/skills/minara

or

cp -r /tmp/minara-skills/skills/minara path/to/openclaw/workspace/skills
```

Add to `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "minara": {
        "enabled": true
      }
    }
  }
}
```

</details>

<details>
<summary>Hermes</summary>

**One-click (recommended):** Send this prompt to your Hermes agent:

```
Run "curl -fsSL https://raw.githubusercontent.com/Minara-AI/skills/main/scripts/hermes-minara-skill-setup.sh | bash" to install Minara CLI, Minara Skills and set following config. Follow the login URL when prompted.
```

This installs the Minara CLI, copies skill files to `~/.hermes/skills/minara` and starts the login flow.

**Manual:**

```bash
npm install -g minara@latest
git clone https://github.com/Minara-AI/skills.git /tmp/minara-skills
cp -r /tmp/minara-skills/skills/minara ~/.hermes/skills/minara
```

</details>

## Quick Start

```
> Login to Minara
> Show my Minara deposit address
> Buy 100 USDC worth of ETH
> What tokens are trending?
```

## Usage

Talk to the agent in natural language. It runs the right commands for you.

### Basic flow

| Step        | Example prompts                                                                               |
| ----------- | --------------------------------------------------------------------------------------------- |
| **Login**   | _"Login to Minara"_                                                                           |
| **Deposit** | _"Show my deposit address"_ / _"Buy crypto with credit card"_ / _"Deposit 500 USDC to perps"_ |
| **Trade**   | _"Buy 100 USDC worth of ETH"_ / _"Swap 0.1 ETH to USDC"_ / _"Sell all SOL"_                   |

### Perps and limit orders

| Goal              | Example prompts                                         |
| ----------------- | ------------------------------------------------------- |
| **Open position** | _"Long ETH perp"_ / _"Short BTC, 10x leverage"_         |
| **AI analysis**   | _"Analyze ETH long or short"_ / _"Should I long BTC?"_  |
| **Autopilot**     | _"Enable AI autopilot for perps"_                       |
| **Limit order**   | _"Buy ETH when price hits $3000"_ / _"Buy SOL at $150"_ |
| **Manage orders** | _"List my limit orders"_ / _"Cancel limit order [id]"_  |

### More examples

- _"Show my crypto portfolio"_ / _"What's my balance?"_
- _"What tokens are trending?"_ / _"Search for SOL tokens"_
- _"Pay 100 USDC to [address]"_ / _"Withdraw 10 SOL to [address]"_

See [examples.md](skills/minara/references/examples.md) for full CLI examples.

## Benchmark

**88/100** on [crypto-skill-bench](https://github.com/Minara-AI/crypto-skill-benchmark) (v3.0.2, Claude Sonnet 4.6, 76 scenarios)

| Dimension | Score |
|-----------|-------|
| Safety | 91 |
| Coverage | 86 |
| Robustness | 88 |
| Routing | 88 |
| UX | 86 |

66 passed, 10 partial, 0 failed. Safety gate: PASS.

## Scripts

| Script                                       | Purpose                                                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `scripts/claudecode-minara-skill-setup.sh`   | One-click installer for Claude Code: installs CLI, copies skill, runs login                            |
| `scripts/openclaw-minara-skill-setup.sh`     | One-click installer for OpenClaw: installs CLI, copies skill, registers in `openclaw.json`, runs login |
| `scripts/hermes-minara-skill-setup.sh`       | One-click installer for Hermes: installs CLI, copies skill, runs login                                |
| `skills/minara/scripts/version-check.sh`     | Session-level version detector — outputs `UP_TO_DATE`, `SNOOZED`, or `UPGRADE cli:X→Y [skill:X→Y]`     |

All setup scripts are idempotent and support the same three-tier skill download fallback: ClawHub → GitHub → clawhub CLI.

## Security

This repo contains documentation files and setup scripts. No binaries or long-running services. The setup scripts install the [Minara CLI](https://www.npmjs.com/package/minara) from npm and copy skill files into the skills directory. Credentials are handled by the CLI's official login flow; this repo does not collect or store secrets.

## Links

- [Minara](https://minara.ai)
- [Minara CLI (npm)](https://www.npmjs.com/package/minara)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [ClawHub](https://clawhub.ai)

## License

MIT
