# Prompt Smoke Test Notes

Date: 2026-02-25

Dataset checked: `data/synthetic/simulated_maternal_health_data.csv`

## Quick Validation

- Rows: 50,000
- Columns: 20
- Required comorbidity columns present:
  - `obesity`
  - `multiple_gestation`
  - `diabetes`
  - `heart_disease`
  - `placenta_previa`
  - `hypertension`
  - `gest_hypertension`
  - `preeclampsia`
- Derived `comorbidity_count` range: 0 to 7

## Count Modeling Feasibility

- `comorbidity_count` is suitable for count-model demonstration.
- Distribution appears right-skewed with many zeros, so comparing Poisson vs negative binomial is appropriate.

## Session Use

- Use this dataset and `demos/2-tools-introduction/prompt.md` unchanged across harness/model runs for fair comparison.
