---
name: skill-writing
description: Read BEFORE writing or editing any skill or slash command (SKILL.md in ~/.claude/skills, project .claude/skills, ~/.claude/commands, project .claude/commands). Encodes Nishant's standing rules on how skills must be written.
---

# Writing skills

- Main thing: do not over-prescribe. There is a tendency to explain the entirety
  of a process. Realize that it will be YOU who reads these skills. Add just
  enough guidance to steer; do not list every little thing. Trust the reader's
  intelligence.
- Corollary: keep everything as terse as possible. Skills pollute context and
  have a butterfly effect. Fewer tokens is better.
- Explain the why, not just the what. A reader who knows the intent can derive
  the steps; a reader with only steps breaks on the first case you did not
  anticipate.
- The `description` frontmatter is the trigger surface, not a summary. Write it
  for the moment of deciding whether to load the skill: concrete trigger
  phrases, and what it is NOT for when misfires are likely.
- Skills that only make sense as an explicit user action (slash-command style)
  get `disable-model-invocation: true` in frontmatter.
- No H1 restating the skill name; frontmatter already carries it. Start with
  the point.
- Cut "in case the user also wants X" contingency lines; the reader can derive the
  same pattern.
- When Nishant hand-edits a skill you wrote, generalize the lesson and append
  it here as a bullet, not the concrete diff.
