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

**For owned repos**, bulk-fetch via the **authenticated** endpoint so **private repos are included** (the vault is for personal use — every owned repo must sync). Filter to owner `jumbomochi`:
```bash
gh api user/repos --paginate --jq '.[] | select(.owner.login=="jumbomochi") | {name, description, language, pushed_at}'
```
Do NOT use `users/jumbomochi/repos` — that endpoint returns public repos only and silently omits private ones.

**For each collaborator repo**, fetch individually using the owner from `repo_url`:
```bash
gh api repos/<owner>/<repo-name> --jq '{name, description, language, pushed_at}'
```

If a collaborator repo fetch fails (e.g., 404, lost access), log a warning and skip it — do not stop the entire sync.

Merge all results into a single set of GitHub data for Step 3.

## Step 3: Update tracked project notes

For each **tracked repo** (from Step 1) that has a match in the GitHub data (from Step 2):
- Compare the `last_pushed` date in frontmatter with `pushed_at` from GitHub (use YYYY-MM-DD format, truncate the GitHub ISO timestamp).
- If the GitHub date is newer:
  1. Update the `last_pushed` field in the frontmatter.
  2. Fetch commits since the old `last_pushed` date. Pass `since` as a **GET query param** in the URL — using `-f`/`-F` makes `gh api` issue a POST and the endpoint returns 404:
     ```bash
     gh api "repos/<owner>/<repo-name>/commits?since=<old_last_pushed>T00:00:00Z&per_page=100" --jq '.[].commit.message | split("\n")[0]'
     ```
  3. Append an activity entry to the `## Notes` section with this format:
     ```
     ### <YYYY-MM-DD>
     <one-line summary of what was done, synthesized from the commit messages — not a raw list of commits>
     ```
     - Synthesize the commits into a **concise, human-readable summary** (1-3 sentences). Group related changes together. Focus on *what was accomplished*, not individual commits.
     - Append the entry at the **top** of the Notes section (directly after `## Notes`), so the most recent activity appears first.
     - If a `### <YYYY-MM-DD>` entry already exists for that date, append to it instead of creating a duplicate.
     - Do NOT modify or remove any existing notes content.

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
- N notes updated with newer push dates and activity summaries
- C collaborator repos synced (W warnings)
- Active Repos table in CLAUDE.md refreshed
```

## Rules
- NEVER create new project notes. Only update existing ones.
- NEVER delete any file or any content from existing notes.
- NEVER modify the Overview or Tasks sections in existing notes.
- Only update `last_pushed` in the frontmatter and append activity entries to the Notes section.
- If `gh` CLI is not authenticated or fails on the bulk fetch, report the error clearly and stop. (The `user/repos` endpoint requires an authenticated token with `repo` scope to see private repos — if private repos are missing, check `gh auth status` scopes.)
- If an individual collaborator repo fetch fails, log a warning and continue with the rest.
