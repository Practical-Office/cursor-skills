# Practical Office Cursor Skills

Org-wide [Cursor Agent Skills](https://cursor.com/docs/agent/skills) for Practical Office engineers. Install once per machine; run `setup-practical-ai-skills` once per application repository.

Skills are **workflows and procedures**. They complement (do not replace) project-specific `.cursor/rules/` and `.cursor/agents/` — skills add reusable playbooks on top.

**Process:** For the seven-phase pipeline (Idea → Research → Prototype → PRD → Kanban → Execution → QA) and when to invoke each skill in chat, see **[AI-Driven Development SOP](docs/AI-Development-SOP.md)**.

## Quickstart

### One-time install (per machine)

```bash
git clone https://github.com/Practical-Office/cursor-skills.git
cd cursor-skills
./scripts/install.sh
```

This symlinks all skills into `~/.cursor/skills/` so every Cursor project can use them.

Optional: also copy into the current repo:

```bash
./scripts/install.sh --project
```

### Once per application repo

Open the repo in Cursor and invoke **`setup-practical-ai-skills`**. It scaffolds:

- `docs/agents/issue-tracker.md` — GitHub (default), GitLab, or local markdown
- `docs/agents/triage-labels.md` — label vocabulary for the `triage` skill
- `docs/agents/domain.md` — how skills consume `CONTEXT.md` and `docs/adr/`
- An `## Agent skills` block in `AGENTS.md` or `CLAUDE.md`

Run this before using `to-issues`, `triage`, `tdd`, `diagnose`, and related engineering skills.

## How to invoke skills

- **By name:** type the skill name in chat (e.g. `tdd`, `create-pr`, `security-secrets-check`)
- **By description:** Cursor loads skills when your request matches their description triggers
- Most skills set `disable-model-invocation: true` — invoke them explicitly for predictable behavior

## Skill index (26)

| Skill | Purpose |
|-------|---------|
| **setup-practical-ai-skills** | One-time per-repo setup: issue tracker, triage labels, domain docs |
| **grill-with-docs** | Resolve domain terms and decisions; lazily creates CONTEXT.md and ADRs |
| **grill-me** | Socratic questioning to clarify thinking before building |
| **tdd** | Test-driven development workflow with deep-module guidance |
| **diagnose** | Systematic debugging with hypothesis-driven investigation |
| **handoff** | Compact conversation into a handoff for another agent |
| **write-a-skill** | Author new Cursor skills following best practices |
| **triage** | Process incoming issues through the triage state machine |
| **to-issues** | Break work into well-specified GitHub issues |
| **to-prd** | Turn ideas into a product requirements document |
| **zoom-out** | Step back from implementation to see the bigger picture |
| **review** | Review an issue or PR against project standards |
| **trim-pr** | Pre-merge diff cleanup — cut scope creep and over-engineering |
| **improve-codebase-architecture** | Analyze and propose architectural improvements |
| **prototype** | Rapid prototype with explicit UI vs logic separation |
| **ubiquitous-language** | Align code and docs on domain vocabulary |
| **design-an-interface** | Design module/API interfaces before implementation |
| **request-refactor-plan** | Request a structured refactoring plan |
| **qa** | Quality assurance checklist for features |
| **setup-pre-commit** | Configure pre-commit hooks for a repo |
| **caveman** | Strip problem to essentials ("caveman debugging") |
| **security-secrets-check** | Scan diffs for leaked secrets before commit/PR |
| **task-handoff** | Structured handoff template (goal, done, next, risks, tests) |
| **create-pr** | Create GitHub PR via `gh`: status, diff, push, PR body |
| **tenant-isolation-check** | Review multi-tenant changes for cross-tenant leaks |
| **release-readiness** | Pre-merge checklist: tests, docs, rollback, security |

## Updating skills

```bash
cd cursor-skills
git pull
./scripts/install.sh
```

To refresh from [mattpocock/skills](https://github.com/mattpocock/skills) upstream:

```bash
./scripts/sync-from-upstream.sh
# review diffs, update ATTRIBUTION.md commit SHA
./scripts/install.sh
```

## Repository layout

```
cursor-skills/
├── README.md
├── docs/
│   └── AI-Development-SOP.md
├── LICENSE
├── ATTRIBUTION.md
├── scripts/
│   ├── install.sh
│   └── sync-from-upstream.sh
└── skills/
    └── <skill-name>/
        └── SKILL.md
```

Install target: `~/.cursor/skills/<skill-name>/` (never `~/.cursor/skills-cursor/` — Cursor-managed built-ins only).

## Coexistence with project config

| Scope | Path | What lives here |
|-------|------|-----------------|
| Org skills (this repo) | `~/.cursor/skills/` | Reusable workflows |
| Project rules | `.cursor/rules/` | Doctrine, gates, conventions |
| Project agents | `.cursor/agents/` | Agent definitions |
| Per-repo skill config | `docs/agents/` | Issue tracker, labels, domain layout |

BookIQ and other repos keep `.cursor/rules` and `.cursor/agents` unchanged. Skills add workflows without conflicting with project doctrine.

## Smoke test checklist

Run after install or before calling a release done:

- [ ] `./scripts/install.sh` populates `~/.cursor/skills/` with 25 folders
- [ ] Each folder has valid `SKILL.md` with `name` and `description` frontmatter
- [ ] `setup-practical-ai-skills` internal links resolve (issue-tracker-*.md, triage-labels.md, domain.md)
- [ ] README skill count (25) matches `ls skills | wc -l`
- [ ] No secrets or tokens in committed files
- [ ] In an app repo: invoke `setup-practical-ai-skills` and confirm `docs/agents/` is created

Quick verify:

```bash
./scripts/install.sh
ls ~/.cursor/skills | wc -l          # expect 25
for d in skills/*/; do grep -q '^name:' "$d/SKILL.md" || echo "MISSING: $d"; done
```

## Team rollout

1. Share this repo URL with the team
2. Each developer runs the one-time install
3. Each application repo gets `setup-practical-ai-skills` once
4. Pin this repo in team docs; `git pull && ./scripts/install.sh` for updates

## Attribution

Engineering and productivity skills are adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). See [ATTRIBUTION.md](./ATTRIBUTION.md) and [LICENSE](./LICENSE).

Tier C skills (`security-secrets-check`, `task-handoff`, `create-pr`, `tenant-isolation-check`, `release-readiness`) are original Practical Office work.
