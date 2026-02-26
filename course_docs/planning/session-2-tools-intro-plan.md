# Session 2 Tools Introduction Plan

## Teaching Goal

Students should leave with a practical framework for choosing models and harnesses, and a clear standard for responsible AI use in biostatistics.

## Session Structure (Instructor-Led)

1. **Model choice first (lecture)**
   - Model size and latency/cost tradeoffs
   - Quantization and why it matters for local runs
   - Model types: instruct vs reasoning (and when each helps)
   - Local vs cloud models (privacy, performance, and governance)
2. **Chat quickly (demo)**
   - One fast visualization-oriented pass
   - Emphasize prompt clarity and verification limits
3. **Agents as the main focus (demo + comparison)**
   - Harness concept: model + tools + permissions + context + workflow
   - Tool calling basics: read/search/edit/run and audit trail implications
   - Security section: scope limits, data boundaries, and policy checks
   - CLI and browser agent contrast (one browser pass only)

## Agent Harnesses to Compare

- CLI: Claude Code, Codex CLI, OpenCode
- Browser-based: one workflow demo (single pass for parity)

## Models to Compare

- Opus 4.6
- Codex GPT-5.3
- Kimi K2.5
- Gemini 3.1 Pro
- GLM-5
- Haiku 4.5

## Standardized Demo Prompt (Single Prompt for All Runs)

Use one dataset and one task structure across all runs:

- Input: `data/synthetic/simulated_maternal_health_data.csv`
- Tasks:
  - normalize column names and variable types
  - summarize variable distributions and missingness
  - produce key visualizations for selected predictors/outcomes
  - define a count outcome (`comorbidity_count`) and choose an appropriate model
  - fit/report model results with assumptions and limitations
- Output: reproducible code + concise report + verification checks

## Security and Risk Talking Points

- No PHI in external tools; synthetic/public data only
- Principle of least privilege for tool permissions and filesystem scope
- Verify before trust: independent spot checks and reproducible reruns
- Known risks to reference briefly:
  - brittle behavior under buggy context
  - overconfidence/miscalibration
  - benchmark inflation/contamination
  - vulnerable code suggestions in some settings

## Deliverables Prepared in This Repo

- Prompt file for standardized runs
- Scripted `.qmd` generation workflow (`source/` has template, script generates to `worked/`)
- Combination-specific `.qmd` stubs (harness x model; generated from one template into `worked/`)
- Session notes and comparison matrix template

## What Session 2 Produces

- A side-by-side qualitative comparison of harnesses and models on one biostat task
- A reusable workflow students can follow in Session 3
