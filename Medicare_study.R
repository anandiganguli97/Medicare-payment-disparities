# ----------------------------------
# Medicare Data Analysis in R
# ----------------------------------

# Load necessary libraries
library(tidyverse)
library(broom)
library(ggplot2)
library(forcats)

# Load dataset
health_data <- read.csv("C:/Users/anand/Downloads/Health_data_comp.csv", stringsAsFactors = FALSE)

# Clean and convert variables
mips_clean <- health_data %>%
  mutate(
    # Recode rural status
    prop_rural_num = case_when(
      prop_rural_status == "1" ~ 1,
      prop_rural_status == "0" ~ 0,
      TRUE ~ NA_real_
    ),
    # Numeric conversions
    avg_final_score_num = as.numeric(avg_final_score),
    tot_mdcr_alowd_amt_num = as.numeric(gsub(",", "", tot_mdcr_alowd_amt)),
    bene_cc_ph_asthma_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_asthma_v2_pct)),
    bene_cc_ph_afib_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_afib_v2_pct)),
    bene_cc_ph_cancer6_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_cancer6_v2_pct)),
    bene_cc_ph_ckd_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_ckd_v2_pct)),
    bene_cc_ph_copd_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_copd_v2_pct)),
    bene_cc_ph_diabetes_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_diabetes_v2_pct)),
    bene_cc_ph_hf_nonihd_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_hf_nonihd_v2_pct)),
    bene_cc_ph_hyperlipidemia_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_hyperlipidemia_v2_pct)),
    bene_cc_ph_hypertension_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_hypertension_v2_pct)),
    bene_cc_ph_ischemic_heart_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_ischemic_heart_v2_pct)),
    bene_cc_ph_osteoporosis_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_osteoporosis_v2_pct)),
    bene_cc_ph_parkinson_v2_pct_num = as.numeric(gsub(",", "", bene_cc_ph_parkinson_v2_pct)),
    pri_spec_clean = as.factor(pri_spec)
  ) %>%
  filter(!is.na(prop_rural_num), !is.na(tot_mdcr_alowd_amt_num))

# Summary statistics
summary(mips_clean$tot_mdcr_alowd_amt_num)
summary(mips_clean$avg_final_score_num)

# T-test for Medicare payments
t_test <- t.test(tot_mdcr_alowd_amt_num ~ prop_rural_num, data = mips_clean)
print(t_test)

# T-tests for chronic disease prevalence
disease_vars <- mips_clean %>%
  select(starts_with("bene_cc")) %>% names()

ttest_results <- lapply(disease_vars, function(var) {
  t.test(mips_clean[[var]] ~ mips_clean$prop_rural_num)
})

# Linear regression model
lm_model <- lm(tot_mdcr_alowd_amt_num ~ prop_rural_num + avg_final_score_num +
                 bene_cc_ph_asthma_v2_pct_num + bene_cc_ph_afib_v2_pct_num + bene_cc_ph_cancer6_v2_pct_num +
                 bene_cc_ph_ckd_v2_pct_num + bene_cc_ph_copd_v2_pct_num + bene_cc_ph_diabetes_v2_pct_num +
                 bene_cc_ph_hf_nonihd_v2_pct_num + bene_cc_ph_hyperlipidemia_v2_pct_num +
                 bene_cc_ph_hypertension_v2_pct_num + bene_cc_ph_ischemic_heart_v2_pct_num +
                 bene_cc_ph_osteoporosis_v2_pct_num + bene_cc_ph_parkinson_v2_pct_num,
               data = mips_clean
)
summary(lm_model)

# Interaction model
mips_clean <- mips_clean %>%
  mutate(
    rural_asthma_interaction = prop_rural_num * bene_cc_ph_asthma_v2_pct_num,
    rural_copd_interaction = prop_rural_num * bene_cc_ph_copd_v2_pct_num
  )

interaction_model <- lm(tot_mdcr_alowd_amt_num ~ prop_rural_num + bene_cc_ph_asthma_v2_pct_num +
                          bene_cc_ph_copd_v2_pct_num + rural_asthma_interaction + rural_copd_interaction,
                        data = mips_clean
)
summary(interaction_model)

# Provider specialty model
df_clean <- mips_clean %>% filter(!is.na(pri_spec_clean))
spec_model <- lm(tot_mdcr_alowd_amt_num ~ prop_rural_num * pri_spec_clean, data = df_clean)
summary(spec_model)

# Top 20 specialties by payment
top_specialties <- df_clean %>%
  group_by(pri_spec_clean) %>%
  summarise(avg_payment = mean(tot_mdcr_alowd_amt_num, na.rm = TRUE)) %>%
  arrange(desc(avg_payment)) %>%
  slice_head(n = 20)

# Bottom 20 specialties
bottom_specialties <- df_clean %>%
  group_by(pri_spec_clean) %>%
  summarise(avg_payment = mean(tot_mdcr_alowd_amt_num, na.rm = TRUE)) %>%
  arrange(avg_payment) %>%
  slice_head(n = 20)

# Bar plots for rural/urban
ggplot(mips_clean, aes(x = factor(prop_rural_num), y = tot_mdcr_alowd_amt_num)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Medicare Payments by Rural Status", x = "Urban (0) vs Rural (1)", y = "Medicare Payments")

# Plot for top specialties
ggplot(top_specialties, aes(x = reorder(pri_spec_clean, avg_payment), y = avg_payment)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(
    title = "Top 20 Provider Specialties by Average Medicare Payment",
    x = "Provider Specialty",
    y = "Average Medicare Payment"
  )

# Plot for bottom specialties
ggplot(bottom_specialties, aes(x = reorder(pri_spec_clean, avg_payment), y = avg_payment)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Bottom 20 Provider Specialties by Average Medicare Payment",
       x = "Provider Specialty", y = "Average Medicare Payment")


