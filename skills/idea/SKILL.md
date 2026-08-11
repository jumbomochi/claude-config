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

## Step 2: Create an idea note in Ideas/

Create a new file at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Ideas/<Idea Title>.md` using a short, descriptive Title Case name derived from the idea description.

Use this template:
```
---
type: idea
cssclasses: [idea]
status: brainstorming
tags: []
created: YYYY-MM-DD
---

# <Idea Title>

## Problem / Motivation
<One-sentence summary extracted from the idea description>

## What it could look like


## Tech considerations


## Open questions

```

- If a file with the same name already exists, do NOT overwrite it. Skip this step and note it in the confirmation.

## Step 3: Link the daily note entry to the idea note

Go back to the bullet point added in Step 1 and update it to include a wiki-link to the new idea note:
```
- #idea [[<Idea Title>]] — <brief description>
```

## Step 4: Confirm

Print:
```
Idea captured:
  Daily note: DailyNotes/YYYY-MM-DD.md
  Idea note:  Ideas/<Idea Title>.md
  - #idea [[<Idea Title>]] — <brief description>
```

## Rules
- NEVER delete or overwrite existing content in the daily note.
- Only append to the Ideas section.
- Always use the #idea tag so Dataview can query it.
- NEVER overwrite an existing idea note in Ideas/.
