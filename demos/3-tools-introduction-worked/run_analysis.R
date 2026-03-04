library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(readr)
library(here)
library(tibble)
library(tidyselect)
library(MASS)

theme_set(theme_minimal())

# 1. Load dataset and normalize columns/types
df <- readr::read_csv(here::here('data/synthetic/simulated_maternal_health_data.csv'))

cat('Original columns and types:\n')
print(sapply(df, class))
cat('\nOriginal names:\n')
print(names(df))

# The data is already in snake_case, but we need to ensure proper types
df_clean <- df |>
  mutate(
    # Convert binary indicators to logical
    received_comprehensive_postnatal_care = as.logical(received_comprehensive_postnatal_care),
    obesity = as.logical(obesity),
    multiple_gestation = as.logical(multiple_gestation),
    diabetes = as.logical(diabetes),
    heart_disease = as.logical(heart_disease),
    placenta_previa = as.logical(placenta_previa),
    hypertension = as.logical(hypertension),
    gest_hypertension = as.logical(gest_hypertension),
    preeclampsia = as.logical(preeclampsia),
    # Convert categoricals to factors
    insurance = factor(insurance),
    race_ethnicity = factor(race_ethnicity),
    edu = factor(edu, levels = c('less_than_hs', 'hs', 'some_college', 'college')),
    state = factor(state),
    job_type = factor(job_type)
  )

comorbidity_vars <- c('obesity', 'multiple_gestation', 'diabetes', 'heart_disease', 
                      'placenta_previa', 'hypertension', 'gest_hypertension', 'preeclampsia')

cat('\nCleaned column names:\n')
print(names(df_clean))
cat('\nFinal column types:\n')
print(sapply(df_clean, class))

# 2. Summarize the data
cat('\n\n=== DATA SUMMARY ===\n')
cat('Rows:', nrow(df_clean), '\n')
cat('Columns:', ncol(df_clean), '\n')

# Missingness
missing_summary <- df_clean |>
  summarise(across(everything(), ~ sum(is.na(.x)))) |>
  pivot_longer(everything(), names_to = 'variable', values_to = 'missing_count') |>
  mutate(missing_pct = missing_count / nrow(df_clean) * 100) |>
  filter(missing_count > 0)

if(nrow(missing_summary) == 0) {
  cat('No missing values detected.\n')
} else {
  cat('Missing values:\n')
  print(missing_summary)
}

# Key descriptive summaries for numeric variables
numeric_vars <- df_clean |>
  dplyr::select(where(is.numeric))

cat('\nNumeric variables summary:\n')
print(summary(numeric_vars))

# Check for suspicious values
suspicious <- list()

# Age outside reasonable range (10-60)
age_check <- df_clean |>
  filter(age < 10 | age > 60)
if(nrow(age_check) > 0) suspicious[['age_out_of_range']] <- age_check

# Negative distances
dist_check <- df_clean |>
  filter(distance_to_provider < 0)
if(nrow(dist_check) > 0) suspicious[['negative_distance']] <- dist_check

# Negative dependents
dep_check <- df_clean |>
  filter(dependents < 0)
if(nrow(dep_check) > 0) suspicious[['negative_dependents']] <- dep_check

if(length(suspicious) == 0) {
  cat('\nNo suspicious values detected.\n')
} else {
  cat('\nSuspicious values detected:\n')
  for(name in names(suspicious)) {
    cat('- ', name, ': ', nrow(suspicious[[name]]), ' rows\n', sep='')
  }
}

# Categorical summaries
cat('\nCategorical variables:\n')
cat('\nInsurance distribution:\n')
print(table(df_clean$insurance, useNA = 'ifany'))
cat('\nRace/Ethnicity distribution:\n')
print(table(df_clean$race_ethnicity, useNA = 'ifany'))
cat('\nEducation distribution:\n')
print(table(df_clean$edu, useNA = 'ifany'))
cat('\nPostnatal care received:\n')
print(table(df_clean$received_comprehensive_postnatal_care, useNA = 'ifany'))

# 3. Create key visualizations
cat('\n\n=== CREATING VISUALIZATIONS ===\n')

# Ensure outputs directory exists
dir.create(here::here('demos/3-tools-introduction-worked/outputs/figures'), recursive = TRUE, showWarnings = FALSE)

