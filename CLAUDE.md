# cast-parallel

## Install
```bash
bash install.sh
# installs to ~/.local/bin/cast-parallel
```

## Run
```bash
cast-parallel [--dry-run] [--split N] <plan-file>
```

## Non-obvious

- Requires a plan file with a ` ```json dispatch ``` ` fenced block — plain markdown plans won't work.
- Uses git worktrees at `~/.claude/worktrees/parallel-a` and `parallel-b`; must be run inside a git repo.
- Launches `claude --headless --dangerously-skip-permissions` for each stream — requires `claude` on PATH and an active Anthropic auth session.
- Logs stream output to `$TMPDIR/cast-parallel-<plan-id>-stream-{a,b}.log`; tailed on failure.
- On merge conflict, worktrees are preserved (not cleaned) for manual resolution.
- DB logging calls `cast-db-log.py` sibling if present; silently skips if absent.
- **Prefer `cast-managed-agent.sh --fork` over this tool for new parallel work** — managed agents avoid the git worktree interference issues this tool was built before.
- `CAST_SUBPROCESS=1` suppresses recursive execution inside agent chains.
