---
name: stress-test
description: Adversarial review of a change or design. Three subagents in worktrees try to break it; only findings proven by a rerun command survive. Reports, never fixes. Invoke with /stress-test.
disable-model-invocation: true
---

<!-- Adapted from pstack `interrogate` and `blast-radius` (MIT, (c) 2026 Lauren Tan). See THIRD_PARTY_NOTICES.md. -->

# Stress test

Adversaries try to break a change. A finding survives only when a command, rerun by you, shows the failure. Report findings. Do not fix anything.

## 1. Frame

- **Scope:** what the user names. Otherwise the branch diff from its merge base with the default branch, plus uncommitted changes.
- **Intent:** one paragraph in your own words, from the user's message, commit messages and PR description. If the intent is unclear, ask before going on: a finding is only a failure relative to the intent.
- **The one fact:** most risky-looking changes are safe because of a single fact ("this call only touches entries that are already expired"). Name it. The adversaries will attack it.

## 2. Fan out

Save uncommitted work so the adversaries see it: `git diff HEAD > <scratchpad>/scope.patch`.

Spawn 3 adversary subagents in parallel, each with `isolation: "worktree"`, each told to `git apply` the patch first. Give each a different angle:

1. **Inputs and edge cases:** empty, huge, malformed, unicode, boundary values, wrong types at the edges of the system.
2. **State and timing:** ordering, retries, concurrency, partial failure, caches, teardown, what happens on the second run.
3. **Beyond the diff:** callers, serialized formats, DB columns, config and feature flags, other code reading the same data, library behaviour at the pinned version. Read the library source, not its docs.

Brief each one with the scope, the intent, the one fact, and this:

> Break this change. Prove each finding with a run against the real code: a failing test, a repro script, or command output showing the wrong behaviour. For a design or plan, probe the current tree or run a throwaway prototype. Report each finding as: title, exact command, the output it printed, and the output the intent requires. Leave out anything you did not run, including style, naming and risks that need some future change to matter. No findings is a valid result.

**Outside voice (optional, ask first):** a different model catches different bugs. For a personal repo: `agy -p "<brief + diff>" --model gemini-4-argon-high --mode plan`. For a company repo: gstack `/codex`. Their findings are unrun, so treat them as leads: you must reproduce each one yourself before it counts.

## 3. Verify

Rerun every finding's command yourself, in the adversary's worktree. Keep it only if the output shows the failure and the failure breaks the intent. Merge findings with the same root cause. Drop the rest.

For the one fact, say how far it got:
1. claimed, 2. pointed at `file:line`, 3. failure path walked and shown unreachable, 4. a script ran the real code, 5. reproduced in the running app.

## 4. Report

- **Intent:** the restatement.
- **The one fact:** stated, its level (1-5), and the proof, or "unproven".
- **Findings:** for each, the command, its output, how it breaks the intent, and which adversary found it. Or "no verified findings".
- **Dropped:** per adversary, how many findings were dropped and why.
- **Before you merge:** the cheapest test that would catch the worst finding.

Then remove the worktrees the adversaries created unless the user wants to inspect them.
