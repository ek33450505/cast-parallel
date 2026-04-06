# Contributing to cast-parallel

Thank you for your interest in contributing to cast-parallel — parallel plan execution for CAST.

## Prerequisites

- Bash 4.0+
- Git 2.5+ (worktree support)
- [Claude Code CLI](https://claude.ai/claude-code) installed and configured
- Python 3 (for JSON parsing)

## Quick Start

```bash
git clone https://github.com/ek33450505/cast-parallel.git
cd cast-parallel
bash install.sh
```

## Project Structure

```
cast-parallel.sh   # Main script — worktree creation, session launch, merge
install.sh         # Installer
```

## PR Checklist

Before opening a pull request:

- [ ] `shellcheck cast-parallel.sh` passes with no errors
- [ ] Tested with `--dry-run` on a sample plan file
- [ ] No hardcoded paths — use `$HOME` or `~/` for user-relative paths
- [ ] Trap handlers preserved for clean signal handling
- [ ] `CHANGELOG.md` updated for any user-visible change
