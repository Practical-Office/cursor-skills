---
name: task-handoff
description: >-
  Produces a structured handoff document for the next agent or developer with
  goal, progress, next steps, risks, files touched, and test plan. Use when
  ending a session, switching agents, pausing work, or when the user asks for a
  handoff, status summary, or context transfer.
disable-model-invocation: true
---

# Task Handoff

Output a handoff using the template below. Save to the user's OS temp directory unless they specify a path. Do not duplicate content already in PRDs, issues, ADRs, or commits — reference by path or URL.

Redact API keys, passwords, and PII.

If the repo defines `TASK_HANDOFF_TEMPLATE.md` or similar, prefer that format; otherwise use this template.

## Handoff template

```markdown
# Task Handoff

**Date:** YYYY-MM-DD
**From session focus:** [one line]

## Goal

What we were trying to accomplish and why it matters.

## Done

- [ ] Concrete completed items with file/issue references
- [ ] Include commit SHAs or PR numbers if relevant

## Next

1. Ordered next actions (specific enough for a fresh agent)
2. Include commands to run if applicable

## Risks / open questions

- Blockers, unknowns, or decisions deferred
- Assumptions that may be wrong

## Files touched

| Path | Change summary |
|------|----------------|
| `path/to/file` | Brief note |

## Test plan

- [ ] How to verify the work so far
- [ ] Commands or manual steps
- [ ] What "done" looks like for the next chunk

## Suggested skills

Skills the next agent should invoke (e.g. `tdd`, `diagnose`, `create-pr`, `security-secrets-check`).
```

## Guidelines

- Be concise; the next reader has no conversation history
- Prefer bullet lists over prose walls
- Link to `CONTEXT.md`, ADRs, or issues when domain context matters
- If work is blocked, say exactly what unblocks it
