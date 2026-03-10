---
name: track-repo
description: Start tracking a new GitHub repo in the Obsidian vault
argument-hint: <repo-name>
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash(gh *)
---

Start tracking a new GitHub repo in the Obsidian vault at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/`.

The repo identifier: $ARGUMENTS

This can be either:
- A full GitHub URL (e.g., `https://github.com/owner/repo`)
- An `owner/repo` string (e.g., `jumbomochi/my-repo`)
- Just a repo name (e.g., `my-repo`) — defaults to owner `jumbomochi`

Parse the owner and repo name from the argument before proceeding.

Follow these steps exactly:

## Step 1: Check if already tracked

Check if a project note already exists for this repo in:
- `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/`
- `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/Archive/`

If a note already exists, print "Already tracked: <file_path>" and stop.

## Step 2: Fetch repo data from GitHub

Run:
```bash
gh api repos/<OWNER>/<REPO_NAME> --jq '{name, description, language, pushed_at}'
```

If the repo doesn't exist or the command fails, print the error and stop.

## Step 3: Create the project note

Create a new file at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/<repo-name>.md` with this format:

```
---
type: project
status: active
repo_url: https://github.com/<OWNER>/<REPO_NAME>
language: <LANGUAGE>
tags: [<lowercase language tag>]
last_pushed: <YYYY-MM-DD from pushed_at>
---

# <REPO_NAME>

## Overview
<DESCRIPTION from GitHub, or leave empty if null>

## Notes


## Tasks
- [ ]
```

If language is null, omit the `language` field entirely and leave tags as `[]`.

## Step 4: Update CLAUDE.md Active Repos table

Read `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/CLAUDE.md`. Add the new repo to the Active Repos table in alphabetical order. Use "—" for repos with no language. Do not remove or modify any existing rows.

## Step 5: Confirm

Print:
```
Now tracking: <repo-name>
- Project note created: Projects/<repo-name>.md
- CLAUDE.md table updated
- Language: <language or "none">
- Last pushed: <YYYY-MM-DD>
```

## Rules
- NEVER overwrite an existing project note.
- If the repo is not found on GitHub, report the error and stop.
