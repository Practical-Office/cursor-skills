---
name: security-secrets-check
description: >-
  Scans staged changes and diffs for leaked secrets, API keys, tokens, and
  credentials before commit or PR. Use when preparing commits, opening pull
  requests, reviewing diffs, or when the user mentions secrets, tokens, .env
  files, or credential leaks.
disable-model-invocation: true
---

# Security Secrets Check

Run before commit or PR to catch credential leaks early.

## Process

### 1. Scan the diff

Inspect what will be committed or included in the PR:

```bash
git diff --cached          # staged
git diff [base]...HEAD     # branch vs base for PRs
git status                 # untracked files that may contain secrets
```

Look for:

- API keys, bearer tokens, JWTs, private keys, connection strings with passwords
- Hardcoded `sk-`, `ghp_`, `gho_`, `AKIA`, `xoxb-`, `-----BEGIN` blocks
- `.env`, `.env.local`, `credentials.json`, `*.pem`, `*.p12` being added or modified
- Secrets echoed in logs, test fixtures, or API response examples

### 2. Check API responses and fixtures

If the diff touches handlers, serializers, or tests:

- Confirm responses do not include raw tokens, refresh tokens, or internal secrets
- Flag test fixtures that embed real-looking credentials (use obvious placeholders like `test-token-replace-me`)

### 3. Report findings

For each issue, classify severity:

| Severity | Example | Action |
|----------|---------|--------|
| **Block** | Live API key in source | Remove from diff; do not commit |
| **Block** | `.env` with real values staged | Unstage; ensure `.gitignore` covers it |
| **Warn** | Placeholder that looks too realistic | Replace with clearly fake values |
| **Info** | `.env.example` with empty placeholders | OK if no real values |

### 4. If a secret was already committed

1. **Do not** commit further copies of the secret
2. Tell the user the secret is exposed in git history
3. Recommend **rotation immediately** — revoking and reissuing beats scrubbing history alone
4. Note that history rewrite requires explicit user approval; focus on rotation first

## Output format

```markdown
## Secrets check: [PASS | FAIL | WARN]

### Findings
- [BLOCK/WARN/INFO] file:line — description

### Recommended actions
1. ...

### Rotation needed
- [service] — rotate if this was ever pushed to a shared remote
```

If no issues: state **PASS** with one line on what was scanned.
