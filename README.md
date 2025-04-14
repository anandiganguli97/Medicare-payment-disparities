# 💵Who Gets Paid More? A Deep Dive into Medicare Gaps by Provider Specialty & Location

**An analysis of Medicare payment patterns using R, SAS, and SQL, highlighting disparities across provider specialties and rural/urban regions.**  
_By Anandi Ganguli • Feb 2024_

---
> 🧪 **Tech Stack:** SAS (Main Branch) · R (Branch: [`R`](https://github.com/anandiganguli97/Medicare-payment-disparities/tree/R)) · SQL (Branch: [`SQL`](https://github.com/anandiganguli97/Medicare-payment-disparities/tree/SQL))


## 📌 Project Overview

This project investigates disparities in Medicare reimbursement using provider-level data. Specifically, it examines:

- Whether **rural providers** receive lower Medicare payments than their urban counterparts
- How **chronic disease burden** correlates with allowed payment amounts
- The **impact of provider specialty** on Medicare reimbursement, including specialty-wise variation
- Differences in findings across **SAS and R**, with SQL used for data manipulation and aggregation

🔬 **Methods:** Statistical modeling, t-tests, regression (with interaction terms), and specialty-specific payment profiling  
🛠️ **Tools:** R, SAS, SQL (PROC SQL, PostgreSQL-style queries), ggplot2, PROC SGPLOT  
📂 **Status:** Completed (Feb 2024)

---

## 📁 File Structure

| File Name                      | Description |
|-------------------------------|-------------|
| **`Medicare_study.R`** _(in `R` branch)_ | Full R script with data cleaning, modeling, and visualization |
| `Medicare_study.sas`          | Equivalent SAS code for full workflow |
| SAS Plots (.png)              | Final plots for rural/urban comparison and top/bottom specialties (in `SAS` branch) |
| `medicare_analysis_queries.sql` _(in `SQL` branch)_ | SQL queries for summary stats and grouping |
| `Executive Summary_IHDC.docx` | Summary of key methods and takeaways (main branch) |
| `README.md`                   | You're here! |

---

## 🔍 Key Findings

### 💡 Rural vs. Urban Disparities
- Urban providers received **significantly higher** average Medicare payments than rural providers.
- The **difference was statistically significant (p < 0.001)** in both SAS and R, though numeric values slightly varied due to data type handling defaults.

### 🩺 Chronic Disease Insights
- Chronic conditions such as **cancer, Parkinson’s, and hypertension** were positively associated with higher payments.
- Asthma and atrial fibrillation were associated with **lower reimbursement**, suggesting potential underfunding in chronic disease management.

### 🧐 Specialty-Level Variation
- Provider specialty had the **strongest association** with payment amount.
- Specialties like **Hematology/Oncology**, **Radiation Oncology**, and **Hyperbaric Medicine** received the highest reimbursements.
- Primary care and rehabilitative services were among the **lowest compensated** despite high utilization.

---

## 📊 Visuals

Plots were generated in both R and SAS.  
🔶 SAS plots were cleaner and better labeled, used in the main findings.  

📌 **See plots (in `SAS` branch):**
- `avg-payment-urban vs rural.png`
- `top 20 payments_by provider spl.png`
- `bottom 20_payments_by provider spl.png`

---

## ⚙️ SQL Logic (Summary)

SQL was used for:
- Grouping and averaging payments by provider specialty
- Identifying top and bottom 20 specialties by mean payment
- Performing similar transformations as in SAS `PROC SQL` for comparison

See [`medicare_analysis_queries.sql`](../SQL/medicare_analysis_queries.sql) in the `SQL` branch for annotated SQL logic.

---

## 😔 Real-World Applications

This project reflects real disparities in how Medicare reimburses providers. Implications include:

- 🏥 **Access Equity**: Rural providers may be under-compensated despite serving harder-to-reach populations
- 🧓 **Chronic Care Resources**: Conditions like Parkinson’s and cancer drive higher costs, highlighting gaps in preventive care
- 💸 **Reimbursement Justice**: Low-paying specialties (e.g., family medicine) deserve revisiting in CMS payment formulas
- 📊 **Policy Optimization**: Supports refining MIPS, benchmarking, and value-based care models

This analysis supports **data-informed health policy reform** to ensure equitable resource allocation and sustainable care delivery across the U.S.

---

## 👍 Why Both R and SAS?

- **SAS**: Robust healthcare industry standard; offered cleaner output and easier control over graphs.
- **R**: Great for reproducibility, GitHub sharing, and open-source modeling.
- **SQL**: Used for backend aggregations and data joins—core for large-scale CMS data.

> 🔄 Differences between R and SAS arose primarily due to how missing values and strings were handled during type conversion and grouping—not from logic discrepancies.

---

## 📌 Disclaimer

The dataset used in this project is **confidential** and was accessed as part of a private consulting analysis. Hence, it is **not shared publicly** in this repository.

---

## 🧑‍💼 Author

**Anandi Ganguli**  
MPH Candidate – University of Minnesota  

