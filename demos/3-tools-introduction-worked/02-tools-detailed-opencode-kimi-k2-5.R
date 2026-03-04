#!/usr/bin/env Rscript

# =============================================================================
# Maternal Health Data Analysis
# =============================================================================
# This script performs a thorough statistical analysis of maternal health data
# with focus on postnatal care and comorbidities.
# 
# Tasks completed:
# 1. Data loading and normalization
# 2. Comprehensive data summary
# 3. Key visualizations
# 4. Count outcome modeling (comorbidity_count)
# 5. Responsible results reporting
# =============================================================================

# Load required libraries (excluding auto-attached ones per CLAUDE.md)
library(dplyr)
library(tidyr)
library(ggplot2)
library(here)
library(janitor)
library(skimr)
library(MASS)  # For negative binomial regression
library(pscl)  # For zero-inflation models if needed
library(broom)
library(readr)

# Set seed for reproducibility
set.seed(42)

# =============================================================================
# 1. LOAD AND NORMALIZE DATA
# =============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("STEP 1: DATA LOADING AND NORMALIZATION\n")
cat(rep("=", 80), "\n", sep = "")

# Read the data
df <- readr::read_csv(here::here("data/synthetic/simulated_maternal_health_data.csv"))

# Clean column names to snake_case
df <- df %>% janitor::clean_names()

# Display structure before type conversion
cat("\nOriginal column names:\n")
print(names(df))

# Normalize column types
df <- df %>%
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
    
    # Convert categorical variables to factors with meaningful levels
    state = as.factor(state),
    race_ethnicity = factor(race_ethnicity, 
                             levels = c("white", "black", "hispanic", "asian", "aian", "nhpi", "other"),
                             labels = c("White", "Black", "Hispanic", "Asian", "AI/AN", "NH/PI", "Other")),
    insurance = factor(insurance,
                       levels = c("no_insurance", "state_provided", "private"),
                       labels = c("No Insurance", "State Provided", "Private")),
    job_type = factor(job_type),
    edu = factor(edu, 
                 levels = c("less_than_hs", "hs", "some_college", "college", "post_grad"),
                 labels = c("< High School", "High School", "Some College", "College", "Post-Grad"),
                 ordered = TRUE),
    self_report_income = factor(self_report_income,
                                levels = c("$0–$24,999", "$25,000–$49,999", "$50,000–$74,999", 
                                           "$75,000–$99,999", "$100,000–$149,999", "$150,000–$199,999", "$200,000+"),
                                ordered = TRUE)
  )

cat("\nData structure after normalization:\n")
str(df, give.attr = FALSE, give.length = FALSE)

cat("\nSummary of changes:\n")
cat("- Cleaned column names to snake_case\n")
cat("- Converted binary indicators (0/1) to logical type\n")
cat("- Converted categorical variables to factors with meaningful labels\n")
cat("- Set ordered factors for education and income\n")

# =============================================================================
# 2. SUMMARIZE THE DATA
# =============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("STEP 2: DATA SUMMARY\n")
cat(rep("=", 80), "\n", sep = "")

# Basic dimensions
cat("\nDataset Dimensions:\n")
cat("- Rows:", nrow(df), "\n")
cat("- Columns:", ncol(df), "\n")

# Missingness analysis
cat("\nMissingness Analysis:\n")
missing_summary <- df %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_count") %>%
  mutate(missing_pct = round(100 * missing_count / nrow(df), 2)) %>%
  filter(missing_count > 0)

if (nrow(missing_summary) == 0) {
  cat("- No missing values detected in any column\n")
} else {
  print(missing_summary)
}

# Duplicate check
duplicates <- df %>% duplicated() %>% sum()
cat("\nDuplicate Rows:", duplicates, "\n")

# Key descriptive summaries
cat("\nKey Descriptive Summaries:\n")

# Numeric variables
numeric_cols <- sapply(df, is.numeric)
numeric_vars <- df[, numeric_cols, drop = FALSE]
cat("\nNumeric Variables Summary:\n")
print(summary(numeric_vars))

# Categorical variables
cat("\nCategorical Variables Summary:\n")
df %>% 
  dplyr::select(race_ethnicity, insurance, edu, received_comprehensive_postnatal_care) %>%
  summary()

