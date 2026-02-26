# Responsible AI Use Checklist (Biostatistics)

Use this checklist in Sessions 2-4 and for moonshot work.

## 1) Data Safety

- [ ] No PHI or direct identifiers are pasted into external AI tools.
- [ ] If work is outside a restricted environment, dataset is synthetic or fully public.
- [ ] Any file shared with AI is the minimum required for the task.

## 2) Task Framing

- [ ] Prompt states the analytical goal clearly (question, population, output).
- [ ] Prompt specifies acceptable methods and assumptions.
- [ ] Prompt asks for uncertainty-aware language and limitations.

## 3) Verification Before Trust

- [ ] I reran code locally and confirmed it executes.
- [ ] I checked variable definitions against codebook/schema.
- [ ] I spot-checked at least one table/plot value by independent calculation.
- [ ] I checked for impossible values, missingness artifacts, and subgroup distortions.

## 4) Interpretation Controls

- [ ] Claims are descriptive unless causal assumptions are explicit and defensible.
- [ ] Visual design choices do not mislead (axes, scales, denominators, subgroup sizes).
- [ ] Limitations and uncertainty are reported in plain language.

## 5) Documentation and Reproducibility

- [ ] I documented where AI was used (task, tool, date).
- [ ] I saved the final prompt/context and what I changed manually.
- [ ] I saved verification notes (what failed, what was corrected, what remains uncertain).
- [ ] Output is reproducible from committed code and local data paths.

## Stop Conditions

Pause and escalate if any of the following occur:

- AI-generated code runs but output conflicts with domain expectations.
- Model gives strong claims without transparent support.
- Data handling could violate privacy, policy, or IRB constraints.
