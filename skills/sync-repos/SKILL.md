---
name: sync-repos
description: Sync GitHub repo metadata into the Obsidian vault
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash(gh *)
---

Sync GitHub repo metadata into the Obsidian vault at `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/`.

Follow these steps exactly:

## Step 1: Scan existing project notes

Read all `.md` files in both:
- `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/` (active)
- `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/Projects/Archive/` (archived)

For each file, extract the `repo_url` field from the YAML frontmatter. Parse the **owner** and **repo name** from the URL (e.g., `https://github.com/zoidburg-c/local-ocr` → owner: `zoidburg-c`, name: `local-ocr`). Build a map of repo_name → { file_path, owner, repo_url }. These are the **tracked repos** — only these repos will be synced.

Partition the tracked repos into two groups:
- **owned repos**: owner is `jumbomochi`
- **collaborator repos**: owner is anything else

## Step 2: Fetch repo data from GitHub

**For owned repos**, bulk-fetch:
```bash
gh api users/jumbomochi/repos --paginate --jq '.[] | {name, description, language, pushed_at}'
```

**For each collaborator repo**, fetch individually using the owner from `repo_url`:
```bash
gh api repos/<owner>/<repo-name> --jq '{name, description, language, pushed_at}'
```

If a collaborator repo fetch fails (e.g., 404, lost access), log a warning and skip it — do not stop the entire sync.

Merge all results into a single set of GitHub data for Step 3.

## Step 3: Update tracked project notes

For each **tracked repo** (from Step 1) that has a match in the GitHub data (from Step 2):
- Compare the `last_pushed` date in frontmatter with `pushed_at` from GitHub (use YYYY-MM-DD format, truncate the GitHub ISO timestamp).
- If the GitHub date is newer, update ONLY the `last_pushed` field in the frontmatter. Do NOT modify any other part of the file (Overview, Notes, Tasks, or other frontmatter fields).

Ignore any GitHub repos that do NOT have a matching project note. Do NOT create new notes.

## Step 4: Update CLAUDE.md Active Repos table

Read `/Users/huiliang/Library/Mobile Documents/iCloud~md~obsidian/Documents/huiliang/CLAUDE.md`. Replace the Active Repos table (everything between the `## Active Repos` heading and the next `##` heading) with an updated table. Include ONLY repos that have project notes in `Projects/` (not Archive). Format:

```
## Active Repos
| Repo | Language | Last Pushed |
|------|----------|-------------|
| [repo-name](https://github.com/<owner>/repo-name) | Language | YYYY-MM-DD |
```

Use the actual `repo_url` from each project note's frontmatter for the link. Sort the table alphabetically by repo name. Use "—" for repos with no language.

## Step 5: Print summary

After all changes, print a summary like:
```
Sync complete:
- X tracked repos found (Y active, Z archived)
- N notes updated with newer push dates
- C collaborator repos synced (W warnings)
- Active Repos table in CLAUDE.md refreshed
```

## Rules
- NEVER create new project notes. Only update existing ones.
- NEVER delete any file or any content from existing notes.
- NEVER modify user-written sections (Overview, Notes, Tasks) in existing notes.
- Only update `last_pushed` in the frontmatter of existing notes.
- If `gh` CLI is not authenticated or fails on the bulk fetch, report the error clearly and stop.
- If an individual collaborator repo fetch fails, log a warning and continue with the rest.
