# AI-Driven Development SOP

Companion to this repository's skills — the [README](../README.md) owns install and per-skill behavior; this doc owns the **seven-phase process** and where to invoke each skill in chat.

---

## Purpose

Seven-phase pipeline for shipping software with AI coding assistants:

```
1. Idea → 2. Research → 3. Prototype → 4. PRD → 5. Kanban → 6. Execution → 7. QA
                                                                              ↓
                                                                (new tickets → 5 → 6 → 7)
```

Phase 7 loops to Phase 5 until QA passes. After a stable slice, optional **post-cycle** updates the PRD and starts the next idea.

**Tool:** Cursor (repo, skills, board, code).

---

## Before Phase 1

1. Install skills on your machine — [Quickstart](../README.md#quickstart).
2. In the app repo, run `/setup-practical-ai-skills` and commit `docs/agents/` + `AGENTS.md` (or `CLAUDE.md`).
3. Optional: `/setup-pre-commit` after the repo scaffold exists.

---

## Scope

**In scope:** Features and products that benefit from research → prototype → PRD → tickets → build → human QA.

**Out of scope:** One-line typos (Idea → Execution); emergency hotfixes (narrow idea, skip to Execution when obvious).

---

## Phase overview


| #   | Phase     | Goal                                      | Primary artifact            |
| --- | --------- | ----------------------------------------- | --------------------------- |
| 1   | Idea      | Name the problem or opportunity           | Idea note or issue          |
| 2   | Research  | Resolve unknowns before building          | `docs/research/{topic}.md`  |
| 3   | Prototype | Validate approach and taste               | Throwaway code + verdict    |
| 4   | PRD       | Lock end-state product intent             | Versioned `docs/prd/PRD.md` |
| 5   | Kanban    | Break PRD into tickets on a board         | Board + `wbs.md`            |
| 6   | Execution | Implement tickets                         | Merged PRs, Done            |
| 7   | QA        | Human verification; file fixes as tickets | QA plan + new issues        |


---

# Phase 1: Idea

## Goal

Capture why you're building before research or code.

## Entry criteria

- A stakeholder has a problem, opportunity, or task worth pursuing

## Activities

1. Open a **dedicated idea chat** (not implementation).
2. State the idea in one paragraph: who it helps, what changes, why now.
3. Run `/grill-with-docs`** if the repo has `CONTEXT.md` / ADRs — stress-test the idea against domain language. Use `/grill-me` if there is no glossary yet.
4. Classify: **full pipeline** (Phases 2–7) vs **short path** (skip some phases).
5. Record: GitHub issue `Idea: …`, or `docs/ideas/{slug}.md`.
6. Optional: `/zoom-out`** if you need a codebase map before research.

## Exit criteria

- Idea written down; decision logged: full pipeline vs short path

## Example prompt

```text
/grill-with-docs

I want to explore [idea]. One-paragraph problem statement + open questions.
Do not write code or a PRD yet.
```

## Short-path skips


| Idea type                    | Typical skip                                   |
| ---------------------------- | ---------------------------------------------- |
| Obvious bug with known fix   | Research, Prototype, PRD → Kanban or Execution |
| Tiny refactor                | Research, Prototype, PRD                       |
| New product or major feature | None                                           |


---

# Phase 2: Research

## Goal

Investigate unknowns before prototype or PRD. Cache findings in the repo.

## Entry criteria

- Phase 1 complete
- At least one open question code or docs cannot answer quickly

## Activities

1. Open a **research chat** scoped to the unknowns list.
2. Explore the codebase; run `/zoom-out`** for a module-level map if needed.
3. If a **blocking production bug** blocks research, run `/diagnose`** (understand/fix the blocker — not feature work).
4. Write `docs/research/{topic}.md`: question, findings, recommendations, open questions.
5. Update `CONTEXT.md` or ADRs if terms or decisions crystallize.

## Exit criteria

- No blocking unknowns for PRD/prototype, or risks explicitly accepted
- Research doc committed and linked from the idea issue

## Example prompt

```text
/zoom-out

Research phase for [idea].

Open questions:
[list from Phase 1]

Output: docs/research/[topic].md with findings and recommendations.
/diagnose only if a blocking bug blocks research.

Do not prototype or write production code.
```

## Skip

Short path with no unknowns → Phase 3 or 4.

---

# Phase 3: Prototype

## Goal

Validate design and taste in throwaway code before production commitment.

## Entry criteria

- Phase 2 complete (or skipped with reason)
- At least one decision cheaper to try in code than in a PRD debate

## Activities

1. Run `/prototype` — terminal/state-machine branch or UI variations on a throwaway route.
2. For API or module shape only (no full UI), use `/design-an-interface` instead.
3. Run locally; iterate with a human until decisions land.
4. Capture a **verdict** (ship vs reject) in `NOTES.md`, an issue comment, or PRD notes.
5. Delete throwaway code or commit it marked `PROTOTYPE`.

## Exit criteria

- Key questions answered; verdict written; human sign-off for PRD

## Example prompt

```text
/prototype

Question: [what we're validating]

Build throwaway [UI variations | terminal explorer]. One command to run. No tests.
Summarize verdict: what we ship vs what we rejected.
```

## Skip

Mechanical change or research already proved the approach.

---

# Phase 4: PRD

## Goal

Describe end state: problem, solution, stories, testing, out of scope — before Kanban.

## Entry criteria

- Phase 3 complete (or skipped)
- Research and prototype notes available

## Activities

1. Open a **PRD chat** with idea, `docs/research/*`, prototype notes, `@CONTEXT.md`.
2. Run `/to-prd`** to draft a versioned PRD (e.g. `docs/prd/PRD.md`).
3. Optional: `/ubiquitous-language` if you need a formal glossary beyond `CONTEXT.md`.
4. Run `/grill-with-docs` — one question at a time; update `CONTEXT.md` / ADRs; stop when ready for issues.
5. **Architect** approves version, changelog, and scope.

## Exit criteria

- Approved PRD committed; glossary/ADRs consistent; no blocking ambiguities

## Example prompt — grill

```text
/grill-with-docs

Stress-test docs/prd/PRD.md v[X.Y.Z] against CONTEXT.md, research, and prototype verdict.

Ask one question at a time. Update CONTEXT.md when we decide. Stop when ready for /to-issues.
```

---

# Phase 5: Kanban

## Goal

Break the PRD into small vertical-slice tickets with dependencies on a board.

## Entry criteria

- Approved PRD version
- Active phase identified (for multi-phase PRDs)

## Activities

1. Draft `docs/phases/{phase}/kickoff.md` (goal, scope, risks) if the team uses phase kickoffs.
2. **One planning chat per phase.** Run `/to-issues`** on PRD + kickoff — vertical slices, size S, dependencies, HITL vs AFK; quiz before publish.
3. Publish issues; link to a phase epic if used.
4. Run `/triage` on each issue — labels per `docs/agents/triage-labels.md` (`ready-for-agent` vs `ready-for-human`).
5. Large refactor only: `/request-refactor-plan` first, then one tracking issue.
6. Commit `docs/phases/{phase}/wbs.md` as a snapshot.

### Board columns (typical)

```
Backlog → Triage → Ready → In Progress → In Review → Done
                         ↘ Blocked ↗
```

**Definition of Ready:** size S, acceptance criteria, phase + PRD version; AFK tickets labeled `ready-for-agent`.

## Exit criteria

- Board approved; at least one issue **Ready** for Phase 6

## Example prompt

```text
/to-issues

PRD: docs/prd/PRD.md (vX.Y.Z). Kickoff: docs/phases/[phase]/kickoff.md.

Vertical slices only, size S. HITL/AFK, priorities, Blocked by, phase labels.
Quiz me before publishing. Then /triage for agent vs human readiness.
```

---

# Phase 6: Execution

## Goal

Implement **Ready** tickets until in-scope work is **Done**.

## Entry criteria

- Phase 5 approved; issues in **Ready**

## Activities

1. **One new chat per ticket** — never one chat for the whole phase.
2. **Plan** — subtasks, files, tests; no code. Long tickets: `/task-handoff`** to persist plan.
3. **Build** — `/tdd`**, one subtask at a time.
4. **Debug** on the ticket — `/diagnose`** for hard bugs or perf regressions.
5. **Pre-PR** — `/security-secrets-check`** → `/review` → `/create-pr`.
6. Move issue: Ready → In Progress → In Review → Done on merge.
7. Context getting full — `/handoff` or Cursor `/summarize`, then a fresh chat with paths only.

### AFK loop (optional)

Pick `Ready` + `ready-for-agent` + unblocked → new chat per issue → plan → `/tdd` → gates → PR → merge → repeat. Never auto-pick HITL tickets.

## Exit criteria

- In-scope execution tickets **Done**; tests green

## Example prompt — build

```text
/tdd

Implement subtask [k] only from approved plan for issue #[N]. Stay in scope.
```

---

# Phase 7: QA

## Goal

Human verifies the slice; gaps become new tickets → Phase 5 → 6 → 7 until pass.

## Entry criteria

- Phase 6 complete; build runnable; tests green

## Activities

1. Produce `docs/phases/{phase}/qa-plan.md` from PRD acceptance criteria and what shipped.
2. Human runs the plan (smoke, exploratory, demo).
3. `/qa` — report bugs conversationally; agent files durable issues.
4. `/triage` new issues to Backlog or Ready.
5. Before close: `/release-readiness` (and repo release rules if you have them).
6. Multi-tenant backend: `/tenant-isolation-check` on relevant changes.

## Exit criteria

- QA plan passed; sign-off recorded; no open P0/P1 (or deferred with architect approval)

## Example prompt

```text
/qa

Phase [name] testing. File each finding as a GitHub issue with acceptance criteria.
```

---

# Post-cycle

After Phase 7 passes:

1. `docs/phases/{phase}/delta-report.md` — planned vs actual.
2. `/handoff` or `/task-handoff` → `handoff-to-acr.md`.
3. ACR chat: `/to-prd` only — bump PRD from delta + handoff; no code.
4. Architect sign-off; close phase epic; next work at Phase 1 (or Phase 4 for a new PRD phase only).

Optional later: `/improve-codebase-architecture` for deferred structural debt.

---

## Working rules

1. Do not skip phase order without documenting why in the idea or kickoff.
2. Durable truth in the repo (PRD, research, board, WBS); chats are ephemeral.
3. One planning chat per phase; one implementation chat per ticket.
4. Plan before build in Phase 6.
5. QA findings always become tickets — not chat-only fixes.
6. Board is the source of truth for work in flight.

---

## Related


| Document                                                                            | Role                                                               |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| [README](../README.md) | Skill catalog, install, and per-skill behavior |
| App repo `AGENTS.md` | Build commands, scope, team conventions |
| App repo `docs/agents/*` | Issue tracker and triage labels (from `setup-practical-ai-skills`) |


