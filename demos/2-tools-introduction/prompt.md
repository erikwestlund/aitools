# Standardized Prompt for Harness/Model Comparison

You are helping with a biostatistics classroom demonstration.

Dataset: `data/synthetic/simulated_maternal_health_data.csv`

Goal: produce a reproducible analysis workflow that is transparent and safety-aware.

Please do the following:

1. Load the dataset and normalize columns/types.
   - Use clear snake_case names.
   - Ensure categorical vs numeric types are explicit.
2. Summarize the data.
   - Report row count, column count, missingness, and key descriptive summaries.
   - Flag suspicious values or quality concerns.
3. Create key visualizations.
   - At minimum, show relationships for:
     - `received_comprehensive_postnatal_care`
     - `distance_to_provider`
     - `insurance`
     - `race_ethnicity`
4. Build a count outcome and model it.
   - Define `comorbidity_count` as the row-wise sum of:
     `obesity`, `multiple_gestation`, `diabetes`, `heart_disease`, `placenta_previa`, `hypertension`, `gest_hypertension`, `preeclampsia`.
   - Select an appropriate count-model strategy (Poisson vs negative binomial, with justification).
   - Fit the model and report interpretable results.
5. Report results responsibly.
   - Keep interpretation descriptive/non-causal.
   - Include model assumptions, diagnostics, and limitations.
   - Include a 5-item verification checklist.

Constraints:

- This is synthetic data for teaching; still follow good biostatistical practice.
- Do not make causal claims.
- Prefer readable, modular, reproducible code.
- State exactly what files you changed.
