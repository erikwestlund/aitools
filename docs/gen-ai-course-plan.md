# Generative AI Course Plan

## Session Title

**Safe, Reproducible AI Workflows for Public Health Data Science**

## Core Teaching Goal

Students should leave with a practical framework for using generative AI tools in public health data science safely and effectively. The emphasis should be on hands-on workflow, data safety, reproducibility, and good judgment rather than tool hype.

## Core Message

Code can move across environments; sensitive data cannot.

Students should learn to:

- work locally on synthetic or public data
- use Git and GitHub to move code across environments
- understand the difference between chat workflows and agent workflows
- use simulation as a safe development strategy when real data are restricted
- verify outputs before trusting them

## Audience and Constraints

- one-off session
- 2.5 hours
- about 50 students
- public health audience
- many students likely have mixed technical backgrounds
- main platform is a Windows secure enclave with RStudio
- hands-on work needs to be simple, robust, and well scaffolded

## Proposed Session Structure

The overall structure should be:

1. short lecture
2. live demo
3. student activity

Repeat this cycle three times.

This keeps the session aligned with the course philosophy in this repo:

- practical
- demo-heavy
- safety-first
- reproducibility-focused
- useful for real workflows

## Detailed Agenda

### 0. Opening and framing (10 minutes)

Goals:

- explain what the session is about
- set the safety and workflow frame
- clarify what students should be able to do by the end

Key points:

- AI tools are useful, but not trustworthy by default
- public health work raises special concerns around privacy, safety, and validity
- the session is about building workable habits, not just trying flashy tools
- code-not-data is the main operating principle

Opening talking points:

- what data can flow into models
- what outputs come back out
- where risks appear
- why reproducibility matters
- why Git matters in restricted workflows

### Cycle 1. Data safety, boundaries, and Git workflow

#### Mini-lecture (20 minutes)

Topics:

- general issues in AI for public health and biostatistics
- what flows into models:
  - prompts
  - pasted code
  - file contents
  - metadata
  - screenshots and copied outputs
- what flows out of models:
  - code
  - prose
  - plots
  - summaries
  - claims
  - possible errors
- basic data safety rules:
  - no PHI in external tools
  - minimum necessary context
  - synthetic/public data only for external tool demos
  - verify before trust

Transition:

- Git is the mechanism that lets code move safely while data stay protected

#### Demo (8 to 10 minutes)

Show:

- create a toy repository
- add a file
- `git init`
- `git add`
- `git commit`
- create remote GitHub repo
- `git push`
- make one change remotely or from another copy
- `git pull`

Narrate the secure workflow:

1. work locally
2. commit code
3. push to GitHub
4. pull into the secure enclave
5. run on restricted data there

#### Activity 1 (15 to 20 minutes)

Students should:

- register GitHub accounts if needed
- create a toy repo
- add one file
- commit
- push
- pull a change

Target outcome:

- every student completes one full local-to-remote workflow

#### Debrief (2 to 5 minutes)

Key message:

- Git is part of the safety and reproducibility infrastructure

### Cycle 2. Chatbot vs agent workflows

#### Mini-lecture (20 minutes)

Topics:

- chat interfaces vs agents
- agent harness concept:
  - model + tools + permissions + context + workflow
- why this matters for statistical work:
  - auditability
  - iteration
  - context awareness
  - reproducibility
- risks:
  - more access can mean more exposure
  - agents are not automatically safer or more correct
  - all outputs still require verification

Tie back to course philosophy:

- use tools pragmatically
- do not confuse capability with reliability

#### Demo (8 to 10 minutes)

Show the same small task twice:

- once in a chatbot
- once in an agent

Compare:

- what the chat tool does quickly
- what the agent does better
- where each can go wrong
- what would be unsafe with real data

Potential example:

- simple EDA or plotting task on a synthetic public-health style dataset

#### Activity 2 (15 to 20 minutes)

Students should:

- run a small task in a chat or agent tool
- record:
  - what context they gave
  - what the tool returned
  - one thing they would verify
  - one safety concern

Target outcome:

- students can explain when chat is enough and when an agent workflow is worth using

#### Debrief (2 to 5 minutes)

Key message:

- chat is often good for fast ideation
- agents are better for repository-aware iterative work
- neither replaces statistical judgment or verification

### Cycle 3. Simulation as a safe workflow strategy

#### Mini-lecture (20 minutes)

