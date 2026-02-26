# Session 2 Demo Plan: Visualization First (Chat -> Agent)

## Objective

Students see one concrete AI-assisted biostat workflow and how responsible-use checks change decisions.

## Dataset

- Primary: `data/synthetic/simulated_maternal_health_data.csv`
- Backup: `data/synthetic/simulated_data.csv`

## Timing (40 minutes)

- 5 min: Set up the task and responsible-use criteria
- 12 min: Chatbot-based visualization pass
- 12 min: Agent-based visualization pass (same task)
- 8 min: Compare outputs and run verification checks
- 3 min: Debrief and handoff to students

## Demo Task

"Create one publication-ready plot showing how receipt of comprehensive postnatal care varies by distance to provider, stratified by insurance."

## Chatbot Pass (Prompt Template)

Use this prompt with a chat model:

```text
You are helping with a biostatistics class demo.

I have a synthetic maternal health CSV with columns:
received_comprehensive_postnatal_care (0/1),
distance_to_provider (numeric),
insurance (categorical), age, race_ethnicity, and comorbidity indicators.

Task:
1) Write R code using tidyverse + ggplot2 to:
   - read the file,
   - create distance quintiles,
   - estimate the proportion receiving comprehensive postnatal care by distance quintile and insurance,
   - plot those proportions with 95% CIs.
2) Include clear labels and a cautious interpretation paragraph.
3) Add a short section called "Verification checks" with 5 checks I should run.

Constraints:
- Do not make causal claims.
- Call out uncertainty and possible confounding.
- Use reproducible code only.
```

## Agent Pass (Prompt Template)

Use this prompt in an agent with repository context:

```text
Goal: Build a reproducible analysis script for a classroom demo.

Dataset path: data/synthetic/simulated_maternal_health_data.csv

Please create one R script that:
1) Reads data,
2) Creates distance quintiles,
3) Computes postnatal care rates by quintile and insurance with binomial 95% CIs,
4) Produces a polished ggplot,
5) Prints a short, non-causal interpretation,
6) Prints 5 verification checks.

Requirements:
- Keep code readable and modular.
- Assume this is biostatistics teaching material.
- Explicitly flag limitations and non-causal interpretation.
- Return what files you changed.
```

## Compare and Teach

Use these prompts for class discussion:

- What did chat do quickly that was useful?
- What did the agent do better (structure, reproducibility, iteration)?
- What errors would pass unnoticed without verification?
- What would be unsafe with real PHI data?

## Verification Checks to Model Live

- Confirm binary outcome is coded correctly (`0/1`) and no unexpected values.
- Confirm denominator sizes by insurance and quintile before plotting.
- Confirm CI calculation method and edge-case behavior.
- Check whether distance bins are balanced and interpretable.
- Confirm wording stays descriptive, not causal.

## Session 3 Bridge

Tell students: Session 3 will repeat this workflow with stricter context management, `tmux`, and a two-environment pattern (restricted data inspection -> synthetic safe iteration -> code return).
