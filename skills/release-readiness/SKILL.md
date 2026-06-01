---
name: release-readiness
description: >-
  Pre-merge release checklist covering tests, docs, rollback, security, and
  breaking changes. Use before merging to main, cutting a release, or when the
  user asks if a branch is ready to ship.
disable-model-invocation: true
---

# Release Readiness

Run before merging to main or tagging a release. Some repos (e.g. BookIQ) define stricter gates in `.cursor/rules/RELEASE_GATES.md` — read and apply those if present.

## Checklist

### Tests

- [ ] Unit/integration tests pass locally or CI is green
- [ ] New behavior has test coverage; bug fixes have regression tests
- [ ] E2E or contract tests updated if API surface changed

### Documentation

- [ ] README, API docs, or OpenAPI updated for user-visible changes
- [ ] Migration notes for schema or config changes
- [ ] ADR or changelog entry if architecture or behavior changed materially

### Rollback

- [ ] Rollback path documented (revert commit, feature flag, migration down script)
- [ ] Database migrations are backward-compatible or have a documented down migration
- [ ] No irreversible one-way data transforms without backup plan

### Security

- [ ] No secrets in diff (see `security-secrets-check`)
- [ ] Auth/authz paths reviewed for tenant isolation if applicable (see `tenant-isolation-check`)
- [ ] Dependencies with known CVEs addressed or accepted with note

### Breaking changes

- [ ] Breaking API or config changes called out in PR description
- [ ] Version bump or deprecation notice if consumers exist
- [ ] Coordinated deploy order noted if multiple services involved

## Output format

```markdown
## Release readiness: [READY | NOT READY | READY WITH NOTES]

### Checklist summary
| Area | Status | Notes |
|------|--------|-------|
| Tests | ✅/❌/⚠️ | |
| Docs | | |
| Rollback | | |
| Security | | |
| Breaking changes | | |

### Blockers
- [must-fix items]

### Notes for release
- [optional follow-ups, monitoring, feature flags]
```

**READY** only when no blockers remain. **READY WITH NOTES** when shippable but follow-ups exist.
