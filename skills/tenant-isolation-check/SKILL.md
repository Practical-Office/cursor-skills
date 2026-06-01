---
name: tenant-isolation-check
description: >-
  Reviews multi-tenant backend changes for tenant context enforcement, no
  cross-tenant data access, and no primary-tenant fallback. Use when working on
  tenant-scoped APIs, database queries, auth middleware, or when the user
  mentions multi-tenancy, tenant isolation, or tenant headers.
disable-model-invocation: true
---

# Tenant Isolation Check

Verify that backend changes cannot leak data across tenants.

## When to run

- New or modified API routes, services, or database queries
- Auth/middleware changes
- Background jobs that read or write tenant-scoped data
- Test changes that mock tenant context

## Checklist

### Tenant context required

- [ ] Every tenant-scoped request resolves tenant ID from an explicit source (header, JWT claim, session) — not from client-supplied body fields alone
- [ ] Missing or invalid tenant context returns **401/403**, not empty results or a default tenant
- [ ] Middleware or dependency injection applies tenant context before handlers run

### No cross-tenant reads or writes

- [ ] Queries filter by `tenant_id` (or equivalent) at the lowest practical layer
- [ ] Lookups by ID include tenant constraint (`WHERE id = ? AND tenant_id = ?`)
- [ ] Joins cannot bridge tenants via missing join predicates
- [ ] Admin/global endpoints are explicitly marked and gated — not accidental fallthrough

### No primary-tenant fallback

- [ ] No code path uses a hardcoded "default" or "primary" tenant when context is missing
- [ ] No `tenant_id IS NULL` or `OR tenant_id = ?` shortcuts that widen scope
- [ ] Feature flags and config are tenant-scoped where data is tenant-scoped

### Tests

- [ ] Tests cover: valid tenant, wrong tenant (expect 404/403), missing tenant (expect 401/403)
- [ ] Fixtures use distinct tenant IDs to prove isolation

## Output format

```markdown
## Tenant isolation: [PASS | FAIL | N/A]

**Scope:** [files/routes reviewed]

### Findings
- [CRITICAL/HIGH/MEDIUM] file:line — issue and fix

### Verdict
[One sentence — safe to merge / must fix before merge / not applicable (single-tenant)]
```

If the codebase is single-tenant, state **N/A** with brief rationale.