Topics:

- why simulation matters in restricted public health settings
- how to infer a simulated dataset from project requirements
- how to extract useful structure from:
  - data dictionaries
  - schemas
  - codebooks
  - small example files
- what to preserve in simulation:
  - variable names
  - variable types
  - plausible ranges
  - missingness
  - rough marginal distributions
  - a few important relationships

Key caution:

- synthetic data support workflow development
- they do not replace real analysis
- they should preserve structure, not identity

#### Demo (8 to 10 minutes)

Show:

- start from a small file or codebook
- identify variables and their properties
- sketch a simulation plan
- generate a simple synthetic dataset
- connect this back to the secure workflow:
  - prototype locally on synthetic data
  - commit and push code
  - run real analysis in enclave later

#### Activity 3 (15 to 20 minutes)

Students should:

- inspect one provided practice file
- identify:
  - variable types
  - ranges
  - missingness
  - candidate relationships
- optionally build a simple synthetic version in their preferred language

Target outcome:

- students can move from project requirements to a simulation plan

#### Debrief (2 to 5 minutes)

Key message:

- simulation is one of the most practical safety tools for AI-assisted data science in restricted settings

## Final Wrap-Up (10 minutes)

End with a short list of practical habits and tricks of the trade:

- commit often
- keep repositories clean
- use `.gitignore`
- document where AI was used
- ask tools to explain their reasoning and changes
- rerun code locally
- spot-check outputs independently
- keep claims descriptive unless assumptions are explicit and defensible

Closing message:

- good workflow is mostly about reducing paper cuts
- safe, inspectable, reproducible habits matter more than clever prompts

## Recommended Timing Summary

A workable version for 150 minutes:

- opening: 10 minutes
- cycle 1: 45 minutes
- cycle 2: 45 minutes
- cycle 3: 45 minutes
- wrap-up: 5 minutes

Alternative slightly looser version:

- opening: 10 minutes
- cycle 1: 50 minutes
- cycle 2: 45 minutes
- cycle 3: 35 minutes
- wrap-up: 10 minutes

Because this is a large group and setup issues are likely, a small time buffer is important.

## Materials to Prepare

### Required

- slide deck for the three lecture/demo cycles
- one Git and GitHub setup sheet
- one command cheat sheet
- one responsible-use checklist
- one chatbot vs agent comparison worksheet
- two small practice datasets or schemas for simulation work

### Strongly Recommended

- pre-class email asking students to:
  - create a GitHub account
  - install Git if possible
  - verify they can authenticate
- backup workflow for students who cannot push to GitHub live
- pair work option to reduce setup friction
- one synthetic public-health dataset in R-friendly format
- optional Python equivalents if you want cross-language support

## Pedagogical Notes

This plan matches the broader philosophy already present in the course materials:

- practical over abstract
- live workflow over static explanation
- safety and responsible use are central, not tacked on
- students should learn how tools fit into a real statistical workflow
- Git and simulation are not side topics; they are part of the core safety strategy

The session should avoid becoming a generic AI showcase. The emphasis should remain on:

- public health relevance
- data boundaries
- reproducibility
- workflow quality
- verification before trust

## Suggested Session Title Variants

- Safe, Reproducible AI Workflows for Public Health Data Science
- Generative AI for Public Health Data Science: Safety, Git, and Simulation
- AI-Assisted Public Health Data Science Under Real-World Constraints

## Reflection Prompt

Write two paragraphs of at least four sentences each, and one closing remark, reflecting on what you learned regarding ethical use of AI.

### Paragraph 1: Identifying Ethical Risk(s)

Describe a situation in which using AI as a student or in professional practice could create ethical risks.

This could be based on:

- your own work such as research, papers, or assignments
- something from today's class
- a hypothetical scenario related to your interests

Address this question directly:

What specifically could go wrong at the individual, organizational, or societal level?

### Paragraph 2: Professional Responsibility and Safeguards

Explain at least one responsibility a student or public health professional has in that situation.

Include at least one concrete safeguard or governance mechanism that would help the individual meet that responsibility.

Be specific about:

- how the safeguard would work in practice
- who would be responsible for implementing it
- who would be responsible for following it
- what would happen if it failed

### Closing Remark: Looking Forward

How, if at all, do you think your use of generative AI will change as a result of this session?

You will be asked a version of this question after each class session. Your responses will also help improve the course in future years.
