# Session 2 Tools Introduction Demo Assets

This folder contains standardized materials to compare harnesses and models on one biostatistics task.

## Workflow

1. Finalize one prompt in `prompt.md`.
2. Maintain three canonical templates in `source/`:
   - `02-tools-chat-template.qmd`
   - `02-tools-simple-template.qmd`
   - `02-tools-detailed-template.qmd`
3. Generate near-identical `.qmd` stubs via `generate_stubs.R`.
4. Work live in `worked/` during class (`worked/` is gitignored).

## Core Files

- `prompt.md`: single prompt used across all runs
- `prompt-smoke-test.md`: quick dataset feasibility notes
- `generate_stubs.R`: script to generate stub notebooks
- `comparison-matrix.md`: in-class scoring grid
- `source/`: contains three canonical templates (chat/simple/detailed)
- `worked/`: generated notebooks (not committed)

## Generated Output Layout

- `chat` stubs: 2 files total (browser only: ChatGPT + Claude)
- `simple` stubs: 10 files total (claude-code + codex-cli + opencode)
- `detailed` stubs: 10 files total (claude-code + codex-cli + opencode)
- Total in `worked/`: 22 `.qmd` files per generation run

## Dataset

- `data/synthetic/simulated_maternal_health_data.csv`

## Notes

- Keep prompt and dataset fixed when comparing harness/model behavior.
- For external tools, do not use real sensitive data.
- In scripts/notebooks in this project, start with `scaffold()`.
