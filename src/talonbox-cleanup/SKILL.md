---
name: talonbox-cleanup
description: Use when the user asks to stop, clean up, prune, or delete stale or old talonbox VMs (Talon sandbox instances). Stops running sandboxes and deletes stale ones after confirmation, and never touches golden source VMs (`golden*`) or macOS base VMs (e.g. `tahoe-base`).
---

# Talonbox Cleanup

`talonbox` manages named macOS VMs used as disposable Talon sandboxes. Over time, task-specific clones accumulate and consume disk space. This skill stops and deletes stale clones while preserving the source VMs that new clones are made from.

Run `talonbox --help` and `talonbox <command> --help` for command details. The relevant commands are `list`, `status`, `stop`, and `delete`.

## Protected VMs

Never stop, rename, or delete these, even if they look stale or the user asks for "everything":

- **Golden VMs:** any name that is `golden` or starts with `golden` (e.g. `golden`, `golden-public`).
- **macOS base VMs:** `<macos-version>-base`, where the prefix is a macOS release name (e.g. `tahoe-base`; later macOS releases follow the same pattern). These hold the base OS install that golden VMs are built from.

Other names that merely end in `-base` (e.g. `cmp-hud-dot-base`, a comparison baseline from a test) are ordinary task clones and may be cleaned up like any other.

Match names exactly as `talonbox list` prints them. If you can't tell whether a `*-base` prefix is a macOS release name, or `golden` appears elsewhere in a name, treat it as protected and ask the user. If the user explicitly names a protected VM for deletion, refuse and tell them to delete it by hand.

## Workflow

### 1. Inventory

Run `talonbox list`. It prints each VM's name, status (`running`, `suspended`, `stopped`), and last-accessed time.

### 2. Pick candidates

Drop every protected VM first. From the rest, a VM is stale when it is not in use by work still in progress. Use these signals:

- **Age:** use the user's threshold if given; otherwise default to VMs last accessed more than 7 days ago.
- **Active work:** keep VMs tied to the current conversation, an uncommitted change, or an open branch. The Talon skill keeps test VMs until the user approves and commits the change, so a recent VM may still be needed.
- **Running VMs:** a VM that is `running` may be in active use by another session. Treat any running VM accessed within the last hour as in use unless the user says otherwise.

### 3. Confirm

Deleting a VM is permanent. Before deleting anything, show the user the candidate list grouped as:

- to stop and delete
- to keep (with the reason: protected, recent, or in use)

Wait for explicit approval. Apply exactly the approved set; if the user edits the list, use their version. Stopping alone (without deletion) is reversible, so if the user only asked to stop stale VMs, no confirmation is needed beyond excluding protected and in-use VMs.

### 4. Stop, then delete

`delete` requires the VM not to be running. For each approved VM that is `running`, run `talonbox stop <name>` first. Then delete the approved VMs, batching names in one call where possible:

```sh
talonbox stop test-old-experiment
talonbox delete test-old-experiment debug-old-timeout
```

Re-check each name against the protected rules immediately before passing it to `stop` or `delete`. Never build the name list with a glob or by piping `talonbox list` straight into `delete`.

### 5. Report

Run `talonbox list` again and report what was stopped, what was deleted, and what was kept. If any command failed, say which VM and quote the error instead of retrying with different flags.
