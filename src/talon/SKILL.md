---
name: talon
description: Use when working on Talon voice command projects (.talon files, .talon-list files, or Talon Python modules). Provides Talon file syntax, voice command rules, context matching, list definitions, Python API tips, and local testing guidance.
---

# Talon Voice Command Development

## Reference Documentation

For detailed syntax documentation, see bundled references:
- `references/talon-files.md` — .talon file syntax, context headers, commands, actions, captures, settings, tags
- `references/talon-lists.md` — .talon-list file format, overrides, named vs simple lists
- `references/misc-tips.md` — REPL and logging usage, introspection functions (sim, mimic, actions.find/list, events.tail, registry inspection), and the Talon Python API (ui, clip, cron, screen, imgui, canvas, noise, fs modules)

## Testing with the REPL

Use the REPL for testing command parsing with `sim()` or introspecting Talon APIs. Do NOT use it for testing behavioral changes that depend on specific application context — the user will test those manually.

- **Mac:** `~/.talon/bin/repl`
- **WSL:** `talon_repl`

## Local Development

### Mac

- **Repo locations:** Talon repos live in `~/projects/` and are symlinked into `~/.talon/user/`
- **Auto-reload:** Changes to `.talon` and `.py` files are automatically reloaded within a few seconds
- **Logs:** `~/.talon/talon.log` (very long — don't read the whole thing). Changed files appear as `DEBUG [~] /path/to/file`, with possible `WARNING` or `ERROR` lines afterwards

#### Deploying Changes with `link_talon`

After making changes to a Talon repo, run `link_talon` to update the symlink in `~/.talon/user/` so Talon picks up the changes. Must be run from within the git repo.

**Usage:** `link_talon [--main] (--live | --snapshot)`

**Defaults:**
- **Main worktree** (running from it, or using `--main`): use `--live`
- **Alternate worktree**: use `--snapshot`

**Workflows:**

1. **Editing the main branch directly:**
   Run `link_talon --live` from the main worktree. The symlink points directly to the repo, so subsequent edits are picked up automatically.

2. **Testing a feature branch in a worktree:**
   Run `link_talon --snapshot` from the alternate worktree. A snapshot copy is made so further edits don't cause partial-state loading in Talon. Run it again after each batch of changes.

3. **Reverting to known-working state:**
   Run `link_talon --main --live` from any worktree of the repo. This points the symlink back at the main worktree, restoring stable behavior. Use this when a worktree's changes have broken something, then fix the issue and re-run `link_talon --snapshot` to test again.

**Notes:**
- The `cursorless-talon` and `cursorless-talon-dev` symlinks are managed separately and are not affected by `link_talon`
- Snapshots exclude `.git/` and `.venv/` to stay fast and small
- Only one snapshot per project is kept; old ones are cleaned up automatically

### WSL

- **Deploying changes:** Run `sync_talon_repo` to push the current repository to the Talon user directory in Windows
- **Auto-reload:** Talon takes a few seconds to load changed files after sync
- **Logs:** `/mnt/c/Users/james/AppData/Roaming/talon/talon.log` (very long — don't read the whole thing). Changed files appear as `DEBUG [~] c:\path\to\file`, with possible `WARNING` or `ERROR` lines afterwards
