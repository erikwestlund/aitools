# Session Plan - March 12, 2026

## Goal

Use the second half of class to shift from "AI for statistical tasks" toward "how to build a durable working style around text-based tools." The emphasis is practical craftsmanship: avoiding friction, preserving context, and making day-to-day work easier to recover, inspect, and improve.

## Working Outline

### 1. Project presentations (about 40 minutes)

- Have students present progress, goals, blockers, and what they are trying next.
- As they present, note recurring workflow pain points: losing context, messy files, repeated setup, confusion about what changed, or uncertainty about how to resume work.
- Use those pain points as bridges into the second half.

### 2. Open questions and discussion (10-15 minutes)

Suggested prompts:

- What has been most annoying so far in your project workflow?
- Where do you lose time: setup, debugging, file organization, Git, terminals, or documenting decisions?
- What parts of your process feel fragile or hard to resume after a break?

## 3. Workflow / craftsmanship segment (25-30 minutes)

### Framing

Core message: good workflow is mostly about reducing paper cuts.

- Make it easy to restart work.
- Make it easy to see what changed.
- Make it easy to recover from mistakes.
- Make it easy to leave a trail for your future self.

### Suggested teaching sequence

1. **`.gitignore` first**
   - Frame it as basic hygiene.
   - Prevent accidental commits of data, secrets, logs, and generated junk.
   - Explain that it also reduces noise for AI agents and for humans searching a repo.
   - Stress that `.gitignore` helps with cleanliness, not real access control.

2. **`tmux` next**
   - Frame it as protection against interruptions.
   - Explain sessions, windows, and panes in plain language.
   - Emphasize persistence: laptop closes, SSH disconnects, work stays alive.
   - Connect it directly to paper cuts: not having to rebuild your terminal layout every day.

3. **Aliases and launcher habits**
   - Show how short commands remove recurring annoyance.
   - Use the pattern from Part 3: project launcher alias plus attach/kill helpers.
   - Position aliases as low effort, high leverage.
   - If helpful, frame them as "tiny ergonomic investments."

4. **Text-based workflow habits**
   - Keep a `docs/` or `notes/` folder for plans, prompts, decision logs, and intermediate findings.
   - Use checkpoints: commit after meaningful steps.
   - Keep logs and short notes so you can resume without reconstructing your thinking.
   - Ask tools/agents to explain what they are doing so confusion does not compound.

5. **Wrap-up principle**
   - The point is not to become a shell maximalist.
   - The point is to create a workflow that is persistent, inspectable, recoverable, and less annoying.

## Instructor Notes

- Keep this section concrete rather than tool-worshipping.
- Avoid statistical examples unless a student asks for one.
- Tie every tip back to one of three benefits: less friction, better recovery, better visibility.
- If discussion is lively, prioritize `tmux`, `.gitignore`, and checkpoints over broader tooling.

## Optional live demo ideas

- Show a small `.gitignore` and explain each line.
- Show a `tmux` session surviving a disconnected terminal.
- Show a tiny alias pattern like `tmcourse`, `tma course`, `tmk course`.
- Show a repo with `docs/` notes and a short commit history used as checkpoints.

## Closing message

The craftsmanship lesson is that a lot of effective work is not brilliance. It is arranging your environment so that mistakes are cheaper, restarts are easier, and useful context does not disappear.
