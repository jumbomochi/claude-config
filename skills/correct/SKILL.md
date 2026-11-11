---
name: correct
description: For when agents keep making the same mistake in a repo. Finds repeated mistake classes and makes each one impossible (structure, then types or lint, then tests, docs last), proving each new check fails on a real past mistake.
disable-model-invocation: true
---

<!-- Adapted from pstack `correct` (MIT, (c) 2026 Lauren Tan) and Matt Pocock's `retro` idea (MIT, (c) 2026 Matt Pocock). See THIRD_PARTY_NOTICES.md. -->

# Correct

The user keeps correcting agents in this repo for the same mistakes. Change the repo so the next agent can't make them.

Assume every contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. A change that looks right from one file should be right for the whole repo.

## 1. Find the mistake classes

Read, in this order, and note evidence for each mistake (commit hash, file:line, quote):
- the correction the user just made, if any
- recent commits, reverts and fixup commits (`git log --oneline -50`, `git log --grep=revert -i`)
- PR review comments if `gh` is available
- CLAUDE.md / AGENTS.md and comments that explain a workaround

Group them into classes. A class counts once it has happened twice. Show the list to the user before fixing.

## 2. Fix each class at the highest level that works

1. **Structure.** One owner per piece of state, one supported way per task. Hide internals so the wrong import fails. Replace hand-synced lists with one source. Delete the old way and dead code an agent would copy.
2. **Types, lint or CI.** Make the bad state fail to compile. Otherwise add a lint or CI check whose error message names the file, type or function to use instead. If the pattern is already common, fail only on new occurrences.
3. **Tests.** Test the behaviour. Fix or delete any test that still passes when its behaviour breaks.
4. **Written rule.** Only for judgment calls. Nothing fails when an agent skips it, so it is the weakest level.

## 3. Prove each check

For each new check, show it failing on a real past mistake (check out the old commit, or reapply the bad change in a scratch branch) and passing on the fix. A check that has never failed is not proven. Run it the same way locally and in CI. Allowed exceptions sit on the offending line with a reason.

One commit per class. Do not commit until the user has seen the proof.

## 4. Keep the rule table

Keep a table in the repo's CLAUDE.md: rule → what enforces it (structure / type / lint / test / doc only). When a "doc only" rule is broken again, that is a repeat: move it up a level in the same change. Remove a rule once its mistake can no longer happen.

**Reply:** each class with its evidence, the level chosen, why a higher level didn't work, and the proof output.