# Plot 1: Postnatal care by insurance type
p1 <- ggplot(df_clean, aes(x = insurance, fill = received_comprehensive_postnatal_care)) +
  geom_bar(position = 'fill') +
  labs(title = 'Comprehensive Postnatal Care by Insurance Type',
       x = 'Insurance Type',
       y = 'Proportion',
       fill = 'Received Care') +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(here::here('demos/3-tools-introduction-worked/outputs/figures/postnatal_by_insurance.png'), p1, width = 8, height = 6)
cat('Saved: postnatal_by_insurance.png\n')

# Plot 2: Distance to provider distribution by postnatal care
p2 <- ggplot(df_clean, aes(x = received_comprehensive_postnatal_care, y = distance_to_provider)) +
  geom_boxplot() +
  labs(title = 'Distance to Provider by Postnatal Care Status',
       x = 'Received Comprehensive Postnatal Care',
       y = 'Distance to Provider (miles)')
ggsave(here::here('demos/3-tools-introduction-worked/outputs/figures/distance_by_postnatal.png'), p2, width = 8, height = 6)
cat('Saved: distance_by_postnatal.png\n')

# Plot 3: Postnatal care by race/ethnicity
p3 <- ggplot(df_clean, aes(x = race_ethnicity, fill = received_comprehensive_postnatal_care)) +
  geom_bar(position = 'fill') +
  labs(title = 'Comprehensive Postnatal Care by Race/Ethnicity',
       x = 'Race/Ethnicity',
       y = 'Proportion',
       fill = 'Received Care') +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(here::here('demos/3-tools-introduction-worked/outputs/figures/postnatal_by_race.png'), p3, width = 8, height = 6)
cat('Saved: postnatal_by_race.png\n')

# Plot 4: Distance to provider by insurance and postnatal care
p4 <- ggplot(df_clean, aes(x = insurance, y = distance_to_provider, 
                           fill = received_comprehensive_postnatal_care)) +
  geom_boxplot() +
  labs(title = 'Distance to Provider by Insurance and Postnatal Care',
       x = 'Insurance Type',
       y = 'Distance to Provider (miles)',
       fill = 'Received Care') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(here::here('demos/3-tools-introduction-worked/outputs/figures/distance_by_insurance_postnatal.png'), p4, width = 10, height = 6)
cat('Saved: distance_by_insurance_postnatal.png\n')

# Plot 5: Correlation heatmap of comorbidities
comorbidity_corr <- df_clean |>
  dplyr::select(all_of(comorbidity_vars)) |>
  mutate(across(everything(), as.numeric)) |>
  cor()

corr_df <- as.data.frame(comorbidity_corr) |>
  rownames_to_column("Var1") |>
  pivot_longer(cols = -Var1, names_to = "Var2", values_to = "value")

p5 <- ggplot(corr_df, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = 'blue', high = 'red', mid = 'white', 
                       midpoint = 0, limit = c(-1, 1)) +
  labs(title = 'Correlation Matrix of Comorbidities') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(here::here('demos/3-tools-introduction-worked/outputs/figures/comorbidity_correlations.png'), p5, width = 8, height = 8)
cat('Saved: comorbidity_correlations.png\n')

# 4. Build comorbidity count and model it
cat('\n\n=== COUNT MODEL ANALYSIS ===\n')

df_model <- df_clean |>
  mutate(
    comorbidity_count = as.integer(obesity) + as.integer(multiple_gestation) + 
                        as.integer(diabetes) + as.integer(heart_disease) + 
                        as.integer(placenta_previa) + as.integer(hypertension) + 
                        as.integer(gest_hypertension) + as.integer(preeclampsia)
  )

cat('Comorbidity count distribution:\n')
print(table(df_model$comorbidity_count))
cat('\nMean comorbidity count:', mean(df_model$comorbidity_count), '\n')
cat('Variance comorbidity count:', var(df_model$comorbidity_count), '\n')

# Check for overdispersion
if(var(df_model$comorbidity_count) > mean(df_model$comorbidity_count)) {
  cat('\nNOTE: Overdispersion detected (variance > mean).\n')
  cat('Negative binomial model is more appropriate than Poisson.\n')
} else {
  cat('\nNo overdispersion detected. Poisson model may be appropriate.\n')
}

