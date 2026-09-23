---
name: two-lens-review
description: Autonomous two-subagent code review of a PR or pending change. One fresh-context functionality lens (bugs, removed behavior, cross-file tracing, purpose), one code-quality lens (reuse, simplification, efficiency, altitude). Verified findings only, then one fixup round. Trigger on "two-lens review", "review this before I mark it ready", or whenever a background job needs to self-check a diff it wrote. NOT a substitute for /code-review ultra (Nishant fires that), and NOT for guided review (pr-walkthrough).
---

Never review your own diff in your own context: you wrote it, you will defend
it. Spawn two general-purpose subagents in parallel with fresh context. Each
gets the diff location, the change's stated intent, and nothing of your
reasoning. Write the prompts neutrally: no "I already checked X", no hints
about which parts you are confident in.

## Common spine, in both prompts

- READ-ONLY. No file edits, no git or gh writes, no installs. Findings go up;
  the author applies fixes.
- You did not write this change; try to break it.
- Get the diff (`gh pr diff <n>`, or for unpushed work `git diff <base>...HEAD`
  plus `git diff` for the working tree) and read enough surrounding code at
  the branch to VERIFY each candidate before reporting. Unverified hunches
  stay out or are marked unconfirmed.
- An empty findings list is a valid, good outcome.
- Never comment on the PR; return findings only.
- Not findings: style nits, anything a linter or typecheck catches,
  pre-existing issues on untouched lines, restating the PR description.
- Return `{file, line, summary, lens, severity: major|minor, confirmed: bool}`
  per finding plus a one-line verdict on the change overall.

## Functionality lens, in order

- (a) line-by-line scan of the diff for bugs;
- (b) removed or changed behavior something else may depend on;
- (c) cross-file tracing of every symbol the diff touches;
- (d) purpose: given the stated intent, would it survive the scenario that
  motivated it?

`confirmed=true` only when the agent can state the concrete inputs or state
that produce wrong behavior.

## Quality lens, in order

- (a) reuse: does the diff duplicate a helper, fixture, or pattern that already
  exists nearby (go look);
- (b) simplification: is there a plainly simpler shape for the same behavior;
- (c) efficiency: wasted work only if it plausibly matters here;
- (d) altitude: is the change at the right layer, per surrounding conventions
  and any CLAUDE.md or AGENTS.md rules scoped to these paths.

`confirmed=true` only when the better alternative concretely exists (the agent
found the helper, or can sketch the simpler shape).

## Fixup round

Exactly one. Fix confirmed-major findings; confirmed-minor at your judgment
(cheap: fix, otherwise carry into the report); unconfirmed findings are
reported, not acted on. Re-run static checks after fixes. Do not loop; a
second full pass is Nishant's call.

## Escalation

When the diff is meaty (wide blast radius, subtle semantics, wire or protocol
changes, framework rewrites), name it in the report as a candidate for
`/code-review ultra`, which only Nishant can fire. Do not block dependent work
on it; keep going and fold findings in when they arrive.
