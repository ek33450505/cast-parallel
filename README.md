# cast-parallel

Split CAST plan execution across parallel worktree sessions.

## Install

```bash
brew tap ek33450505/cast-parallel
brew install cast-parallel
```

Or manually: copy `cast-parallel.sh` to your PATH.

## Usage

```bash
cast-parallel [--dry-run] [--split N] <plan-file>
```

### Flags

- `--dry-run` — Show batch split without executing
- `--split N` — Split after batch N (default: auto-midpoint)
- `--help`, `-h` — Show usage

## How It Works

1. Reads an Agent Dispatch Manifest from a CAST plan file
2. Splits batches into two streams (A and B)
3. Creates two git worktrees
4. Launches parallel `claude --headless` sessions
5. Merges results back to your branch

## Requirements

- Claude Code CLI (`claude`)
- `git`
- `python3`
- CAST framework (recommended)

## License

MIT

---

Part of the [CAST ecosystem](https://github.com/ek33450505/claude-agent-team).
