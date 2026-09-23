---
name: pr-walkthrough
description: Guided review of a PR or diff as narrated cards, paced by the user. Trigger on "walk me through this PR/diff", "guided review", "/pr-walkthrough". NOT for autonomous review (code-review), or when the user just wants a summary of the diff.
---

Walk Nishant through a diff as a card deck. Follow the `stepwise-explainer`
skill for the mechanic (arc, one reused artifact, ack pacing); this skill only
says what the cards are.

- Diff source: whatever the session is about (local `git diff`, `gh pr diff`,
  a pasted patch).
- Card 1: overview. All the pieces and how they hang together.
- Then deep dives in dependency order: schema/data model -> core logic -> call
  sites, with tests right after the feature they test. Real code samples
  welcome; simplifying a sample to its important parts is encouraged when that
  reads better. Mark simplified samples as such.
- Nishant drops comments in chat between cards. Act on them as they come (fix,
  answer, push back); do not queue them for the end.
- Last card: "not covered". Every file/hunk that got no card, so nothing is
  skipped silently. Empty is the goal; anything listed gets looked at raw.
