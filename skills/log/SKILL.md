---
name: log
description: Append a session log entry to the current repo's Obsidian project note
argument-hint: <log entry>
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

Log a session entry to the current repo's Obsidian project note.

## Steps

1. Determine the current repo name from `git remote get-url origin` (strip to repo name), or fall back to the current directory name.
2. Find the matching project note at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/<repo-name>.md`.
3. If the project note does not exist, tell the user and stop.
4. Append an entry under the `## Notes` section, at the top (directly after the heading), in this format:

```
### <today's date YYYY-MM-DD>
<concise summary of what was accomplished, key decisions made and why, and what's next — written as a short paragraph or a few bullet points>
```

5. Use $ARGUMENTS as context for what to log. If no arguments are provided, summarize based on the current conversation context.
6. If a `### <today's date>` entry already exists, DO NOT replace or rewrite it. Add new lines below the existing content under that heading. Never modify or remove existing text.
