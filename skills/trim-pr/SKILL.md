---
name: trim-pr
description: >-
  Condense a branch diff before merge — remove scope creep, over-abstraction,
  noise comments, redundant tests, and drive-by edits while keeping behavior
  and ticket requirements intact. Use when the user asks to trim PR fat,
  condense code, slim a diff, minimize scope, lean up a branch, or run a
  pre-merge cleanup pass after implementation.
---

# Trim PR

Post-build, pre-merge pass. **Shrink the diff**, not the feature.

Goal: smallest correct change that satisfies the ticket and passes scoped tests.

**Mode:** Auto-edit the branch — not report-only. Apply cuts directly, rerun scoped tests, fix regressions. **Do not commit** unless the user explicitly asks. **Do not stage** unless the user explicitly asks — leave trim edits unstaged for review via `git diff`.

**Net-shrink:** Primary job is delete fat. Minimal line adds are OK when a cut breaks the acceptance path, a green-tier bug fix is required, or inlining needs a small import/type fix. Never add features or refactors. Report adds under **Added (minimal)**.

## When to run

**SOP gate:** Run on every ticket before PR — even if diff looks lean. Zero red-tier cuts is OK; still pin diff, trace hunks to ticket, run scoped tests, report.

Also run when:
- About to open or update a PR
- Diff feels bloated vs ticket scope
- User says: trim, condense, slim, lean, remove fat, minimize scope

**Not a substitute for** `review` (standards/spec) or `security-secrets-check`. Run those after trim.

## Process

### 1. Pin the diff

Resolve `<base>` in this order:

1. User prompt (e.g. `Branch vs staging`)
2. Repo docs — `CONTRIBUTING.md`, `AGENTS.md`, team guides
3. Remote default branch
4. Ask once if still ambiguous: "Trim vs `<candidate>` or `<candidate>`?"

Never assume a base silently.

```bash
git diff <base>...HEAD          # three-dot vs merge-base
git log <base>..HEAD --oneline
```

Read the ticket, handoff, or PR description. Everything in the diff must trace to a requirement — or be deleted.

**Project DoD:** If the repo has a team guide, ticket template, or phase doc with definition-of-done, read it now. DoD-required artifacts (MSW handlers, testid maps, handoff docs, scoped test paths, etc.) are **green tier** — never cut to shrink line count.

### 2. Tiered gates (apply before cutting)

Use [CHECKLIST.md](CHECKLIST.md) red / yellow / green flags:

| Tier | Action |
|------|--------|
| **Red** | Cut immediately — no ask |
| **Yellow** | Ask once; **default keep** if no answer within the turn |
| **Green** | Never cut without explicit user instruction |

Batch yellow-flag questions into one message when possible.

### 3. Cut list (apply in order)

| Category | Cut | Keep |
|----------|-----|------|
| **Scope creep** | Files/hunks unrelated to ticket | Cross-team edits only with handoff |
| **Abstraction tax** | 1–2 line helpers, wrapper components, extra types for one call site | Shared logic used 3+ times or mandated by repo |
| **Defensive noise** | try/catch, fallbacks, null guards for impossible paths | Errors users or APIs can actually hit |
| **Comment fat** | Comments restating obvious code | Non-obvious business rules, invariants |
| **Duplicate logic** | Reimplemented util when repo already has one | Extend existing function instead |
| **Drive-by refactors** | Renames, formatting, "while I'm here" in untouched files | Isolated cleanup only if ticket asks |
| **Test bloat** | Tests asserting implementation detail or "renders without crashing" | Tests covering ticket acceptance + regressions |
| **Doc bloat** | Extra markdown user didn't ask for | Handoff, testid map, OpenAPI stub when ticket DoD requires |

**Do not cut** to look smaller:

- Required testids, MSW fixtures, scoped tests for CI
- Behavior needed for acceptance criteria
- Error handling on real failure paths
- Imports/types that fix actual `tsc` errors

### 4. Match the neighborhood

Before deleting "verbose" code, read surrounding files. Trimmed code should match naming, import style, hook patterns, and test helpers already in that folder.

### 5. Verify

Resolve test scope in this order:

1. **Ticket / PR test plan / handoff** — run exactly what it names
2. **Diff-derived** — co-located `__tests__` for changed files and direct imports
3. **Scoped failure** — widen once to the related suite folder, not the whole monorepo
4. **Full suite** — only when ticket DoD requires it
5. **Nothing found** — ask once before marking verification done

```bash
# frontend example
npm run test -- --run src/path/to/__tests__/

# backend example
pytest tests/unit/test_changed_module.py -v
```

Fix trim regressions. Re-diff. Repeat until diff is lean and tests green.

**When scoped tests fail after a cut:**

1. Try **one** minimal fix forward (Q9 rules — acceptance path, green-tier bug, cut fallout)
2. Still failing → **revert that cut**, mark hunk yellow-tier, note in report
3. Max **2 passes** per file — then stop and report blockers
4. Failure unrelated to trim (pre-existing on branch) → report only; do not edit

If no red-tier cuts apply, report **Already lean** under Removed — do not invent cuts.

### 6. Report

```markdown
## Trim PR summary

**Base:** `<base>...HEAD`
**Ticket:** <id or PR #>

### Removed (~N lines)
- <file>: <what and why>
- _Or:_ **Already lean** — no red-tier cuts; diff traced to ticket

### Added (minimal)
- <file>: <what and why — acceptance path, green-tier bug fix, or cut fallout>

### Kept deliberately
- <item>: <why ticket/DoD needs it>

### Verification
- [ ] Scoped tests: `<command>` — pass
- [ ] No unrelated files in diff
```

Yellow-tier items: ask once, default keep. Never delete green-tier or required pairing artifacts (MSW + UI, handoff + wireframe) without explicit approval.

## Principles (default)

1. **Simplest correct diff** beats clever architecture.
2. **Extend existing** functions/components before adding parallel ones.
3. **Comments explain why**, not what.
4. **Tests prove behavior**, not line coverage theater.

## Examples

**Cut:** extract `formatLabel(x)` used once inline in JSX.

**Cut:** new `utils/authHelpers.ts` with one `isValidEmail` when `SignupPage` already validates inline.

**Keep:** `refresh()` after MFA when `RequireAuth` gates the next route — one line, real bug fix.

**Keep:** MSW handler + client module when ticket is contract-first UI.

**Add (minimal):** `refresh()` after MFA when trim review finds login bounce on gated `/onboarding` route — one line, green-tier bug fix.

## Related skills

- [CHECKLIST.md](CHECKLIST.md) — per-file pass checklist
- `review` — **after** trim (read-only Standards + Spec; does not edit the branch)
- `security-secrets-check` — after trim, before or with review
- `create-pr` — after trim + gates

Trim **diagnoses and edits**; review **reports only**. Keep separate — do not fold trim into review.
