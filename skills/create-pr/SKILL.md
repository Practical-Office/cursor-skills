---
name: create-pr
description: >-
  Creates a GitHub pull request using gh CLI: gathers git status and diff vs
  base, pushes branch, and opens PR with Summary and Test plan. Use when the
  user asks to create a PR, open a pull request, or submit changes for review.
disable-model-invocation: true
---

# Create Pull Request

Use `gh` for all GitHub operations. Never force-push to `main` or `master`.

## Process

### 1. Understand branch state

Run in parallel:

```bash
git status
git diff
git branch -vv
git log --oneline -10
```

Determine the base branch (usually `main` or `master` from remote default):

```bash
git remote show origin | grep 'HEAD branch'
```

Full change set for the PR:

```bash
git log [base-branch]...HEAD
git diff [base-branch]...HEAD
```

### 2. Draft the PR

Analyze **all commits** on the branch, not just the latest. Write:

- **Title:** concise, reflects the "why"
- **Summary:** 1–3 bullets on what changed and why
- **Test plan:** checklist of verification steps

### 3. Push and create

```bash
git push -u origin HEAD
```

```bash
gh pr create --title "the pr title" --body "$(cat <<'EOF'
## Summary
- ...

## Test plan
- [ ] ...

EOF
)"
```

Use a HEREDOC for the body to preserve formatting.

### 4. Return the PR URL

Share the URL from `gh pr create` output so the user can open it.

## Safety rules

- **Never** `git push --force` to `main`/`master` — warn the user if requested
- **Never** update git config
- Do not skip hooks unless the user explicitly requests it
- Do not commit `.env` or credential files; run `security-secrets-check` if unsure
- Do not push unless the user asked (creating a PR implies push is OK)

## If blocked

- Missing `gh` auth → tell user to run `gh auth login`
- No remote or diverged branch → explain and ask how to proceed
- Empty diff vs base → do not open an empty PR
