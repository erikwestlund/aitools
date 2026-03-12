library(dplyr)
library(readr)

set.seed(42)
n <- 25

# id: 1 to 25
id <- 1:n

# provider_id: range 3-20, mean ~10, median ~9, right-skewed
# target: mean=9.96, median=9, SD=5.2, range 3-20
provider_id <- c(3, 4, 5, 5, 6, 6, 7, 8, 8, 9, 9, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 20)

# state: MD=11, VA=8, DC=6
state <- sample(c(rep("MD", 11), rep("VA", 8), rep("DC", 6)))

# received_comprehensive_postnatal_care: binary, mean=0.54, 1 missing
# 24 non-missing values, ~54% = 13 ones, 11 zeros
care_vals <- c(rep(1, 13), rep(0, 11))
care_pos <- sample(1:n, 24)
received_comprehensive_postnatal_care <- rep(NA_real_, n)
received_comprehensive_postnatal_care[care_pos] <- sample(care_vals)

# self_report_income: 6 levels with specific counts, 1 missing
income_levels <- c(
  rep("$50,000-$74,999", 8),
  rep("$25,000-$49,999", 6),
  rep("$75,000-$99,999", 5),
  rep("$10,000-$24,999", 2),
  rep("$100,000+", 2),
  rep("<$10,000", 1)
)
self_report_income <- rep(NA_character_, n)
income_pos <- sample(1:n, 24)
self_report_income[income_pos] <- sample(income_levels)

# age: range 19-41, mean ~29.25, median ~29.5, SD ~5.65, 1 missing
# Hand-pick 24 values that hit the targets
# target: mean=29.25, median=29.5, SD=5.65, range 19-41
age_vals <- c(19, 21, 23, 24, 25, 26, 27, 27, 28, 28, 29, 29,
              30, 30, 31, 31, 32, 33, 34, 37, 39, 39, 39, 41)
age <- rep(NA_real_, n)
age_pos <- sample(1:n, 24)
age[age_pos] <- sample(age_vals)

# edu: bachelors=11, some_college=6, hs=5, masters=3
edu <- sample(c(rep("bachelors", 11), rep("some_college", 6), rep("hs", 5), rep("masters", 3)))

# race_ethnicity: white=10, black=6, asian=4, hispanic=4, other=1
race_ethnicity <- sample(c(
  rep("white", 10), rep("black", 6), rep("asian", 4),
  rep("hispanic", 4), rep("other", 1)
))

# insurance: private=14, medicaid=9, no_insurance=2
insurance <- sample(c(rep("private", 14), rep("medicaid", 9), rep("no_insurance", 2)))

# job_type: professional=10, skilled=6, unskilled=6, unemployed=3
job_type <- sample(c(
  rep("professional", 10), rep("skilled", 6),
  rep("unskilled", 6), rep("unemployed", 3)
))

# dependents: range 0-4, mean ~1.24, median 1, SD ~1.05
# target: mean=1.24, median=1, SD=1.05, range 0-4
dependents_vals <- c(rep(0, 7), rep(1, 9), rep(2, 5), rep(3, 3), rep(4, 1))
dependents <- sample(dependents_vals)

# distance_to_provider: range 1.8-44.1, mean ~14, median ~9.2, right-skewed
# target: mean=13.97, median=9.2, SD=11.82, range 1.8-44.1
distance_to_provider <- c(
  1.8, 2.5, 3.1, 4.0, 5.0, 5.8, 6.5, 7.2, 8.0, 8.8,
  9.2, 9.5, 10.0, 11.0, 12.5, 14.0, 17.0, 20.0, 24.0, 27.0,
  30.0, 33.0, 37.0, 41.0, 44.1
)
distance_to_provider <- sample(distance_to_provider)

# Binary health conditions
obesity <- sample(c(rep(1, 5), rep(0, 20)))
multiple_gestation <- sample(c(rep(1, 1), rep(0, 24)))
diabetes <- sample(c(rep(1, 3), rep(0, 22)))
heart_disease <- rep(0, n)
placenta_previa <- rep(0, n)
hypertension <- sample(c(rep(1, 7), rep(0, 18)))
gest_hypertension <- sample(c(rep(1, 3), rep(0, 22)))
preeclampsia <- sample(c(rep(1, 1), rep(0, 24)))

df <- tibble(
  id, provider_id, state,
  received_comprehensive_postnatal_care,
  self_report_income, age, edu, race_ethnicity,
  insurance, job_type, dependents, distance_to_provider,
  obesity, multiple_gestation, diabetes, heart_disease,
  placenta_previa, hypertension, gest_hypertension, preeclampsia
)

# Verify
cat("Rows:", nrow(df), "\n")
cat("Age - Mean:", round(mean(df$age, na.rm = TRUE), 2),
    "Median:", median(df$age, na.rm = TRUE),
    "SD:", round(sd(df$age, na.rm = TRUE), 2), "\n")
cat("Provider ID - Mean:", round(mean(df$provider_id), 2),
    "Median:", median(df$provider_id),
    "SD:", round(sd(df$provider_id), 2), "\n")
cat("Distance - Mean:", round(mean(df$distance_to_provider), 2),
    "Median:", median(df$distance_to_provider),
    "SD:", round(sd(df$distance_to_provider), 2), "\n")
cat("Care - Mean:", round(mean(df$received_comprehensive_postnatal_care, na.rm = TRUE), 2),
    "Missing:", sum(is.na(df$received_comprehensive_postnatal_care)), "\n")
cat("Dependents - Mean:", round(mean(df$dependents), 2),
    "Median:", median(df$dependents),
    "SD:", round(sd(df$dependents), 2), "\n")

write_csv(df, "simulated_maternal_health_data.csv")
cat("\nSaved to simulated_maternal_health_data.csv\n")
