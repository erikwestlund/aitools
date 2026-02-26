# Case Study: Using AI to Build This Course Schedule

This document is itself a product of AI-assisted work. The course schedule for *AI Tools for Data Science and Statistics* was drafted collaboratively between the instructor and Claude (Anthropic's LLM), using Claude Code — a command-line agent that can read files, explore project structures, and work within the context of an entire project.

This case study is intended to serve two purposes:

1. **A teaching example** for the first class session, demonstrating what AI-assisted work looks like in practice.
2. **A discussion prompt** about when AI use is appropriate, what kinds of tasks it's well-suited for, and where the ethical lines are.

---

## What the Instructor Did

### 1. Set Up a Project with Structure

Before ever prompting the AI, the instructor created a project directory with organized inputs:

```
ai-tools-for-data-science-and-statistics/
├── CLAUDE.md                  # Instructions for the AI about project conventions
├── docs/
│   ├── course-background.md   # Course description, timeline, topic list
│   ├── surveys/
│   │   ├── initial-survey.md  # The prompt sent to students
│   │   ├── response-1.md      # Individual student survey responses
│   │   ├── response-2.md
│   │   ├── ...
│   │   └── response-8.md
│   └── misc/
│       └── data-visualization-syllabus.pdf  # Example syllabus from another course
```

This is a key lesson: **the quality of AI output depends heavily on the quality of context you provide.** The instructor didn't just ask "make me a syllabus." He organized relevant materials into a structured project so the AI could read and synthesize them.

### 2. Gave the AI Access to All Inputs

The instructor pointed Claude Code at the following materials:

- **Course background** (`docs/course-background.md`): A description of the course including the format (4 sessions, 80 minutes each, online, pass/fail), the intended vibe ("exploratory, low stakes, should be useful and fun"), and a comprehensive list of topics to potentially cover.

- **Student survey responses** (`docs/surveys/response-*.md`): Eight individual responses to a pre-course survey asking about operating systems, command-line comfort, current AI tool usage, subscriptions, use cases, goals, and concerns.

- **The survey prompt itself** (`docs/surveys/initial-survey.md`): The email sent to students, which provides context about the instructor's background and approach.

- **An example syllabus** (`docs/misc/data-visualization-syllabus.pdf`): A syllabus from another course the instructor teaches, providing a reference for format, structure, and tone.

### 3. Wrote a Prompt

The instructor's prompt, lightly edited for clarity:

> Read the course surveys and the prompt for that survey. Then consider the length of the course, the topics I suggested, the goals of students, and their perceived level.
>
> Note that these are a mixture of PhD (mostly PhD) and ScM students at Johns Hopkins Public Health Biostatistics. This is a top-tier department with very sharp students, but their computational skills are not typically as good as their math/stats, if that makes sense.
>
> This is a pilot of the course. I want it to be hands-on.
>
> Study these materials, and let's work out a rough schedule for the class.

Notice what this prompt does well:

- **Provides expert context** the AI can't infer from the documents alone (the computational vs. mathematical skill gap, that this is a pilot)
- **States a clear deliverable** (a rough schedule)
- **Sets constraints** (hands-on)
- **Invites collaboration** ("let's work out") rather than demanding a final product

### 4. Reviewed, Iterated, and Made Decisions

The AI produced a student profile summary and a 4-session schedule. The instructor reviewed this output and made the editorial decision that it was a good starting point. In a real workflow, this would typically involve multiple rounds of revision — adjusting emphasis, reordering topics, adding or cutting material based on the instructor's judgment and experience.

**The instructor remains the decision-maker.** The AI synthesized inputs and proposed a structure. The instructor evaluated whether that structure actually makes sense for these students in this context.

---

## What the AI Produced

### Student Profile Summary

The AI read all 8 survey responses and synthesized a profile:

| Dimension | Summary |
|---|---|
| **OS** | 7 Mac, 1 Windows (one also uses Linux HPC) |
| **CLI comfort** | Range 3-8.5, median ~5.5 |
| **Current AI use** | Almost everyone uses chat windows only (browser). ChatGPT most common. Only 1-2 use IDE integration. |
| **Subscriptions** | Most don't pay. 2-3 have subscriptions. |
| **Use cases** | Debugging code, lit review, explaining concepts, light writing help |
| **Disposition** | Several explicitly describe themselves as skeptical but curious |

**Top student goals identified:**

1. Move beyond copy-paste chat into real workflow integration
2. Understand ethical boundaries and responsible use
3. Learn what tools exist and how to pick between them
4. AI for code quality: debugging, testing, reproducibility, figures
5. Privacy, reproducibility, environmental concerns
6. Find their personal "line" — what to use AI for and what not to

**Key takeaway:** These students are almost all chat-window-only users with moderate CLI skills. The biggest value-add is moving them from "paste code into browser, paste answer back" to integrated, thoughtful workflows — while honoring their healthy skepticism.

### Proposed Schedule

#### Session 1: What Are These Things, and How Do You Talk to Them?

*Foundations, mental models, and getting good results*

| Block | Min | Content |
|---|---|---|
| Lecture | 20 | What is an LLM? (conceptual — tokens, context windows, temperature, stochasticity). Why the same prompt gives different answers. Model landscape: GPT, Claude, Gemini, DeepSeek — differences vs. marketing. |
| Lecture + demo | 15 | **Context is everything.** Structuring prompts for statistical work. System prompts, project context files, "loading" an LLM with your project. Bad prompt vs. good prompt live demo. |
| Discussion | 10 | Tools & subscriptions landscape: chat windows, API keys, IDE plugins, CLI agents. Free vs. paid. Cost awareness. |
| Hands-on | 30 | **Structured exercise:** Everyone gets the same statistical task (e.g., write R code to clean a dataset and produce a summary table). Use your own tool. Compare results across tools. What worked? What hallucinated? |
| Wrap-up | 5 | Introduce moonshot assignment. Privacy & data safety teaser: what NOT to paste into a chat window. |

**Homework:** Brainstorm your moonshot task. Try a second AI tool for a small task; note differences.

#### Session 2: AI-Assisted Coding — Beyond Copy-Paste

*Integrating AI into your actual R/stats workflow*

| Block | Min | Content |
|---|---|---|
| Discussion | 10 | Debrief: what happened when you tried a new tool? Surprises? |
| Lecture + demo | 20 | **Leveling up from chat.** IDE integration (CoPilot in RStudio, Cursor, VS Code). Live demo of inline suggestions. Brief intro to CLI agents (Claude Code). |
| Lecture + demo | 15 | **AI for the stats pipeline.** Data cleaning, codebooks, EDA, visualization. Live demo: messy data to clean code to validated output. Emphasis: you must check the work. |
| Hands-on | 30 | **Paired exercise:** Messy dataset. Use AI to write cleaning code, produce summary stats, generate a ggplot. Then manually audit — did it make correct choices? Catch at least one mistake. |
| Wrap-up | 5 | Git/GitHub teaser. Moonshot check-in. |

**Homework:** Make moonshot progress. Get Git set up if needed.

#### Session 3: Power Tools — Agents, Git, and the Full Workflow

*Professional tooling and AI for serious statistical work*

| Block | Min | Content |
|---|---|---|
| Lecture + demo | 20 | **Git & GitHub essentials.** Why version control matters more with AI. Demo: init, add, commit, push, diff. AI-assisted commit messages and PRs. |
| Lecture + demo | 15 | **CLI agents and agentic workflows.** Demo: give an agent a task, watch it work, review results. When agents help vs. go off the rails. tmux, Model Context Protocol (brief). |
| Lecture | 10 | **AI for statistical thinking.** DAGs and CI assumptions. Simulating data. Model validation. Lit review tools. Where AI is a genuine thought partner — and where it confidently misleads. |
| Hands-on | 30 | **Moonshot work session.** Students work on projects with instructor support. Structured check-ins. |
| Wrap-up | 5 | Ask students to prepare a 3-minute informal moonshot share. |

**Homework:** Finish moonshot attempt. Prepare to share (3 min, informal, no slides needed).

#### Session 4: Ethics, Reproducibility, and Finding Your Line

*Responsible use, synthesis, and where we go from here*

| Block | Min | Content |
|---|---|---|
| Lecture | 15 | **AI ethics and responsible use.** Privacy, reproducibility, environmental cost, academic integrity, bias, confabulation. |
| Discussion | 10 | **Where do you draw the line?** Scenarios: clearly fine, clearly problematic, genuinely ambiguous. |
| Moonshot share | 35 | **Lightning rounds.** ~3 min per student: what they attempted, what worked, what failed. Class discussion after each. |
| Lecture | 10 | **Going forward.** Project organization, documenting workflows, cost management, picking models, staying current. |
| Wrap-up | 10 | Retrospective and feedback for the pilot. |

### Design Rationale

- **Progressive skill ladder:** Chat window (where they are) to IDE integration to CLI agents to full workflow.
- **Skepticism-friendly:** Every session includes validation and auditing. The moonshot finds limits, not just successes.
- **Hands-on heavy:** ~30 min of active work per session (37% of class time), plus homework.
- **Realistic scoping:** 320 total minutes is tight. Some topics (deep MCP coverage, API key management) are cut in favor of what students said they want most.
- **Moonshot as throughline:** Introduced session 1, worked on session 3, presented session 4.

---

## Discussion: Is This an Ethical Use of AI?

This is where things get interesting — and where we want your honest reactions.

### What the AI did here

- Read and synthesized 8 student surveys into a summary profile
- Cross-referenced student goals against a topic list and course constraints
- Proposed a structured schedule with time allocations
- Identified design tradeoffs (what to cut, what to emphasize)

### What the instructor did

- Collected all the raw inputs and organized them
- Provided expert context the AI couldn't know (student population characteristics, departmental culture, pedagogical goals)
- Evaluated the output against his own teaching experience
- Made the final decisions about what to keep, change, or discard

### Questions to consider

**About this specific use case:**

- Is using AI to synthesize survey responses and draft a schedule ethically different from using it to, say, write a research paper? Why or why not?
- The instructor organized inputs, provided expert context, and reviewed the output. Does that level of involvement matter for whether this is "his work"?
- Would your answer change if the instructor had simply typed "make me a 4-week syllabus for an AI tools course" with no context?

**About different types of work:**

- **Programming:** Most people are comfortable using AI to help write code. Why? Is it because code is verifiable — you can run it and see if it works?
- **Statistics:** If you ask an AI to suggest a modeling strategy or check your DAG assumptions, how would you verify correctness? Is this more or less risky than asking it to write a for-loop?
- **Writing:** Several of you said you don't like using AI to write. What makes writing feel different? Is it about authenticity, quality, learning, or something else?
- **Research synthesis:** The AI summarized 8 surveys here. Is that different from summarizing 80 research papers for a literature review? Where does "helpful synthesis" become "I didn't actually engage with the material"?

**About transparency:**

- Does it matter that this document openly describes the process? Would you feel differently if the instructor had presented the schedule without mentioning AI involvement?
- What level of disclosure is appropriate for AI-assisted academic work?

**About learning:**

- One of the deepest concerns in the surveys was the fear of missing learning opportunities. When does AI assistance help you learn more (by removing tedious barriers) vs. less (by doing the thinking for you)?
- The instructor has 15+ years of teaching experience. Does expertise change the ethics? Is an experienced teacher using AI to draft a schedule different from a first-year teacher doing the same?

---

## Tips Demonstrated in This Example

Whether or not you agree that this was an appropriate use of AI, the *process* demonstrates several practical techniques:

1. **Structure your project before prompting.** The instructor didn't dump everything into one message. He organized files into a logical directory structure that the AI could navigate.

2. **Provide context the AI can't infer.** The prompt included information about the student population and departmental culture that wasn't in any file.

3. **Give the AI real data to work with.** Actual survey responses, not a summary of them. Let the AI do the synthesis — that's what it's good at.

4. **Use a reference example.** The example syllabus from another course gave the AI a sense of format and expectations without the instructor having to describe them.

5. **Treat it as a draft, not a deliverable.** The output is a starting point for the instructor's judgment, not a finished product.

6. **Ask for collaboration, not perfection.** "Let's work out a rough schedule" invites iteration. "Write me a perfect syllabus" sets up failure.
