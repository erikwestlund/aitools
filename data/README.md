# Session Dataset Starter Pack

This folder contains datasets for Sessions 2-4.

## Included Files

- `data/synthetic/simulated_maternal_health_data.csv`
  - Synthetic individual-level maternal health dataset for visualization and modeling practice.
  - No real patients; suitable for AI-assisted classroom demos.

- `data/synthetic/simulated_data.csv`
  - Alternate synthetic dataset with a similar schema for quick exercises.
  - Useful when you want students to run the same workflow on a second dataset.

- `data/public/cdc_prams_df_final.rds`
  - Public-data-derived PRAMS object used in prior course materials.
  - Good for demonstrations that connect to maternal and child health topics.

## Recommended Public Biomedical Sources (for future additions)

- CDC PRAMStat (Maternal and Child Health):
  - https://data.cdc.gov/Maternal-Child-Health/CDC-PRAMStat-Data-for-2011/ese6-rqpq/about_data

- CDC Influenza Vaccination Coverage:
  - https://data.cdc.gov/Flu-Vaccinations/Influenza-Vaccination-Coverage-for-All-Ages-6-Mont/vh55-3he6/about_data

- NHANES (CDC):
  - https://wwwn.cdc.gov/nchs/nhanes/

## Teaching Notes

- For external AI tools, use synthetic datasets only.
- For restricted data environments, move code and metadata between environments, not raw sensitive data.
- In this project, use Framework data functions (`data_read()`, `data_save()`) in scripts and notebooks.
