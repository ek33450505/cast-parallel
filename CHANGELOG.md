# CHANGELOG

## [v0.1.1] — 2026-06-05

### Fixed
- **Code backport:** `_db_log()` now pipes a JSON payload via stdin to `cast-db-log.py` (which reads stdin, not CLI flags). The prior `--event`/`--message` invocation silently dropped all `parallel_start`, `parallel_fail`, `parallel_streams_done`, `parallel_merge_conflict`, and `parallel_complete` events. Ported exact fix from flagship `claude-agent-team` `cast-parallel.sh`.

### Docs
- Removed false "Constellation 3D graph" claim from ecosystem block (`cast-desktop` entry).

## v0.1.0 — Initial Release (2026-04-06)

### Added
- `cast-parallel.sh` — split CAST plan execution across two parallel worktree sessions
- Auto-midpoint splitting of Agent Dispatch Manifest batches
- `--split N` flag for manual split point control
- `--dry-run` flag to preview batch distribution without executing
- Git worktree isolation — each stream works on a unique branch
- Trap handler for clean shutdown on INT/TERM signals
- Subprocess guard (`CAST_SUBPROCESS=1`) to prevent recursive execution
- Automatic merge of both streams back to the original branch
- Merge conflict detection with worktree preservation for manual resolution
- Event logging to cast.db when `cast-db-log.py` is available
- `install.sh` — automated installation
