# Generative AI Session

This module contains materials for a one-off 2.5 hour session on generative AI for public health students.

## Intended Structure

- one slide deck for the main live session
- separate handouts and activity sheets
- a reflection prompt rendered to PDF
- practice files for simulation work stored in `sim_data/`

## Core Teaching Frame

- code can move across environments; sensitive data cannot
- work locally on synthetic or public data
- use Git and GitHub to move code safely
- verify before trust
- treat reproducibility and data safety as central, not optional

## Files

- `session-slides.qmd`: main revealjs slide deck
- `reflection-prompt.qmd`: student reflection handout for PDF rendering
- `materials/`: activity prompts and instructor-facing handouts
- `sim_data/`: practice data and related notes

## Rendering

From `modules/`, render with Quarto as needed:

- `quarto render gen_ai_session/session-slides.qmd`
- `quarto render gen_ai_session/reflection-prompt.qmd`

The module-level Quarto config writes output into `docs/modules/`.
