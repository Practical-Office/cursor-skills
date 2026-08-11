# PR-Review checklist

Apply every lens that matches the diff. **Blocker** → REQUEST_CHANGES. **Note** → may still APPROVE.

When any blocker fires, the GitHub review **and** the chat report must include **Why** (lens + evidence) and **Next steps** (author-actionable). See templates in [SKILL.md](SKILL.md) Step 4 — never fail with a bare “needs work” / “CI red”.

## Always

| Lens | Blocker if… |
|---|---|
| Claim vs diff | PR body/acceptance not implemented, or tests assert the wrong contract |
| Fail-closed | Errors/missing config fabricate success (e.g. fake `connected: true`, silent auth widen) |
| Secrets | Tokens, passwords, or raw credentials in git, logs, or browser/API responses |
| Tenant / persona | Cross-tenant leak, staff↔customer path confusion, primary-tenant fallback |
| CI | Required checks failed or still running |
| SoT honesty | Docs mark Open/Done contrary to live `gh` issue/PR state |

## Helm / ESO / deploy pins

| Lens | Blocker if… |
|---|---|
| Secret path | ESO `remoteRef.key` / `property` disagrees with provisioned Secrets Manager shape |
| Image pin | Tag is not on `main` ancestry claimed, or pin regresses a just-merged security fix on the same values file without intent |
| QA / runtime env | Portal (or other) pods regain credentials they must not `envFrom` |

## Auth / Cognito / oauth2-proxy

| Lens | Blocker if… |
|---|---|
| Group recovery | Customer recovery grants staff, or staff role-store users reach customer routes |
| Tenant claim | BookIQ tenant UUID preferred over FRS tenant when product rule is FRS-owned |
| Strip/fail-closed | Missing `client_id` / groups still opens the route |

## Parsers / sync intake

| Lens | Blocker if… |
|---|---|
| Schema dual-accept | v1 gate weakened while claiming dual-accept, or GL/P&L column rules wrong |
| Alias / field map | Column alias missing for the stated producer shape; counters stay degraded |

## Portal / SPA / e2e

| Lens | Blocker if… |
|---|---|
| Customer copy | UI promises auto-import the product cannot deliver |
| Fan-out isolation | One engagement failure aborts the whole page without intent |
| Playwright mocks | Navigation waits on `load` against unresolvable hosts; DNS flake on nightly |

## Ops / runbooks

| Lens | Blocker if… |
|---|---|
| Prevention claims | Runbook asserts a Terraform/Helm pin or cluster state that `main` does not have |
| Dangerous steps | Upgrade/rollback omits pause-autosync / restore prune+selfHeal style guards when the procedure needs them |

## Soft notes (non-blocking)

- Staging smoke deferred with an honest checklist
- `main` tip ahead of an intentional image pin (docs/e2e-only commits)
- Missing stress test when unit coverage already hits the seam
- Forward doc links that land in a sibling open PR (prefer batch order; hold only if the PR is docs-only and the link is its parent SoT)
