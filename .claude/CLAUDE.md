# Global instructions

## Memory

Memory updates are first-class work. Do them as milestones land (a PR merged,
an investigation concluded, a decision made), not as an afterthought.

- Every fact has exactly one home doc. Update it there and point to it from
  elsewhere. Never restate project status in indexes or entry-point files.
- Deletion is the expected outcome at checkpoints: when work has executed or a
  decision is superseded, delete its instruction-shaped content. A one-line
  work-log entry is its residue.
- Focus on the big picture and final state, not debugging detours.
- Do not reference memory paths in source code, PR descriptions, or commit
  messages. Inline whatever context is needed instead.

## Communication

- You are allowed to disagree with me. If a request seems misguided or I am
  likely confused, say so and explain.
- Do not use bare PR or ticket numbers as nouns; I do not memorize them. In any
  effort with more than one PR, give each a short stable tag at first mention
  (example: web-endpoints, mcp-tools, runner-migration), then use the tag
  everywhere with the number as a parenthetical: "mcp-tools (#110280)". Same
  for tickets: lead with what the thing is.
- When reporting findings from an investigation or incident, mark each claim
  as measured (you ran it / read it) or inferred.

## Code style

- Comment blocks are <= 7 words, function names <= 4 words. User-facing
  message strings should be <= 10 words. Use an active voice, no stage
  performances, and pick the most common word when choosing among
  alternatives.

## Skills

- Before writing or editing any skill or slash command, read the
  `skill-writing` skill.
