---
name: catchup
description: Use when starting a new session to catch up on recent repo activity, or when the user asks what's changed, what's been happening, or wants a status update on the project
allowedTools:
  - Bash(git log *)
  - Bash(git status *)
  - Bash(git branch *)
  - Bash(git diff --stat *)
  - Bash(git shortlog *)
  - Bash(gh pr list *)
  - Bash(gh pr view *)
  - Bash(gh issue list *)
  - Read
  - Glob
  - Grep
---

# Catchup

Quickly catch up on recent repo development so you can resume work with full context.

## Workflow

1. **Git status** — show current branch, uncommitted changes, stashes
2. **Recent commits** — summarize last ~20 commits on main and active branches
3. **Active branches** — list branches with recent activity
4. **Open PRs** — list any open pull requests with status
5. **Open issues** — list any open issues
6. **Memory check** — read MEMORY.md for saved project context
7. **Summarize** — present a concise briefing to the user

## Steps

### 1. Current State

```bash
git status
git stash list
git branch -a --sort=-committerdate | head -15
```

### 2. Recent Commits

```bash
git log --oneline --graph --all -20
git log --format="%h %ad %an: %s" --date=relative -20
```

### 3. What Changed

```bash
git diff --stat HEAD~10..HEAD
```

Show which files have been most active recently.

### 4. Open PRs and Issues

```bash
gh pr list --state open --json number,title,author,updatedAt,headRefName 2>/dev/null
gh issue list --state open --json number,title,labels --limit 20 2>/dev/null
```

Skip silently if `gh` is not available or repo has no remote.

### 5. Memory Context

Read `MEMORY.md` if it exists in the project memory directory for saved context from prior sessions.

### 6. Briefing

Present a concise summary organized as:

- **Current state**: branch, uncommitted work
- **Recent activity**: key commits grouped by theme/feature
- **In-flight work**: open PRs, branches, issues
- **Relevant context**: anything from memory that's useful

Keep it scannable. Use bullet points, not paragraphs. Flag anything that looks like it needs attention (merge conflicts, stale branches, failing CI).
