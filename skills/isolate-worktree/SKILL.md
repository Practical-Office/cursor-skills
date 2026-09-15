---
name: isolate-worktree
description: >-
  use this when starting a ticket while another agent or human may also be
  building in the same repo — create a fresh git worktree off the default
  base so checkouts do not collide
disable-model-invocation: true
---

# Isolate worktree

One ticket = one worktree. Parallel agents never share a working tree.

## When to run

- Two or more implementers (agents or humans) on the same repo at once
- AFK multi-ticket loops
- Any time you would otherwise `git checkout` another feature branch in a dirty shared clone

## When to skip

- Solo human, one ticket, clean checkout already on a feature branch for that ticket
- Read-only research / docs chats that do not write code

## Steps

1. Confirm repo root and default base (`main` or `master` from `origin`).

```bash
git remote show origin | grep 'HEAD branch'
git fetch origin
```

2. Pick a worktree path **outside** the main clone (sibling folder), named after the ticket:

```bash
# Example
REPO_ROOT=$(pwd)
ISSUE=312
BRANCH="feat/${ISSUE}-short-slug"
WT_PATH="${REPO_ROOT}/../$(basename "$REPO_ROOT")-wt-${ISSUE}"

git worktree add -b "$BRANCH" "$WT_PATH" "origin/$(git remote show origin | sed -n 's/.*HEAD branch: //p')"
```

3. `cd` into the worktree. All `/implement`, commits, and `/create-pr` for this ticket happen here.

4. Tell the operator the absolute worktree path and branch name. Stop. Do not start implementation in this skill unless they asked.

## Cleanup (after merge)

```bash
git worktree remove "$WT_PATH"
git branch -d "$BRANCH"   # if local leftover
```

Do not force-remove a dirty worktree. Commit, stash, or ask.

## Hard stops

- Never create a worktree from a dirty feature branch as the base — always `origin/<default>`.
- Never run two tickets in one worktree.
- Never delete another agent's worktree.
- Never force-push to `main` / `master`.

## Related

- AI-Development-SOP Phase 6 Isolate
- `/implement`, `/create-pr`, `/pr-review`
