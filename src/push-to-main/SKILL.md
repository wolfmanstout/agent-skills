---
name: push-to-main
description: Use when the user asks to push changes to main or master from an alternate git worktree. Commit the current worktree first, push its current branch only if it already has an upstream, then fast-forward only in the repository's main worktree and push main/master. Do not create pull requests.
---

# Push to Main

## Overview

This workflow publishes work from an alternate git worktree to `main` or `master` without bypassing branch history. The current worktree is made durable first; the main worktree is updated only by `--ff-only` operations.

## Workflow

### 1. Inspect the repository

Run these from the current worktree:

```sh
pwd
git status --short --branch
git branch --show-current
git worktree list --porcelain
```

Identify:

- The original worktree path, so command execution can return there at the end.
- The current branch, if any.
- The current branch's upstream, if one is configured.
- The current HEAD commit, especially if the worktree is detached.
- The primary branch: prefer `main`; otherwise use `master`.
- The main worktree: the worktree whose branch is `refs/heads/main` or `refs/heads/master`.

Detached current worktrees are nominal. Leave them detached and use their HEAD commit as the merge target. If no main/master worktree exists, stop and ask before creating or selecting one.

### 2. Commit and push the current worktree first

If the current worktree has changes, review the diff, stage only changes that belong to the user's request, and commit them. Do not stage unrelated user work just because it is present.

After the current worktree is committed or already clean, record the merge target: use the current branch name when one exists; otherwise use the current HEAD commit SHA.

If the current branch exists, check whether it already has an upstream:

```sh
git rev-parse --abbrev-ref --symbolic-full-name @{u}
```

If the branch has an upstream, push it before touching the main worktree:

```sh
git push
```

If there are no local changes but the branch has unpushed commits and an upstream exists, push the branch. If the current worktree is detached or the current branch has no upstream, skip this branch-push step. Do not create an upstream just to push the current branch. If pushing the current branch is rejected because the remote branch has commits this worktree does not have, stop and report the issue; do not force-push unless the user explicitly asks.

### 3. Fast-forward the main worktree

Switch command execution to the main worktree. Before merging, require it to be clean:

```sh
git status --short --branch
```

If it is dirty, stop and report the files. Do not stash, reset, or overwrite main-worktree changes.

Merge the current worktree's branch or HEAD commit with fast-forwarding only:

```sh
git merge --ff-only <current-branch-or-head-sha>
```

If `git merge --ff-only` fails, stop. Report that main/master cannot be fast-forwarded to the current worktree's branch or HEAD commit and leave conflict resolution, rebase, or merge-commit decisions to the user.

### 4. Push main/master

After the fast-forward succeeds:

```sh
git push origin main  # or: master
```

Do not fetch, pull, or rebase preemptively. If this final push is rejected because the remote primary branch moved, then pull/rebase and retry the push. Stop if the rebase conflicts, the main worktree becomes dirty, or the repository's local instructions require user approval.

Do not open a pull request unless the user specifically asks for one.

### 5. Return to the original worktree

After pushing main/master, set command execution back to the original worktree path captured at the start. The final current directory should be the worktree where the user made the request, even if the current worktree is detached.

## Guardrails

- Preserve unrelated work in both worktrees.
- Prefer non-interactive git commands.
- Never use `git reset --hard`, force-push, rebase, stash, or delete branches as part of this workflow unless the user explicitly requests that operation.
- If local repository instructions require a particular test or build before pushing, run it after committing the current worktree and before fast-forwarding main/master.
- If sandboxing blocks required network operations such as pushing or fetching, request escalation for the specific git command instead of substituting a different workflow.
