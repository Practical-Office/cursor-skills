---
name: prove-before-pr
description: >-
  use this before opening a PR on a behavior-changing ticket — collect
  before/after evidence (screenshot, short recording, or metric) and put a
  Prove section in the PR body
disable-model-invocation: true
---

# Prove before PR

Evidence in the PR. Not vibes.

## When to run

After the ticket's acceptance work is done locally, **before** `/create-pr`, when the change affects UI, API, workers, connectors, or money paths.

## When N/A is allowed

Docs-only, comment-only, or pure rename/refactor. Write `Prove: N/A` and one sentence why. Do not abuse N/A for "hard to screenshot."

## Steps

1. State the claim in one sentence (what a reviewer should see).
2. Capture **one** primary evidence type:
   - Screenshot (before and after when possible), or
   - Short screen recording, or
   - Metric before → after (with how you measured)
3. Store evidence where the team can open it (PR comment upload, Drive, or CI artifact). Prefer attaching images to the PR.
4. Hand `/create-pr` a body that includes:

```markdown
## Summary
- …

## Prove
- Claim: …
- Evidence: [link or attached image]
- How to recheck: …

## Test plan
- [ ] …
```

5. If you cannot produce evidence, stop and fix the build or ask a human. Do not open the PR empty.

## Polar / reviewer rule (companion)

On behavior PRs, empty Prove → REQUEST_CHANGES with Why + Next steps pointing at this skill. Staging `gates/` and money write-blocks remain separate fail-closed checks.

## Related

- AI-Development-SOP Phase 6 Prove
- `/create-pr`, `/pr-review`
- App repo `gates/` for staging prove
