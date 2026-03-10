---
name: log
description: Append an entry to the Tech Log in Obsidian
argument-hint: <log entry>
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

Append the following entry to the file at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Tech Log.md`:

```
## $ARGUMENTS
- **Date:** $(date +%Y-%m-%d %H:%M)
- **Session note:** $ARGUMENTS
```

If the file does not exist, create it with a `# Tech Log` heading first, then append the entry. Always add a blank line before each new entry.
