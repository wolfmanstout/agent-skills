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

- **Talon user directory:** `~/.talon/user/`
- **Auto-reload:** Changes to `.talon` and `.py` files are automatically reloaded within a few seconds
- **Logs:** `~/.talon/talon.log` (very long — don't read the whole thing). Changed files appear as `DEBUG [~] /path/to/file`, with possible `WARNING` or `ERROR` lines afterwards

### WSL

- **Deploying changes:** Run `sync_talon_repo` to push the current repository to the Talon user directory in Windows
- **Auto-reload:** Talon takes a few seconds to load changed files after sync
- **Logs:** `/mnt/c/Users/james/AppData/Roaming/talon/talon.log` (very long — don't read the whole thing). Changed files appear as `DEBUG [~] c:\path\to\file`, with possible `WARNING` or `ERROR` lines afterwards
