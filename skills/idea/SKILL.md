---
name: idea
description: Capture a new project idea in the Obsidian vault
argument-hint: <idea description>
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

Capture a new project idea in the Obsidian vault at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/`.

The idea: $ARGUMENTS

Follow these steps:

## Step 1: Append to today's daily note

Check if today's daily note exists at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/DailyNotes/YYYY-MM-DD.md` (use today's date).

- If it exists, find the `## Ideas` section and append the idea there as a bullet point with the `#idea` tag:
  ```
  - #idea $ARGUMENTS
  ```
- If it does NOT exist, create it with this content:
  ```
  ---
  type: daily
  date: YYYY-MM-DD
  tags: [daily]
  ---

  # YYYY-MM-DD, Day

  ## What I'm working on
  -

  ## Cross-repo notes

  ## Ideas
  - #idea $ARGUMENTS

  ## Blockers / Questions

  ## End of day
  ```

## Step 2: Confirm

Print:
```
Idea captured in DailyNotes/YYYY-MM-DD.md:
- #idea $ARGUMENTS
```

## Rules
- NEVER delete or overwrite existing content in the daily note.
- Only append to the Ideas section.
- Always use the #idea tag so Dataview can query it.
