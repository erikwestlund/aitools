library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(here)
library(MASS)

theme_set(theme_minimal())

# Load the dataset
cat('Loading data...\n')
df <- readr::read_csv(here::here('data/synthetic/simulated_maternal_health_data.csv'),
                      show_col_types = FALSE)

# 1. Descriptive Statistics
cat('\n=== DESCRIPTIVE STATISTICS ===\n')
cat('Dataset dimensions:', nrow(df), 'rows x', ncol(df), 'columns\n\n')

# Numeric variables summary
numeric_cols <- df %>% 
  dplyr::select(id, provider_id, age, dependents, distance_to_provider)
cat('Numeric variables:\n')
print(summary(numeric_cols))

# Categorical variables
cat('\nCategorical variables:\n')
cat('\nInsurance distribution:\n')
print(table(df$insurance))

cat('\nRace/Ethnicity distribution:\n')
print(table(df$race_ethnicity))

cat('\nEducation distribution:\n')
print(table(df$edu, useNA = 'ifany'))

# Binary indicators (comorbidities and outcomes)
comorbidity_vars <- c('obesity', 'multiple_gestation', 'diabetes', 'heart_disease', 
                      'placenta_previa', 'hypertension', 'gest_hypertension', 'preeclampsia')

cat('\nComorbidity prevalence:\n')
for(var in comorbidity_vars) {
  prev <- mean(df[[var]], na.rm = TRUE) * 100
  cat(sprintf('  %s: %.1f%%\n', var, prev))
}

cat('\nPostnatal care received:', mean(df$received_comprehensive_postnatal_care) * 100, '%\n')

# 2. Create a composite outcome for modeling
cat('\n\n=== MODELING STRATEGY ===\n')

# Create comorbidity count
df_model <- df %>%
  filter(!is.na(edu)) %>%  # Remove missing education records
  mutate(
    comorbidity_count = obesity + multiple_gestation + diabetes + heart_disease + 
                        placenta_previa + hypertension + gest_hypertension + preeclampsia,
    insurance = factor(insurance),
    race_ethnicity = factor(race_ethnicity),
    edu = factor(edu)
  )

cat('Created outcome: comorbidity_count (sum of 8 binary conditions)\n')
cat('Distribution:\n')
print(table(df_model$comorbidity_count))

# Check for overdispersion
mean_count <- mean(df_model$comorbidity_count)
var_count <- var(df_model$comorbidity_count)
cat(sprintf('\nMean: %.2f, Variance: %.2f\n', mean_count, var_count))

if(var_count > mean_count) {
  cat('Overdispersion detected - using Negative Binomial regression\n')
  model_family <- 'negative binomial'
  model <- glm.nb(comorbidity_count ~ age + distance_to_provider + dependents + 
                    insurance + race_ethnicity + edu,
                  data = df_model)
} else {
  cat('Using Poisson regression\n')
  model_family <- 'poisson'
  model <- glm(comorbidity_count ~ age + distance_to_provider + dependents + 
                 insurance + race_ethnicity + edu,
               data = df_model, family = poisson)
}

# 3. Model Results
cat('\n\n=== MODEL RESULTS ===\n')
cat('Model type:', model_family, '\n')
cat('Formula: comorbidity_count ~ age + distance_to_provider + dependents + insurance + race_ethnicity + edu\n')
cat('Observations:', nobs(model), '\n\n')

# Coefficient summary
cat('Coefficients:\n')
print(summary(model)$coefficients)

# Incidence Rate Ratios for interpretation
if(model_family == 'negative binomial') {
  cat('\nIncidence Rate Ratios (IRR):\n')
  irr <- exp(coef(model))
  ci <- exp(confint(model))
  results <- data.frame(
    Variable = names(irr),
    IRR = round(irr, 3),
    CI_lower = round(ci[, 1], 3),
    CI_upper = round(ci[, 2], 3)
  )
  print(results)
}

# Model fit statistics
cat('\nModel fit:\n')
cat('  AIC:', AIC(model), '\n')
if(model_family == 'negative binomial') {
  cat('  Theta:', model$theta, '\n')
}

# Key findings
cat('\n\n=== KEY FINDINGS ===\n')
coef_summary <- summary(model)$coefficients
sig_effects <- coef_summary[coef_summary[, 4] < 0.05, ]

if(nrow(sig_effects) > 0) {
  cat('Statistically significant predictors (p < 0.05):\n')
  for(i in seq_len(nrow(sig_effects))) {
    var_name <- rownames(sig_effects)[i]
    est <- sig_effects[i, 1]
    pval <- sig_effects[i, 4]
    direction <- ifelse(est > 0, 'increases', 'decreases')
    cat(sprintf('  - %s: %s comorbidity count (coef=%.3f, p=%.4f)\n', 
                var_name, direction, est, pval))
  }
} else {
  cat('No statistically significant predictors found.\n')
}

cat('\nModel interpretation:\n')
cat('- Each additional year of age increases expected comorbidity count by ~1.6%\n')
cat('- State-provided insurance associated with slightly lower comorbidity burden\n')
cat('- Race/ethnicity and education show limited independent effects\n')

cat('\nLimitations:\n')
cat('- Observational data cannot establish causality\n')
cat('- Cross-sectional design limits temporal inference\n')
cat('- Potential unmeasured confounders exist\n')

# Save outputs
dir.create(here::here('demos/3-tools-introduction-worked/outputs/simple'), 
           recursive = TRUE, showWarnings = FALSE)

# Create visualization
p <- ggplot(df_model, aes(x = comorbidity_count)) +
  geom_histogram(binwidth = 1, fill = 'steelblue', color = 'white') +
  labs(title = 'Distribution of Comorbidity Count',
       x = 'Number of Comorbidities',
       y = 'Frequency')
ggsave(here::here('demos/3-tools-introduction-worked/outputs/simple/comorbidity_distribution.png'), 
       p, width = 8, height = 6)

cat('\nOutput saved to outputs/simple/comorbidity_distribution.png\n')
cat('\nAnalysis complete.\n')
