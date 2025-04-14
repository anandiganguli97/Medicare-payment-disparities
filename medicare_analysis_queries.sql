
-- Medicare Analysis SQL Queries
-- Author: Anandi Ganguli
-- Description: These queries replicate key parts of the analysis conducted in SAS and R, using SQL.
-- They demonstrate skills in data aggregation, grouping, filtering, and ranking.

-- NOTE: These assume a cleaned dataset named 'mips_clean' with relevant numeric conversions.

-- 1. Top 20 Provider Specialties by Average Medicare Payment
SELECT pri_spec_clean,
       AVG(tot_mdcr_alowd_amt_num) AS avg_payment
FROM mips_clean
GROUP BY pri_spec_clean
ORDER BY avg_payment DESC
LIMIT 20;


-- 2. Bottom 20 Provider Specialties by Average Medicare Payment
SELECT pri_spec_clean,
       AVG(tot_mdcr_alowd_amt_num) AS avg_payment
FROM mips_clean
GROUP BY pri_spec_clean
ORDER BY avg_payment ASC
LIMIT 20;


-- 3. Average Medicare Payment by Rural Status (Urban = 0, Rural = 1)
SELECT prop_rural_num,
       AVG(tot_mdcr_alowd_amt_num) AS avg_payment
FROM mips_clean
GROUP BY prop_rural_num;


-- 4. Average Medicare Payment by Rural Status and Specialty (Optional Extension)
SELECT prop_rural_num,
       pri_spec_clean,
       AVG(tot_mdcr_alowd_amt_num) AS avg_payment
FROM mips_clean
GROUP BY prop_rural_num, pri_spec_clean
ORDER BY avg_payment DESC;


-- 5. Number of Observations by Specialty (To evaluate sample size before interpreting averages)
SELECT pri_spec_clean,
       COUNT(*) AS num_providers
FROM mips_clean
GROUP BY pri_spec_clean
ORDER BY num_providers DESC;
