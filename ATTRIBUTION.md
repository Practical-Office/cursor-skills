# Attribution

## Upstream: mattpocock/skills

Most skills in this repository are adapted from [mattpocock/skills](https://github.com/mattpocock/skills), MIT licensed. We preserve Matt Pocock's copyright in [LICENSE](./LICENSE) and thank him for the original work.

**Upstream commit at initial import:** `aaf2453fbdfe7a15c07f11d861224f34ab4b53cb`

### Adapted skills (source: mattpocock/skills@aaf2453fbdfe7a15c07f11d861224f34ab4b53cb)

| Skill | Upstream path |
|-------|---------------|
| setup-practical-ai-skills | `skills/engineering/setup-matt-pocock-skills` (renamed + Practical Office branding) |
| grill-with-docs | `skills/engineering/grill-with-docs` |
| grill-me | `skills/productivity/grill-me` |
| tdd | `skills/engineering/tdd` |
| diagnose | `skills/engineering/diagnose` |
| handoff | `skills/productivity/handoff` |
| write-a-skill | `skills/productivity/write-a-skill` |
| triage | `skills/engineering/triage` |
| to-issues | `skills/engineering/to-issues` |
| to-prd | `skills/engineering/to-prd` |
| zoom-out | `skills/engineering/zoom-out` |
| review | `skills/in-progress/review` |
| improve-codebase-architecture | `skills/engineering/improve-codebase-architecture` |
| prototype | `skills/engineering/prototype` |
| ubiquitous-language | `skills/deprecated/ubiquitous-language` |
| design-an-interface | `skills/deprecated/design-an-interface` |
| request-refactor-plan | `skills/deprecated/request-refactor-plan` |
| qa | `skills/deprecated/qa` |
| setup-pre-commit | `skills/misc/setup-pre-commit` |
| caveman | `skills/productivity/caveman` |

### Adaptations applied

- Renamed `setup-matt-pocock-skills` → `setup-practical-ai-skills`
- Replaced user-facing "Matt Pocock" branding with Practical Office / Practical AI
- Normalized YAML frontmatter for Cursor (`name`, `description`, `disable-model-invocation` where appropriate)

## Original: Practical Office

These skills were written for Practical Office and are not derived from upstream:

| Skill | Notes |
|-------|-------|
| security-secrets-check | Pre-commit/PR secret scanning |
| task-handoff | Structured session handoff template |
| create-pr | GitHub PR workflow via `gh` |
| tenant-isolation-check | Multi-tenant backend review |
| release-readiness | Pre-merge release checklist |

## Updating from upstream

Run `./scripts/sync-from-upstream.sh`, review diffs, update this file with the new commit SHA, then re-run `./scripts/install.sh`.
