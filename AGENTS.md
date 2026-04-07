# Repository Notes

- Do not edit files under `skills/` directly unless a task explicitly asks for generated output. They are rebuilt artifacts.
- Edit skill source files under `src/` instead. For example, the Talon skill source of truth is `src/talon/SKILL.md`.
- Talon reference docs in `skills/talon/references/` are copied from `subtrees/talon-wiki/docs/Customization/` by `build.sh`. If a task needs to change those references, update the subtree source file and then rebuild.
- Rebuild generated skills with `./build.sh` after source changes so `skills/` stays in sync.
- `./build.sh --update` refreshes the `talon-wiki` and `skills` subtrees before rebuilding generated output.
- Per this repo's local instructions, use `uv` or `uvx` instead of `python3` or `pip3` when Python tooling is needed.