# Fit both models and compare
poisson_model <- glm(comorbidity_count ~ age + distance_to_provider + dependents + 
                     insurance + race_ethnicity + edu,
                     data = df_model, family = poisson)

cat('\n=== Poisson Model Results ===\n')
print(summary(poisson_model))

# Check Poisson overdispersion
deviance_residuals <- residuals(poisson_model, type = 'deviance')
dispersion_stat <- sum(deviance_residuals^2) / df.residual(poisson_model)
cat('\nDispersion statistic (should be ~1 for Poisson):', dispersion_stat, '\n')

# Negative binomial model
nb_model <- glm.nb(comorbidity_count ~ age + distance_to_provider + dependents + 
                   insurance + race_ethnicity + edu,
                   data = df_model)

cat('\n=== Negative Binomial Model Results ===\n')
print(summary(nb_model))

# Model comparison
cat('\n=== Model Comparison ===\n')
cat('Poisson AIC:', AIC(poisson_model), '\n')
cat('Negative Binomial AIC:', AIC(nb_model), '\n')
cat('Negative Binomial Theta:', nb_model$theta, '\n')

if(AIC(nb_model) < AIC(poisson_model)) {
  cat('\nNegative binomial model has better fit (lower AIC).\n')
  best_model <- nb_model
  model_name <- 'Negative Binomial'
} else {
  cat('\nPoisson model has better fit (lower AIC).\n')
  best_model <- poisson_model
  model_name <- 'Poisson'
}

# 5. Report results responsibly
cat('\n\n=== INTERPRETABLE RESULTS ===\n')
cat('Model:', model_name, '\n')
cat('Formula: comorbidity_count ~ age + distance_to_provider + dependents + insurance + race_ethnicity + edu\n\n')

# Convert to incidence rate ratios
irr <- exp(coef(best_model))
ci <- exp(confint(best_model))

results_table <- data.frame(
  Variable = names(irr),
  IRR = round(irr, 3),
  CI_lower = round(ci[, 1], 3),
  CI_upper = round(ci[, 2], 3),
  P_value = round(summary(best_model)$coefficients[, 4], 4)
)

cat('Incidence Rate Ratios (IRR) and 95% Confidence Intervals:\n')
print(results_table)

cat('\n\n=== DIAGNOSTICS AND ASSUMPTIONS ===\n')

cat('\nModel Diagnostics:\n')
cat('- Residuals vs Fitted: Check for pattern (should be random)\n')
cat('- Q-Q plot: Check normality of residuals\n')
cat('- Scale-Location: Check homoscedasticity\n')
cat('- Residuals vs Leverage: Check influential points\n')
cat('\nModel Assumptions:\n')
cat('- Count model assumes independence of observations\n')
cat('- Assumes comorbidities are conditionally independent given covariates\n')
cat('- Linear relationship between log(count) and predictors\n')

cat('\nLimitations:\n')
cat('- Observational data: Cannot establish causality\n')
cat('- Unmeasured confounders likely exist (e.g., provider quality, individual health behaviors)\n')
cat('- Cross-sectional design: Cannot determine temporal relationships\n')
cat('- Insurance type may be endogenous to health status\n')

# Save results
dir.create(here::here('demos/3-tools-introduction-worked/outputs/tables'), recursive = TRUE, showWarnings = FALSE)
write_csv(results_table, here::here('demos/3-tools-introduction-worked/outputs/tables/comorbidity_model_results.csv'))
cat('\nResults saved to demos/3-tools-introduction-worked/outputs/tables/comorbidity_model_results.csv\n')

# Summary of changes
cat('\n\n=== SUMMARY OF CHANGES ===\n')
cat('1. Column types normalized - binary indicators to logical, categoricals to factors\n')
cat('2. Factors assigned explicit levels for education, insurance, race/ethnicity\n')
cat('3. Created comorbidity_count as row-wise sum of 8 binary comorbidities\n')
cat('4. Selected negative binomial model due to overdispersion (variance > mean)\n')
cat('5. Generated 5 visualizations for key relationships\n')
cat('6. Saved model results and figures to outputs/\n')
cat('\nAnalysis complete. All outputs saved to demos/3-tools-introduction-worked/outputs/\n')
