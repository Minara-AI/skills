# minara-skill-bug-report skill

Guides you through filing a Minara bug report and automatically submits it as a GitHub issue.

## Usage

In Claude Code, type:

```
/minara-skill-bug-report
```

Claude will automatically collect your environment info, ask you about the bug step by step, show you a preview, and submit it to https://github.com/Minara-AI/skills/issues upon confirmation.

## Prerequisites

| Tool | Check | Install |
|---|---|---|
| `gh` CLI | `gh --version` | `brew install gh` |
| GitHub login | `gh auth status` | `gh auth login` |
| `minara` CLI | `minara --version` | `npm install -g minara` |

## Installation

Copy the `minara-skill-bug-report/` folder into `~/.claude/skills/`, then restart Claude Code.

```bash
unzip minara-skill-bug-report.zip -d ~/.claude/skills/
```

## Files

- `skill.md` — skill logic, do not edit
- `help.md` — this file
