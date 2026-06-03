# Cursor Skills

Shared agent workflows for AI-driven development — composable skills invoked by name (`/trim-pr`, `/review`, etc.).

## Language

**Trim pass**:
A proactive, mutating pre-merge step that shrinks a branch diff while preserving ticket behavior and DoD artifacts. Required SOP gate on every ticket — may result in zero cuts.
_Avoid_: Review, cleanup, refactor pass

**Review**:
A read-only two-axis analysis (Standards + Spec) of a diff since a fixed point. Reports findings; does not edit the branch.
_Avoid_: Trim, audit, code review (when meaning this skill specifically)

**Fat**:
Diff bloat — scope creep, over-abstraction, noise comments, redundant tests, drive-by edits not required by the ticket.
_Avoid_: Tech debt, cruft, bloat (when describing a PR diff specifically)

**DoD artifact**:
A deliverable the ticket definition-of-done requires even if it adds lines — e.g. MSW handler, testid map, handoff doc, scoped test. Resolved from ticket text and project team guides at trim time; always green tier.
_Avoid_: Boilerplate, scaffolding

**Pre-PR pipeline**:
Ordered composable skills before opening a PR: trim → security-secrets-check → review → create-pr. Each skill has one job; not merged.
_Avoid_: Pre-merge checklist, PR prep (when meaning this specific sequence)

**Trim tier**:
Gate for auto-edit during a trim pass. Red = cut now. Yellow = ask once, default keep. Green = never cut without explicit instruction.
_Avoid_: Priority, severity level

**Trim output**:
Unstaged file edits after a trim pass. Not staged or committed unless the user explicitly requests.
_Avoid_: Trim commit, cleanup commit

**Merge base**:
The branch used as `<base>` in `git diff <base>...HEAD` when pinning what to trim. Resolved from user prompt, repo docs, or remote default — never assumed silently.
_Avoid_: Base branch, target branch

**Scoped verification**:
Tests run after a trim pass to confirm behavior survived cuts. Scope comes from ticket test plan first, then diff-derived co-located tests.
_Avoid_: Full test run, smoke test (when meaning this step specifically)

**Minimal add**:
A small line addition during trim — only for broken acceptance paths, green-tier bug fixes, or cut fallout (imports/types). Reported separately from fat removed.
_Avoid_: Feature add, enhancement

**Trim regression**:
A test failure caused by a red-tier cut. Fix forward once; if still failing, revert the cut and yellow-tier the hunk.
_Avoid_: Test failure, broken test
