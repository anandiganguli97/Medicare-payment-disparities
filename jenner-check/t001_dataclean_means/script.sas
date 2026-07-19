/* Mock provider-level input matching the columns Medicare_study.sas reads from
   Health_data_comp (raw CSV import -> all character, as PROC IMPORT yields).
   Each specialty spans both rural(1) and urban(0) so the specialty*rural GLM
   interaction and Tukey groupings are estimable. */
DATA Health_data_comp;
    LENGTH prop_rural_status $5 pri_spec $30
           avg_final_score tot_mdcr_alowd_amt
           bene_cc_ph_asthma_v2_pct bene_cc_ph_afib_v2_pct bene_cc_ph_cancer6_v2_pct
           bene_cc_ph_ckd_v2_pct bene_cc_ph_copd_v2_pct bene_cc_ph_diabetes_v2_pct
           bene_cc_ph_hf_nonihd_v2_pct bene_cc_ph_hyperlipidemia_v2_pct
           bene_cc_ph_hypertension_v2_pct bene_cc_ph_ischemic_heart_v2_pct
           bene_cc_ph_osteoporosis_v2_pct bene_cc_ph_parkinson_v2_pct $8;
    INFILE DATALINES DSD DLM='|' TRUNCOVER;
    INPUT prop_rural_status $ pri_spec $ avg_final_score $ tot_mdcr_alowd_amt $
          bene_cc_ph_asthma_v2_pct $ bene_cc_ph_afib_v2_pct $ bene_cc_ph_cancer6_v2_pct $
          bene_cc_ph_ckd_v2_pct $ bene_cc_ph_copd_v2_pct $ bene_cc_ph_diabetes_v2_pct $
          bene_cc_ph_hf_nonihd_v2_pct $ bene_cc_ph_hyperlipidemia_v2_pct $
          bene_cc_ph_hypertension_v2_pct $ bene_cc_ph_ischemic_heart_v2_pct $
          bene_cc_ph_osteoporosis_v2_pct $ bene_cc_ph_parkinson_v2_pct $;
    DATALINES;
1|Family Practice|80.1|33420.15|8.8|9.7|3.1|12.1|8.4|25.9|5.6|42.1|59.7|15.1|10.4|2.3
1|Family Practice|81.3|35100.00|8.4|9.4|3.6|11.8|8.1|25.3|5.4|41.7|59.1|14.9|10.1|2.2
1|Family Practice|79.5|34220.15|8.9|9.9|3.2|12.4|8.6|26.1|5.7|42.3|59.9|15.4|10.6|2.4
0|Family Practice|82.4|46250.75|8.2|9.1|3.4|11.5|7.8|24.6|5.2|41.3|58.9|14.7|9.8|2.1
0|Family Practice|80.8|45560.45|8.6|9.6|3.5|12.0|8.3|25.7|5.5|41.9|59.4|15.0|10.2|2.3
0|Family Practice|81.0|47010.30|8.5|9.5|3.3|11.9|8.0|25.1|5.3|41.5|59.0|14.8|10.0|2.2
1|Internal Medicine|78.9|44310.10|9.5|10.2|4.1|13.2|9.1|27.8|6.1|43.9|61.4|16.2|11.3|2.4
1|Internal Medicine|77.6|43620.80|9.2|10.6|4.4|12.8|8.9|26.7|6.3|42.7|60.2|15.9|10.9|2.5
1|Internal Medicine|78.2|45110.20|9.4|10.4|4.2|13.0|9.0|27.1|6.2|43.1|60.6|16.4|11.1|2.5
0|Internal Medicine|83.2|59850.90|7.4|11.8|6.3|10.1|7.3|24.9|7.1|42.4|60.8|18.1|8.9|2.1
0|Internal Medicine|82.7|58420.35|7.6|12.1|6.7|10.4|7.5|25.2|7.4|42.9|61.3|18.4|9.2|2.2
0|Internal Medicine|83.0|60110.50|7.5|11.9|6.5|10.2|7.4|25.0|7.2|42.6|61.0|18.2|9.0|2.1
1|Cardiology|84.0|71840.50|7.5|15.4|8.6|10.9|7.0|23.7|9.2|44.3|62.9|24.4|8.2|1.9
1|Cardiology|83.6|70650.40|7.7|15.1|8.4|11.1|7.2|24.0|9.4|44.6|63.2|24.7|8.4|2.0
1|Cardiology|84.2|72110.30|7.4|15.6|8.8|10.8|6.9|23.5|9.1|44.1|62.7|24.2|8.1|1.9
0|Cardiology|85.7|86420.60|7.1|15.8|9.2|10.9|6.9|23.4|9.4|44.6|63.1|24.7|8.1|1.9
0|Cardiology|86.4|88300.70|6.9|16.2|8.8|11.2|7.1|24.1|9.7|45.2|64.3|25.9|8.4|2.0
0|Cardiology|85.9|87750.80|7.3|15.4|9.6|10.6|6.7|23.1|9.1|44.1|62.7|24.2|8.3|1.9
1|Hematology/Oncology|90.2|118600.25|6.7|11.3|18.9|9.4|6.2|22.1|6.8|39.7|55.2|17.3|7.4|1.8
1|Hematology/Oncology|89.6|116310.30|6.5|11.1|18.2|9.7|6.0|22.8|6.6|39.2|54.9|17.1|7.6|1.8
1|Hematology/Oncology|90.6|119200.15|6.3|10.9|19.7|9.1|5.8|21.6|6.4|38.9|54.1|16.8|7.1|1.7
0|Hematology/Oncology|91.2|130900.40|6.7|11.3|18.9|9.4|6.2|22.1|6.8|39.7|55.2|17.3|7.4|1.8
0|Hematology/Oncology|92.8|135200.15|6.3|10.9|19.7|9.1|5.8|21.6|6.4|38.9|54.1|16.8|7.1|1.7
0|Hematology/Oncology|90.6|132600.25|6.5|11.1|18.2|9.7|6.0|22.8|6.6|39.2|54.9|17.1|7.6|1.8
;
RUN;

/* ---- From Medicare_study.sas: PROC CONTENTS + cleaning DATA step + PROC MEANS validation ---- */
PROC CONTENTS DATA=Health_data_comp;
RUN;

DATA mips_clean;
    SET Health_data_comp;

    /* Fix Rural Status Encoding */
    IF prop_rural_status = "1" THEN prop_rural_num = 1;  /* Rural */
    ELSE IF prop_rural_status = "0" THEN prop_rural_num = 0;  /* Urban */
    ELSE prop_rural_num = .;  /* Assign missing if blank */

    /* Convert Medicare Payments to Numeric */
    IF tot_mdcr_alowd_amt NE "" THEN
        tot_mdcr_alowd_amt_num = INPUT(tot_mdcr_alowd_amt, BEST12.);
    ELSE tot_mdcr_alowd_amt_num = .; /* Handle blanks in Medicare payments */

    KEEP prop_rural_num tot_mdcr_alowd_amt_num;
RUN;

/* Validate Data Cleaning */
PROC MEANS DATA=mips_clean N MEAN STD MIN MAX;
RUN;
