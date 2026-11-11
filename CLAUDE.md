# gstack

Use the /browse skill from gstack for all web browsing. Never use mcp__claude-in-chrome__* tools.

Available gstack skills: /office-hours, /plan-ceo-review, /plan-eng-review, /plan-design-review, /design-consultation, /design-shotgun, /design-html, /review, /ship, /land-and-deploy, /canary, /benchmark, /browse, /connect-chrome, /qa, /qa-only, /design-review, /setup-browser-cookies, /setup-deploy, /setup-gbrain, /retro, /investigate, /document-release, /document-generate, /codex, /cso, /autoplan, /plan-devex-review, /devex-review, /careful, /freeze, /guard, /unfreeze, /gstack-upgrade, /learn

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

## Investigations and claims

When explaining how something works, debugging, or making claims about code, tools or systems:
- First list the questions to answer and the evidence each one needs.
- Label each conclusion: observed (I ran or read it), inferred, or unknown. Cite the evidence (file:line, command output, URL).
- For multi-step work, keep a short findings list: conclusion → evidence → confidence.
- Before finishing, go back to the question list and mark each one answered, partial, or unresolved. Don't call it done while one is open; say what is still unknown.
- A search that finds nothing only rules out the scope searched. Say what was searched.
Skip this for small edits and quick lookups.

## Debugging

These apply whichever debugging skill is running, and take precedence over its own steps.
- No theory about the cause until you have one command, already run, that reproduces the user's exact symptom (a test, curl, CLI call or browser script). Show the command and its output. Make it fast and deterministic before going further. If you can't build one, stop and say what you tried and what you need.
- If the repro doesn't make the cause obvious, list 3-5 ranked hypotheses, each with a prediction that would prove it wrong, before testing any of them. Don't stack a second fix on a failed one; go back to the list.

## Review findings

- In any code review, report something as a bug only when you ran a command that shows it fails, or can point to the exact `file:line` and walk the failing path. Everything else goes under "Suspected", with the check that would confirm it.
- For a risky change, suggest /stress-test (adversarial review where only rerun failures count).

## Repeated mistakes

When the user corrects a mistake that has already happened once before, fix it, then propose the strongest guard that works: change the structure so it can't happen, else a type or lint error that names the right fix, else a test, and a written rule only as the last resort. /correct does this across a whole repo.
