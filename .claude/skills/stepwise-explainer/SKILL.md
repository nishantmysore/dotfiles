---
name: stepwise-explainer
description: Step through anything with Nishant one small visual card at a time, paced by your acks. Owns the deck mechanic only; the caller (another skill like pr-walkthrough, or the conversation) decides what the cards contain. Trigger on "walk me through it step by step", "one card at a time", "/stepwise-explainer". Bare invocations default to teaching a system or design.
disable-model-invocation: true
---

Why this works when a finished explainer does not: the sequencing and pacing
live in the conversation, so each visual only has to carry ONE idea, and Nishant
controls depth by acking or asking. The cards orient; the chat teaches.

This skill is the mechanic only. What the cards contain is the caller's
business (teaching a design, walking a PR diff, ...); invoked bare, default to
teaching.

- Plan the arc first (5-8 beats), tell Nishant the list, then one card per beat.
  Advance only on ack.
- Cards: single-file HTML in the scratchpad dir, ~100 lines, plain SVG/CSS, no
  libraries. One idea, big text, consistent styling, "N of M" kicker (e.g.
  "Lesson 3 of 7"). Show each card by publishing it as an Artifact, reusing the
  same file path so the deck stays at one URL and each card replaces the last.
  If Artifacts are unavailable, fall back to SendUserFile with display=render.
- Narration in chat: a few plain sentences per card. If jargon slips and Nishant
  asks, translate and re-teach; that is signal, not failure.
- Detours are the best part. Answer follow-ups fully, add bonus cards (2b, 4b),
  spawn research subagents for questions nobody in the chat can answer, and fold
  what emerges into memory as you go.
- Keep verified vs inferred marked. Nishant will carry these claims into meetings.
