---
name: create-verify-skill
description: Generates and proves a project-local .claude/skills/verify-<app>/ that launches the real app, drives it like a user and captures evidence. Also refreshes an existing one. Invoke with /create-verify-skill.
disable-model-invocation: true
---

<!-- Adapted from pstack `create-verification-skill` and `maintain-verification-skill` (MIT, (c) 2026 Lauren Tan). See THIRD_PARTY_NOTICES.md. -->

# Create a verify skill

Every project needs a scripted way to drive the real app the way a user does and capture proof. This skill writes that as `.claude/skills/verify-<app>/` in the repo. The reader is the next agent, mid-task, who has never seen the app.

If `.claude/skills/verify-*/` already exists, go to **Refresh** below.

## 1. Interview the repo, not the user

Answer from the code; ask the user only what you can't observe. If you can't ask (headless or subagent), take the safe default and record the choice.
- **Surface:** what a user touches: web UI, CLI/TUI, API, mobile, library. Pick the main one, note the rest.
- **Run:** the repo's own dev command (package scripts, Makefile, README). Ports, env vars, seed data, auth.
- **Drive:** existing harnesses first (Playwright/Cypress specs, test clients, curl-able endpoints). Then generic: gstack's headless browser (`~/.claude/skills/gstack/browse/dist/browse`, as `$B`) for web, tmux for CLI/TUI, curl for HTTP.
- **Observe:** screenshots, transcripts, response bodies, logs, exit codes, DB rows.
- **Isolate:** can a second instance run beside the user's? Isolate data as well as ports: throwaway stacks get their own project, volume or database names, and cleanup must refuse unless those names match what launch created. If isolation isn't possible, the skill must refuse to drive a shared instance.
- **Side effects of running:** some tools write tracked files on startup (e.g. `next dev` adds agent rules to AGENTS.md/CLAUDE.md when it detects an agent). Find these and neutralise them in the helper.

If the app doesn't build or start as-is, fix it only when the fix touches no tracked files or the user agrees; otherwise report it precisely and record it under Gotchas. A skill written against a broken base teaches wrong steps.

## 2. Write the skill

`.claude/skills/verify-<app>/SKILL.md`, with frontmatter (`name: verify-<app>`, and a `description` naming the app, the surface and when to use it). Sections, all with real commands from this repo and no placeholders:
- **Launch:** exact start command, how to tell it's *usable* (not just that a port answers), teardown. Must work from an empty data dir, including migrations and seed data. Default to $0 mode for paid external APIs (use fakes the code already has); real calls are opt-in, and the skill says what they need. Name env vars, never print their values.
- **Doctor:** one read-only check: process up, right build, port is ours, auth working (for browser sessions, how to check the cookie in the driver), tracked files unchanged. Run it first and after anything surprising.
- **Drive:** the harness recipe with this repo's real selectors, routes or prompts. Prefer stable handles (ARIA labels, data attributes, route paths) over coordinates.
- **Evidence:** what to capture and where it goes (a named directory outside anything cleanup deletes, and one the driver can write to: gstack's browser only writes under /tmp, $TMPDIR or the repo, so ship a helper that moves files in). Proof standards: use the real user path, not test-only endpoints or internal setters; capture the action and the resulting state; check side effects (files, rows, messages) as well as the screen; mock only at boundaries production already isolates. Check what a "dry run" or fake mode really skips by observing it, or list it as not verified if the proof run didn't reach it.
- **Cleanup:** stop only what you started (by PID or port you recorded, never by process name). Never delete evidence. Say what launch adds to the machine for good (docker images, caches, browser daemons) and whether cleanup removes it.
- **Helpers:** any script you ship is executable and its invocation is shown in the body.

## 3. Seed the feature map

`.claude/skills/verify-<app>/features/README.md` (index) plus one file for each of the top 3-5 user-facing features. Each file has four sections: `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, `Gotchas`. Mark each feature in the index as driven (date, evidence path) or "not yet driven". If seed data lacks something a journey needs, record the failure and reason under Gotchas. Never weaken the journey to make it pass.

## 4. Prove it

Run the generated skill end to end once: launch, doctor, drive ONE mapped feature, capture evidence, clean up. Then confirm the evidence still exists and that `git status` shows nothing changed outside the skill directory. Fix whatever fails, running cleanup after each failed attempt. A verify skill that was never run is a draft. Report what you ran and where the evidence is.

## Refresh

For an existing verify skill, after the app has changed:
1. Fix the feature index: missing, dead or duplicate entries. Check recent commits for user-facing changes the map doesn't cover (cite the source path).
2. Run doctor, then drive every feature once, serially, doctoring again after any failure.
3. Sort each problem: wrong description → fix the map; working behaviour the harness can't drive → fix the harness and re-drive it; app actually broken → report to the user, don't paper over it in the docs.
4. Only edit files inside the verify skill's directory. Report: features covered, what changed, anything unreachable and why.
