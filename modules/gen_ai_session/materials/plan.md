# Session Plan

## Core Message

Code can move across environments; sensitive data cannot.

## Session Length

2.5 hours

## Run of Show

1. Intro and framing: 20 minutes
2. Git / GitHub / `.gitignore` demo: 15 minutes
3. Git activity: 35 minutes
4. Break: 5 minutes
5. Harnesses: chat vs agent CLI vs agent GUI: 20 minutes
6. Simulated data workflow framing and demo: 15 minutes
7. Simulation activity: 25 to 30 minutes
8. Debrief and wrap-up: 10 to 15 minutes

## 1. Intro and Framing

Time: 20 minutes

### Cover

1. What AI tools are available for coding and analysis support
2. Why the state of the tools in statistics and data science is different from software engineering
3. What we know from research on performance
4. Why the evidence is still limited
5. Why privacy is a primary constraint in health research
6. Why reproducibility means AI should help write code rather than directly replace analytic judgment

### Key Messages

1. AI performance in software engineering does not automatically imply strong performance in statistics or public health analysis.
2. In health research, privacy changes the workflow.
3. The practical goal is to use AI to help produce code and workflow scaffolding.
4. The practical goal is not to let AI produce untracked analysis claims.
5. Students should assume that if data are available in a project, an agent may be able to inspect them.

## 2. Git / GitHub / `.gitignore` Demo

Time: 15 minutes

### Instructor Demo

1. Create a small local repository.
2. Add a file and commit it.
3. Create a `.gitignore` and show that a pretend sensitive file is not tracked.
4. Push the repository to GitHub.
5. Pull or clone it into a second location.
6. Make one change there and bring it back.

### Teaching Point

Git and GitHub are part of the safety workflow because they let us move code without moving data.

## 3. Git Activity

Time: 35 minutes

### Student Task

1. Initialize a repository.
2. Add a small file.
3. Commit it.
4. Add and test a `.gitignore`.
5. Push to GitHub.
6. Pull or clone into a second location.
7. Make a second commit.
8. Pull that change back into the original location.

### Success Check

1. Students have a local repository.
2. Students have at least one commit.
3. Students have a remote GitHub repository.
4. Students can explain what `.gitignore` prevented from being tracked.
5. Students can explain the difference between local and remote.

## 4. Break

Time: 5 minutes

## 5. Harnesses: Chat vs Agent CLI vs Agent GUI

Time: 20 minutes

### Purpose

Set up the second half of class by showing that the model is only one part of the workflow. The harness determines what the tool can access, how much context it keeps, and what actions it can take.

### Cover

1. Chat interface
2. Agent CLI workflow
3. Agent GUI workflow
4. What each tool can see
5. What each tool can do
6. What each tool records for later reproducibility

### Instructor Demo

1. Show the same small prepared task in chat.
2. Show the same task in an agent CLI setup.
3. Show the same task in an agent GUI setup.
4. Point out differences in context, permissions, speed, transparency, and control.

### Plot Experiment Discussion

Use about 20 minutes total for this block, including a short discussion of the plot experiment.

### Questions to Highlight

1. Which interface gave the most usable result fastest?
2. Which interface made it clearest what context was being used?
3. Which interface created the most risk of exposing files or data unintentionally?
4. What did the plot experiment suggest about output quality versus output polish?
5. What kinds of visualization tasks seemed reliable, and which still needed careful checking?

### Teaching Point

The important choice is not just which model to use. It is which harness to use, with what permissions, in what environment.

## 6. Simulated Data Workflow Framing and Demo

Time: 15 minutes

### Instructor Framing

Show the workflow:

1. Enter the secure environment.
2. Extract non-sensitive structural information about the data.
3. Bring only that structural information back to a non-data-connected environment.
4. Use AI assistance there to generate code and create a similar synthetic dataset.
5. Return validated code to the secure environment for real execution if needed.

### Information to Extract in the Secure Environment

1. Variable names
2. Variable types
3. Response categories
4. Basic frequencies or counts
5. Plausible ranges
6. Missingness patterns

### Warnings to State Explicitly

1. Data values themselves can be identifying.
2. Free-text fields are especially risky.
3. This workflow is not a guarantee of security.
4. Some projects will require more sophisticated masking or disclosure review.
5. Synthetic data are useful for workflow development, cleaning logic, and realistic missingness patterns.
6. Synthetic data will usually not preserve joint distributions unless you explicitly design them to do so.
7. Students should not expect synthetic data to be enough for model tuning or final inference.
8. That is acceptable because those steps belong in the secure environment.

## 7. Simulation Activity

Time: 25 to 30 minutes

### Setup

1. Provide a public GitHub repository with small practice datasets and a starter extraction script.
2. Tell students to pretend the datasets are in a secure environment.
3. Students should not use an LLM for the extraction step.

### Student Task Part 1

In the "secure environment" project:

1. Run or complete the script that extracts key structural information.
2. Save the output that describes variables, types, categories, ranges, frequencies, and missingness.

### Student Task Part 2

In a separate project with LLM access:

1. Use the extracted structural information.
2. Ask the LLM to help create a simulated dataset.
3. Generate code to build the synthetic data.
4. Create at least one table and one visualization from the simulated data.

### Success Check

1. Students keep the extraction step separate from the LLM step.
2. Students produce a synthetic dataset from the extracted structure.
3. Students create one table and one figure from the synthetic data.
4. Students can explain what this workflow is good for and what it is not good for.

## 8. Debrief and Wrap-Up

Time: 10 to 15 minutes

### Debrief Questions

1. What information was safe enough to move, and what was not?
2. What did simulated data help with?
3. What could simulated data not preserve in your example?
4. Where would you still need to work inside the secure environment?
5. What role should AI play in this workflow?

## Notes for Execution

1. Keep the demos fast and prepared.
2. Spend class time mostly on student execution, troubleshooting, and debrief.
3. Treat branches as optional or a brief aside unless time remains.
4. Keep the distinction between code movement and data movement visible throughout the session.
5. Use the harnesses block to connect the privacy discussion to the simulated-data workflow.