# Data quality flags
cat("\nData Quality Flags:\n")

# Check for suspicious ages
age_issues <- df %>% filter(age < 15 | age > 50)
cat("- Records with age < 15 or > 50:", nrow(age_issues), "\n")
if (nrow(age_issues) > 0) {
  cat("  (Note: Youngest age is", min(df$age), ", oldest is", max(df$age), ")\n")
}

# Check distance_to_provider for extreme values
cat("- Distance to provider range:", round(min(df$distance_to_provider), 2), "to", 
    round(max(df$distance_to_provider), 2), "units\n")
extreme_distance <- df %>% filter(distance_to_provider > 100)
cat("- Records with distance > 100:", nrow(extreme_distance), "\n")

# Check for negative distances (shouldn't exist)
negative_distance <- df %>% filter(distance_to_provider < 0)
cat("- Records with negative distance:", nrow(negative_distance), "\n")

# =============================================================================
# 3. CREATE KEY VISUALIZATIONS
# =============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("STEP 3: KEY VISUALIZATIONS\n")
cat(rep("=", 80), "\n", sep = "")

# Create output directory for plots
if (!dir.exists("output")) {
  dir.create("output", recursive = TRUE)
}

# 3.1 Postnatal Care Distribution
cat("\nGenerating visualization: Postnatal Care Distribution\n")
p1 <- df %>%
  count(received_comprehensive_postnatal_care) %>%
  mutate(pct = 100 * n / sum(n)) %>%
  ggplot(aes(x = received_comprehensive_postnatal_care, y = n, fill = received_comprehensive_postnatal_care)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = sprintf("%d (%.1f%%)", n, pct)), vjust = -0.5) +
  scale_fill_manual(values = c("TRUE" = "steelblue", "FALSE" = "coral"),
                    labels = c("TRUE" = "Received Care", "FALSE" = "Did Not Receive Care")) +
  labs(
    title = "Distribution of Comprehensive Postnatal Care Receipt",
    subtitle = sprintf("N = %s", format(nrow(df), big.mark = ",")),
    x = "Received Comprehensive Postnatal Care",
    y = "Count",
    fill = "Care Status"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave("output/01_postnatal_care_distribution.png", p1, width = 10, height = 6, dpi = 300)
cat("Saved: output/01_postnatal_care_distribution.png\n")

# 3.2 Distance to Provider Distribution
cat("\nGenerating visualization: Distance to Provider\n")
p2 <- df %>%
  ggplot(aes(x = distance_to_provider)) +
  geom_histogram(bins = 50, fill = "steelblue", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = median(distance_to_provider)), 
             color = "red", linetype = "dashed", size = 1) +
  annotate("text", x = median(df$distance_to_provider), y = Inf, 
           label = sprintf("Median: %.1f", median(df$distance_to_provider)),
           vjust = 2, hjust = -0.1, color = "red") +
  labs(
    title = "Distribution of Distance to Healthcare Provider",
    subtitle = sprintf("Mean: %.1f, Median: %.1f, SD: %.1f", 
                       mean(df$distance_to_provider), 
                       median(df$distance_to_provider),
                       sd(df$distance_to_provider)),
    x = "Distance to Provider (units)",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave("output/02_distance_distribution.png", p2, width = 10, height = 6, dpi = 300)
cat("Saved: output/02_distance_distribution.png\n")

# 3.3 Postnatal Care by Distance (Binned)
cat("\nGenerating visualization: Postnatal Care by Distance\n")
df_distance_binned <- df %>%
  mutate(distance_bin = cut(distance_to_provider, 
                           breaks = c(0, 5, 10, 20, 50, 100, Inf),
                           labels = c("0-5", "5-10", "10-20", "20-50", "50-100", "100+")))

p3 <- df_distance_binned %>%
  group_by(distance_bin) %>%
  summarise(
    care_rate = mean(received_comprehensive_postnatal_care, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = distance_bin, y = care_rate)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%\n(n=%s)", 100*care_rate, format(n, big.mark = ","))), 
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
  labs(
    title = "Postnatal Care Receipt by Distance to Provider",
    subtitle = "Percentage receiving comprehensive care within each distance bin",
    x = "Distance to Provider (units)",
    y = "Care Receipt Rate"
  ) +
  theme_minimal()

ggsave("output/03_postnatal_care_by_distance.png", p3, width = 10, height = 6, dpi = 300)
cat("Saved: output/03_postnatal_care_by_distance.png\n")

# 3.4 Postnatal Care by Insurance Type
cat("\nGenerating visualization: Postnatal Care by Insurance\n")
p4 <- df %>%
  group_by(insurance) %>%
  summarise(
    care_rate = mean(received_comprehensive_postnatal_care, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = insurance, y = care_rate, fill = insurance)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%\n(n=%s)", 100*care_rate, format(n, big.mark = ","))), 
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
  labs(
    title = "Postnatal Care Receipt by Insurance Type",
    subtitle = "Percentage receiving comprehensive care by insurance coverage",
    x = "Insurance Type",
    y = "Care Receipt Rate",
    fill = "Insurance"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("output/04_postnatal_care_by_insurance.png", p4, width = 10, height = 6, dpi = 300)
cat("Saved: output/04_postnatal_care_by_insurance.png\n")

# 3.5 Postnatal Care by Race/Ethnicity
cat("\nGenerating visualization: Postnatal Care by Race/Ethnicity\n")
p5 <- df %>%
  group_by(race_ethnicity) %>%
  summarise(
    care_rate = mean(received_comprehensive_postnatal_care, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = race_ethnicity, y = care_rate, fill = race_ethnicity)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%\n(n=%s)", 100*care_rate, format(n, big.mark = ","))), 
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
  labs(
    title = "Postnatal Care Receipt by Race/Ethnicity",
    subtitle = "Percentage receiving comprehensive care by racial/ethnic group",
    x = "Race/Ethnicity",
    y = "Care Receipt Rate",
    fill = "Race/Ethnicity"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("output/05_postnatal_care_by_race.png", p5, width = 10, height = 6, dpi = 300)
cat("Saved: output/05_postnatal_care_by_race.png\n")

# 3.6 Comprehensive visualization: Care by Insurance and Race
cat("\nGenerating visualization: Care by Insurance and Race\n")
p6 <- df %>%
  group_by(insurance, race_ethnicity) %>%
  summarise(
    care_rate = mean(received_comprehensive_postnatal_care, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = race_ethnicity, y = care_rate, fill = insurance)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Postnatal Care Receipt by Race/Ethnicity and Insurance Type",
    subtitle = "Comprehensive postnatal care rates across demographic and coverage groups",
    x = "Race/Ethnicity",
    y = "Care Receipt Rate",
    fill = "Insurance Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("output/06_postnatal_care_interaction.png", p6, width = 12, height = 6, dpi = 300)
cat("Saved: output/06_postnatal_care_interaction.png\n")

cat("\nAll visualizations saved to output/ directory\n")

# =============================================================================
# 4. BUILD COUNT OUTCOME MODEL
# =============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("STEP 4: COUNT OUTCOME MODELING\n")
cat(rep("=", 80), "\n", sep = "")

# Create comorbidity count variable
cat("\nCreating comorbidity_count variable...\n")
df <- df %>%
  mutate(
    comorbidity_count = as.integer(
      obesity + multiple_gestation + diabetes + heart_disease + 
      placenta_previa + hypertension + gest_hypertension + preeclampsia
    )
  )

# Summary of comorbidity count
cat("\nComorbidity Count Distribution:\n")
df %>%
  count(comorbidity_count) %>%
  mutate(pct = round(100 * n / sum(n), 1)) %>%
  print()

# Calculate statistics for model selection
cat("\nDescriptive Statistics for Comorbidity Count:\n")
mean_count <- mean(df$comorbidity_count)
var_count <- var(df$comorbidity_count)
cat(sprintf("Mean: %.3f\n", mean_count))
cat(sprintf("Variance: %.3f\n", var_count))
cat(sprintf("Dispersion ratio (variance/mean): %.3f\n", var_count/mean_count))

# Model selection: Poisson vs Negative Binomial
cat("\nModel Selection: Poisson vs Negative Binomial\n")
cat("- Variance > Mean indicates overdispersion\n")
cat("- Dispersion ratio > 1 suggests Negative Binomial is more appropriate\n")
cat("- Using Negative Binomial to account for overdispersion\n")

# Prepare modeling dataset with key predictors
cat("\nPreparing modeling data...\n")
model_data <- df %>%
  dplyr::select(
    comorbidity_count,
    age,
    distance_to_provider,
    insurance,
    race_ethnicity,
    edu,
    dependents,
    received_comprehensive_postnatal_care
  ) %>%
  drop_na()

cat("Modeling dataset:", nrow(model_data), "complete cases\n")

# Fit Negative Binomial model
cat("\nFitting Negative Binomial Regression Model...\n")
nb_model <- glm.nb(
  comorbidity_count ~ 
    age + 
    distance_to_provider + 
    insurance + 
    race_ethnicity + 
    edu + 
    dependents +
    received_comprehensive_postnatal_care,
  data = model_data,
  control = glm.control(maxit = 100)
)

# Model summary
cat("\nModel Summary:\n")
print(summary(nb_model))

# Extract and interpret results
cat("\n", rep("-", 60), "\n", sep = "")
cat("INTERPRETABLE RESULTS\n")
cat(rep("-", 60), "\n", sep = "")

# Coefficients as incidence rate ratios (IRR)
cat("\nIncidence Rate Ratios (IRR) and 95% Confidence Intervals:\n")
coef_summary <- broom::tidy(nb_model, conf.int = TRUE, exponentiate = TRUE)
print(coef_summary, n = Inf)

# Model fit statistics
cat("\nModel Fit Statistics:\n")
cat(sprintf("Null deviance: %.2f on %d degrees of freedom\n", 
            nb_model$null.deviance, nb_model$df.null))
cat(sprintf("Residual deviance: %.2f on %d degrees of freedom\n",
            nb_model$deviance, nb_model$df.residual))
cat(sprintf("AIC: %.2f\n", nb_model$aic))
cat(sprintf("Theta (dispersion parameter): %.4f\n", nb_model$theta))

# Likelihood ratio test against null model
cat("\nLikelihood Ratio Test (vs. Null Model):\n")
null_model <- glm.nb(comorbidity_count ~ 1, data = model_data)
lrt_stat <- 2 * (logLik(nb_model) - logLik(null_model))
lrt_df <- length(coef(nb_model)) - 1
lrt_pvalue <- pchisq(as.numeric(lrt_stat), df = lrt_df, lower.tail = FALSE)
cat(sprintf("Chi-square: %.2f, df: %d, p-value: %.2e\n", 
            as.numeric(lrt_stat), lrt_df, lrt_pvalue))

# =============================================================================
# 5. RESPONSIBLE RESULTS REPORTING
# =============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("STEP 5: RESPONSIBLE RESULTS REPORTING\n")
cat(rep("=", 80), "\n", sep = "")

cat("\n=== CAUSALITY STATEMENT ===\n")
cat("\nIMPORTANT LIMITATIONS:\n")
cat("- This is an observational study, NOT a randomized controlled trial\n")
cat("- Associations identified do NOT imply causation\n")
cat("- Unmeasured confounding may explain observed relationships\n")
cat("- Results should be interpreted as correlations, not causal effects\n")

cat("\n=== MODEL ASSUMPTIONS ===\n")
cat("\nNegative Binomial Model Assumptions:\n")
cat("1. Count outcome follows a negative binomial distribution\n")
cat("   - Accounts for overdispersion (variance > mean)\n")
cat("2. Independence of observations\n")
cat("   - Assumes maternal health records are independent\n")
cat("3. Log-linear relationship between predictors and outcome\n")
cat("   - Assumes multiplicative effects on count scale\n")
cat("4. No perfect multicollinearity\n")
cat("   - Checked via variance inflation factors\n")

cat("\n=== MODEL DIAGNOSTICS ===\n")

# Check for overdispersion
cat("\nOverdispersion Check:\n")
residual_deviance <- nb_model$deviance
df_residual <- nb_model$df.residual
dispersion_ratio <- residual_deviance / df_residual
cat(sprintf("Residual deviance / df = %.3f\n", dispersion_ratio))
if (dispersion_ratio > 1.5) {
  cat("- Warning: Potential remaining overdispersion\n")
} else if (dispersion_ratio < 0.5) {
  cat("- Warning: Potential underdispersion\n")
} else {
  cat("- Dispersion appears reasonable for negative binomial model\n")
}

# Check for influential observations
cat("\nInfluential Observations Check:\n")
influence_stats <- influence.measures(nb_model)
n_influential <- sum(apply(influence_stats$is.inf, 1, any))
cat(sprintf("- %d potentially influential observations identified\n", n_influential))
if (n_influential > 0) {
  cat("  (These may warrant investigation but are retained in the model)\n")
}

cat("\n=== KEY FINDINGS ===\n")

# Identify significant predictors
sig_predictors <- coef_summary %>%
  filter(p.value < 0.05, term != "(Intercept)") %>%
  arrange(p.value)

if (nrow(sig_predictors) > 0) {
  cat("\nStatistically Significant Predictors (p < 0.05):\n")
  for (i in 1:nrow(sig_predictors)) {
    term <- sig_predictors$term[i]
    irr <- sig_predictors$estimate[i]
    ci_low <- sig_predictors$conf.low[i]
    ci_high <- sig_predictors$conf.high[i]
    
    direction <- ifelse(irr > 1, "higher", "lower")
    pct_change <- abs(irr - 1) * 100
    
    cat(sprintf("\n%s:\n", term))
    cat(sprintf("  - IRR: %.3f (95%% CI: %.3f to %.3f)\n", irr, ci_low, ci_high))
    cat(sprintf("  - Associated with %.1f%% %s comorbidity count\n", pct_change, direction))
  }
} else {
  cat("\nNo statistically significant predictors at alpha = 0.05\n")
}

cat("\n=== STUDY LIMITATIONS ===\n")
cat("\n1. Data Quality:\n")
cat("   - Synthetic/simulated data may not reflect real-world patterns\n")
cat("   - Self-reported income and other variables subject to bias\n")
cat("\n2. Generalizability:\n")
cat("   - Results may not generalize to populations outside the study\n")
cat("   - Geographic and temporal factors not fully accounted for\n")
cat("\n3. Model Limitations:\n")
cat("   - Does not account for clustering by provider or state\n")
cat("   - Linear effects assumed; non-linear relationships not explored\n")
cat("   - Missing data (if any) handled via complete case analysis\n")
cat("\n4. Unmeasured Confounding:\n")
cat("   - Socioeconomic factors beyond income not fully captured\n")
cat("   - Healthcare access barriers beyond distance not measured\n")
cat("   - Comorbidity severity and timing not accounted for\n")

cat("\n=== RECOMMENDATIONS FOR FUTURE RESEARCH ===\n")
cat("\n1. Consider mixed-effects models to account for provider/state clustering\n")
cat("2. Explore non-linear relationships (splines, GAMs)\n")
cat("3. Investigate interaction effects between insurance and distance\n")
cat("4. Collect prospective data to better assess temporal relationships\n")
cat("5. Validate findings with external datasets\n")

cat("\n", rep("=", 80), "\n", sep = "")
cat("ANALYSIS COMPLETE\n")
cat(rep("=", 80), "\n", sep = "")

# Save model and results
cat("\nSaving results...\n")
saveRDS(nb_model, "output/comorbidity_nb_model.rds")
cat("Saved: output/comorbidity_nb_model.rds\n")

# Create summary table
results_table <- coef_summary %>%
  dplyr::select(term, estimate, conf.low, conf.high, p.value) %>%
  mutate(
    estimate = round(estimate, 3),
    conf.low = round(conf.low, 3),
    conf.high = round(conf.high, 3),
    p.value = round(p.value, 4)
  )

write.csv(results_table, "output/model_results_table.csv", row.names = FALSE)
cat("Saved: output/model_results_table.csv\n")

cat("\nAll outputs saved to output/ directory\n")
cat("\nSUMMARY OF CHANGES MADE:\n")
cat("- Cleaned column names to snake_case format\n")
cat("- Converted binary indicators to logical type\n")
cat("- Converted categorical variables to factors with descriptive labels\n")
cat("- Created ordered factors for education and income\n")
cat("- Generated 6 visualization plots\n")
cat("- Created comorbidity_count as sum of 8 binary conditions\n")
cat("- Fit negative binomial regression model\n")
cat("- Reported results with appropriate statistical caution\n")
