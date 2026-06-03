# Trim PR — per-file checklist

Run mentally (or copy into chat) for each changed file.

```
File: ____________________
Ticket requirement it serves: ____________________

[ ] Every hunk maps to that requirement
[ ] No drive-by rename/format in this file
[ ] No new abstraction with a single call site
[ ] No comment that duplicates the code below it
[ ] No test that would still pass if the feature were deleted
[ ] Uses existing repo helpers instead of new duplicates
[ ] Error/loading/empty states only where route actually needs them
[ ] Imports trimmed — no unused types or barrel re-exports added "for later"
```

## Red flags — cut immediately (no ask)

- New file `<Feature>Utils.ts` under 30 lines, one consumer
- `interface Props` with one optional field and no reuse
- `// Handle edge case` with no linked ticket or ADR
- Test named `should render correctly` with only `getByTestId` existence assert
- Changed file not mentioned in ticket, handoff, or PR summary

## Yellow flags — ask once; default keep if no answer

- New MSW handler (green tier if project DoD requires MSW-first)
- Handoff / testid map (green tier if ticket DoD requires)
- Slightly verbose test setup shared across 3+ cases
- Small helper shared within same file across 2+ call sites — OK if readability wins

## Green flags — never cut without explicit user instruction

- Bug fix required for acceptance path (e.g. auth refresh before gated route) — may require minimal add
- Contract types mirroring OpenAPI snippet
- Scoped vitest/axe covering ticket test plan
- testid attributes from wireframe map
