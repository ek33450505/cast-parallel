# cast-parallel

[![CI](https://github.com/ek33450505/cast-parallel/actions/workflows/ci.yml/badge.svg)](https://github.com/ek33450505/cast-parallel/actions/workflows/ci.yml)
![version](https://img.shields.io/badge/version-0.1.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)

Split CAST plan execution across parallel worktree sessions — two Claude Code agents working side-by-side on the same repo, each in its own isolated git worktree, results merged automatically when both finish.

## Install

```bash
brew tap ek33450505/cast-parallel
brew install cast-parallel
```

Or manually:

```bash
curl -fsSL https://raw.githubusercontent.com/ek33450505/cast-parallel/main/install.sh | bash
```

## Usage

```bash
cast-parallel [--dry-run] [--split N] <plan-file>
```

### Flags

| Flag | Description |
|------|-------------|
| `--dry-run` | Show how batches would be split without executing anything |
| `--split N` | Split after batch N (default: auto-midpoint) |
| `--help`, `-h` | Show usage |

### Examples

```bash
# Preview the split without running anything
cast-parallel --dry-run ~/.claude/plans/my-feature.md

# Execute with auto-midpoint split
cast-parallel ~/.claude/plans/my-feature.md

# Force split after batch 2 (batches 1-2 in Stream A, rest in Stream B)
cast-parallel --split 2 ~/.claude/plans/my-feature.md
```

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Both sessions completed and merged successfully |
| `1` | Runtime error, session failure, or merge conflict |
| `2` | Usage or argument error (missing plan file, invalid flags) |

## How It Works

cast-parallel reads an **Agent Dispatch Manifest** (ADM) — a JSON block embedded in a CAST plan file — and splits its batches across two concurrent Claude Code sessions.

### When to use cast-parallel

For most parallel agent work, **prefer `cast-managed-agent.sh --fork`** from the [CAST framework](https://github.com/ek33450505/claude-agent-team) — it runs agents on Anthropic infrastructure with no local filesystem contention, no worktree cleanup, and no merge step.

cast-parallel is purpose-built for one specific case the managed approach doesn't cover: **local, plan-file-driven 2-stream worktree splits with automatic merge**. If you have an Agent Dispatch Manifest plan and want to bisect its batches across two local Claude Code sessions with deterministic worktree handoff and merge, this is the right tool. Otherwise, reach for `--fork`.

### Execution Flow

```
Plan File (.md)
  │
  ├── Parse ────── Extract `json dispatch` block, count batches
  │
  ├── Split ────── Divide batches at midpoint (or --split N)
  │                  Stream A: batches 1..N
  │                  Stream B: batches N+1..total
  │
  ├── Worktrees ── Create two git worktrees at ~/.claude/worktrees/
  │                  parallel-a (branch: cast-parallel-a-<pid>)
  │                  parallel-b (branch: cast-parallel-b-<pid>)
  │
  ├── Launch ───── Start two `claude --headless` background processes
  │                  Each gets its own worktree, its own batch list
  │                  No terminal windows — runs silently in background
  │
  ├── Wait ─────── Monitor both PIDs, capture exit codes
  │                  If either fails: print log tails, exit 1
  │
  ├── Merge ────── git merge Stream B into Stream A
  │                  git merge Stream A into your original branch
  │                  Conflicts = exit 1, worktrees preserved for manual fix
  │
  └── Cleanup ──── Remove worktrees, prune stale refs, delete temp branches
```

### Plan File Format

cast-parallel expects a markdown file containing a fenced code block tagged `json dispatch`:

````markdown
```json dispatch
{
  "plan_id": "my-feature",
  "batches": [
    {
      "id": 1,
      "description": "Build the thing",
      "parallel": true,
      "agents": [
        { "subagent_type": "code-writer", "prompt": "..." },
        { "subagent_type": "test-writer", "prompt": "..." }
      ]
    },
    {
      "id": 2,
      "description": "Review and commit",
      "parallel": false,
      "agents": [
        { "subagent_type": "commit", "prompt": "..." }
      ]
    }
  ]
}
```
````

This is the standard [CAST Agent Dispatch Manifest](https://github.com/ek33450505/claude-agent-team) format.

### Safety

- **Subprocess guard** — if `CAST_SUBPROCESS=1` is set, the script exits immediately to prevent recursive execution inside agent chains
- **Trap handler** — `INT`/`TERM` signals kill both background sessions and clean up worktrees
- **No auto-resolve** — merge conflicts are never auto-resolved; worktrees are preserved so you can inspect and fix manually
- **Branch isolation** — each stream works on a unique branch (`cast-parallel-a-<pid>`) that is deleted after merge

### Logging

When a CAST database logger (`cast-db-log.py`) is available, events are logged to `cast.db` at each stage: `parallel_start`, `parallel_streams_done`, `parallel_complete`, `parallel_fail`, and `parallel_merge_conflict`.

## Requirements

- **Claude Code CLI** (`claude`) — the headless sessions use `claude --headless --dangerously-skip-permissions`
- **git** — worktree support (git 2.5+)
- **python3** — JSON parsing for the ADM block
- **CAST framework** (recommended) — provides the plan format and database logging

## CAST Ecosystem

Each CAST component ships as a standalone Homebrew package. Mix and match to build your own stack.

| Package | What It Does | Install |
|---------|-------------|---------|
| [cast-agents](https://github.com/ek33450505/cast-agents) | 17 specialist Claude Code agents | `brew tap ek33450505/cast-agents && brew install cast-agents` |
| [cast-hooks](https://github.com/ek33450505/cast-hooks) | 13 hook scripts — observability, safety gates, dispatch | `brew tap ek33450505/cast-hooks && brew install cast-hooks` |
| [cast-observe](https://github.com/ek33450505/cast-observe) | Session cost + token spend tracking | `brew tap ek33450505/cast-observe && brew install cast-observe` |
| [cast-security](https://github.com/ek33450505/cast-security) | Policy gates, PII redaction, audit trail | `brew tap ek33450505/cast-security && brew install cast-security` |
| [cast-dash](https://github.com/ek33450505/cast-dash) | Terminal UI dashboard (Python + Textual) | `brew tap ek33450505/cast-dash && brew install cast-dash` |
| [cast-memory](https://github.com/ek33450505/cast-memory) | Persistent memory for Claude Code agents | `brew tap ek33450505/cast-memory && brew install cast-memory` |
| **cast-parallel** | Parallel plan execution across dual worktrees | `brew tap ek33450505/cast-parallel && brew install cast-parallel` |

## License

MIT

---

Part of the [CAST ecosystem](https://github.com/ek33450505/claude-agent-team).
