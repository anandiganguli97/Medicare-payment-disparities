/*Importing data*/
proc import
DATAFILE = "/home/u63574590/Health_data_comp.csv"
OUT = Health_data_comp
DBMS = csv
REPLACE;
GETNAMES = yes;
/* Check variable types and structure */
PROC CONTENTS DATA=Health_data_comp;
RUN;

/* Data Cleaning and Variable Transformation */
DATA mips_clean;
    SET Health_data_comp;

    /* Convert Rural Status to Numeric (1 = Rural, 0 = Urban) */
    IF prop_rural_status = "Rural" THEN prop_rural_num = 1;
    ELSE IF prop_rural_status = "Urban" THEN prop_rural_num = 0;

    /* Convert MIPS Score to Numeric */
    avg_final_score_num = INPUT(avg_final_score, BEST12.);

    /* Convert Medicare Payments to Numeric */
    tot_mdcr_alowd_amt_num = INPUT(tot_mdcr_alowd_amt, BEST12.);

    /* Convert Chronic Disease Percentages to Numeric */
    bene_cc_ph_asthma_v2_num = INPUT(bene_cc_ph_asthma_v2_pct, BEST12.);
    bene_cc_ph_afib_v2_num = INPUT(bene_cc_ph_afib_v2_pct, BEST12.);
    bene_cc_ph_cancer6_v2_num = INPUT(bene_cc_ph_cancer6_v2_pct, BEST12.);
    bene_cc_ph_ckd_v2_num = INPUT(bene_cc_ph_ckd_v2_pct, BEST12.);
    bene_cc_ph_copd_v2_num = INPUT(bene_cc_ph_copd_v2_pct, BEST12.);
    bene_cc_ph_diabetes_v2_num = INPUT(bene_cc_ph_diabetes_v2_pct, BEST12.);
    bene_cc_ph_hf_nonihd_v2_num = INPUT(bene_cc_ph_hf_nonihd_v2_pct, BEST12.);
    bene_cc_ph_hyperlipidemia_v2_num = INPUT(bene_cc_ph_hyperlipidemia_v2_pct, BEST12.);
    bene_cc_ph_hypertension_v2_num = INPUT(bene_cc_ph_hypertension_v2_pct, BEST12.);
    bene_cc_ph_ischemic_heart_v2_num = INPUT(bene_cc_ph_ischemic_heart_v2_pct, BEST12.);
    bene_cc_ph_osteoporosis_v2_num = INPUT(bene_cc_ph_osteoporosis_v2_pct, BEST12.);
    bene_cc_ph_parkinson_v2_num = INPUT(bene_cc_ph_parkinson_v2_pct, BEST12.);

    /* Keep Only Relevant Numeric Variables */
    KEEP prop_rural_num avg_final_score_num tot_mdcr_alowd_amt_num
         bene_cc_ph_asthma_v2_num bene_cc_ph_afib_v2_num bene_cc_ph_cancer6_v2_num 
         bene_cc_ph_ckd_v2_num bene_cc_ph_copd_v2_num bene_cc_ph_diabetes_v2_num 
         bene_cc_ph_hf_nonihd_v2_num bene_cc_ph_hyperlipidemia_v2_num bene_cc_ph_hypertension_v2_num 
         bene_cc_ph_ischemic_heart_v2_num bene_cc_ph_osteoporosis_v2_num bene_cc_ph_parkinson_v2_num;
RUN;

/* Validate Data Cleaning */
PROC MEANS DATA=mips_clean N MEAN STD MIN MAX;
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
PROC FREQ DATA=mips_clean;
    TABLE prop_rural_num / MISSING;
    TITLE "Final Check: Rural Status Variable Distribution";
RUN;
/* T-Test to Compare Medicare Payments in Rural vs. Urban Providers */
PROC TTEST DATA=mips_clean;
    CLASS prop_rural_num;
    VAR tot_mdcr_alowd_amt_num;
    TITLE "T-Test: Medicare Payments in Rural vs. Urban Providers (Fixed)";
RUN;
/* T-Test to Compare Chronic Disease Prevalence in Rural vs. Urban Providers */
DATA mips_clean;
    SET Health_data_comp;

    /* Ensure Rural Status is Properly Assigned */
    IF prop_rural_status = "1" THEN prop_rural_num = 1;
    ELSE IF prop_rural_status = "0" THEN prop_rural_num = 0;
    ELSE prop_rural_num = .;  /* Assign missing if blank */

    /* Convert Chronic Disease Variables from Character to Numeric */
    bene_cc_ph_asthma_v2_num = INPUT(COMPRESS(bene_cc_ph_asthma_v2_pct), BEST12.);
    bene_cc_ph_afib_v2_num = INPUT(COMPRESS(bene_cc_ph_afib_v2_pct), BEST12.);
    bene_cc_ph_cancer6_v2_num = INPUT(COMPRESS(bene_cc_ph_cancer6_v2_pct), BEST12.);
    bene_cc_ph_ckd_v2_num = INPUT(COMPRESS(bene_cc_ph_ckd_v2_pct), BEST12.);
    bene_cc_ph_copd_v2_num = INPUT(COMPRESS(bene_cc_ph_copd_v2_pct), BEST12.);
    bene_cc_ph_diabetes_v2_num = INPUT(COMPRESS(bene_cc_ph_diabetes_v2_pct), BEST12.);
    bene_cc_ph_hf_nonihd_v2_num = INPUT(COMPRESS(bene_cc_ph_hf_nonihd_v2_pct), BEST12.);
    bene_cc_ph_hyperlipidemia_v2_num = INPUT(COMPRESS(bene_cc_ph_hyperlipidemia_v2_pct), BEST12.);
    bene_cc_ph_hypertension_v2_num = INPUT(COMPRESS(bene_cc_ph_hypertension_v2_pct), BEST12.);
    bene_cc_ph_ischemic_heart_v2_num = INPUT(COMPRESS(bene_cc_ph_ischemic_heart_v2_pct), BEST12.);
    bene_cc_ph_osteoporosis_v2_num = INPUT(COMPRESS(bene_cc_ph_osteoporosis_v2_pct), BEST12.);
    bene_cc_ph_parkinson_v2_num = INPUT(COMPRESS(bene_cc_ph_parkinson_v2_pct), BEST12.);

    /* Keep Only Relevant Numeric Variables */
    KEEP prop_rural_num bene_cc_ph_asthma_v2_num bene_cc_ph_afib_v2_num bene_cc_ph_cancer6_v2_num 
         bene_cc_ph_ckd_v2_num bene_cc_ph_copd_v2_num bene_cc_ph_diabetes_v2_num 
         bene_cc_ph_hf_nonihd_v2_num bene_cc_ph_hyperlipidemia_v2_num bene_cc_ph_hypertension_v2_num 
         bene_cc_ph_ischemic_heart_v2_num bene_cc_ph_osteoporosis_v2_num bene_cc_ph_parkinson_v2_num;
RUN;
PROC CONTENTS DATA=mips_clean;
RUN;

PROC MEANS DATA=mips_clean N MEAN STD MIN MAX;
RUN;
PROC TTEST DATA=mips_clean;
    CLASS prop_rural_num;
    VAR bene_cc_ph_asthma_v2_num bene_cc_ph_afib_v2_num bene_cc_ph_cancer6_v2_num 
        bene_cc_ph_ckd_v2_num bene_cc_ph_copd_v2_num bene_cc_ph_diabetes_v2_num 
        bene_cc_ph_hf_nonihd_v2_num bene_cc_ph_hyperlipidemia_v2_num bene_cc_ph_hypertension_v2_num 
        bene_cc_ph_ischemic_heart_v2_num bene_cc_ph_osteoporosis_v2_num bene_cc_ph_parkinson_v2_num;
    TITLE "T-Test: Chronic Disease Prevalence in Rural vs. Urban Providers (Fixed)";
RUN;
/* Regression Model: Predicting Medicare Payments Based on Chronic Disease Burden and Rural Status */
DATA mips_clean;
    SET Health_data_comp;

    /* Ensure Rural Status is Properly Assigned */
    IF prop_rural_status = "1" THEN prop_rural_num = 1;
    ELSE IF prop_rural_status = "0" THEN prop_rural_num = 0;
    ELSE prop_rural_num = .;  /* Assign missing if blank */

    /* Convert Medicare Payments from Character to Numeric */
    tot_mdcr_alowd_amt_num = INPUT(COMPRESS(tot_mdcr_alowd_amt), BEST12.);

    /* Convert Chronic Disease Variables from Character to Numeric */
    bene_cc_ph_asthma_v2_num = INPUT(COMPRESS(bene_cc_ph_asthma_v2_pct), BEST12.);
    bene_cc_ph_afib_v2_num = INPUT(COMPRESS(bene_cc_ph_afib_v2_pct), BEST12.);
    bene_cc_ph_cancer6_v2_num = INPUT(COMPRESS(bene_cc_ph_cancer6_v2_pct), BEST12.);
    bene_cc_ph_ckd_v2_num = INPUT(COMPRESS(bene_cc_ph_ckd_v2_pct), BEST12.);
    bene_cc_ph_copd_v2_num = INPUT(COMPRESS(bene_cc_ph_copd_v2_pct), BEST12.);
    bene_cc_ph_diabetes_v2_num = INPUT(COMPRESS(bene_cc_ph_diabetes_v2_pct), BEST12.);
    bene_cc_ph_hf_nonihd_v2_num = INPUT(COMPRESS(bene_cc_ph_hf_nonihd_v2_pct), BEST12.);
    bene_cc_ph_hyperlipidemia_v2_num = INPUT(COMPRESS(bene_cc_ph_hyperlipidemia_v2_pct), BEST12.);
    bene_cc_ph_hypertension_v2_num = INPUT(COMPRESS(bene_cc_ph_hypertension_v2_pct), BEST12.);
    bene_cc_ph_ischemic_heart_v2_num = INPUT(COMPRESS(bene_cc_ph_ischemic_heart_v2_pct), BEST12.);
    bene_cc_ph_osteoporosis_v2_num = INPUT(COMPRESS(bene_cc_ph_osteoporosis_v2_pct), BEST12.);
    bene_cc_ph_parkinson_v2_num = INPUT(COMPRESS(bene_cc_ph_parkinson_v2_pct), BEST12.);

    /* Keep Only Relevant Numeric Variables */
    KEEP prop_rural_num tot_mdcr_alowd_amt_num bene_cc_ph_asthma_v2_num bene_cc_ph_afib_v2_num bene_cc_ph_cancer6_v2_num 
         bene_cc_ph_ckd_v2_num bene_cc_ph_copd_v2_num bene_cc_ph_diabetes_v2_num 
         bene_cc_ph_hf_nonihd_v2_num bene_cc_ph_hyperlipidemia_v2_num bene_cc_ph_hypertension_v2_num 
         bene_cc_ph_ischemic_heart_v2_num bene_cc_ph_osteoporosis_v2_num bene_cc_ph_parkinson_v2_num;
RUN;
PROC MEANS DATA=mips_clean N MEAN STD MIN MAX;
    VAR tot_mdcr_alowd_amt_num;
RUN;
PROC REG DATA=mips_clean;
    MODEL tot_mdcr_alowd_amt_num = prop_rural_num bene_cc_ph_asthma_v2_num 
                                   bene_cc_ph_afib_v2_num bene_cc_ph_cancer6_v2_num 
                                   bene_cc_ph_ckd_v2_num bene_cc_ph_copd_v2_num 
                                   bene_cc_ph_diabetes_v2_num bene_cc_ph_hf_nonihd_v2_num 
                                   bene_cc_ph_hyperlipidemia_v2_num bene_cc_ph_hypertension_v2_num 
                                   bene_cc_ph_ischemic_heart_v2_num bene_cc_ph_osteoporosis_v2_num 
                                   bene_cc_ph_parkinson_v2_num;
    TITLE "Regression: Impact of Chronic Disease & Rural Status on Medicare Payments";
RUN;

DATA mips_clean;
    SET Health_data_comp;

    /* Convert Rural Status */
    IF prop_rural_status = "1" THEN prop_rural_num = 1;
    ELSE IF prop_rural_status = "0" THEN prop_rural_num = 0;
    ELSE prop_rural_num = .;  

    /* Convert Medicare Payments */
    tot_mdcr_alowd_amt_num = INPUT(COMPRESS(tot_mdcr_alowd_amt), BEST12.);

    /* Convert Chronic Disease Variables */
    bene_cc_ph_asthma_v2_num = INPUT(COMPRESS(bene_cc_ph_asthma_v2_pct), BEST12.);
    bene_cc_ph_copd_v2_num = INPUT(COMPRESS(bene_cc_ph_copd_v2_pct), BEST12.);

    /* Create Interaction Terms */
    rural_asthma_interaction = prop_rural_num * bene_cc_ph_asthma_v2_num;
    rural_copd_interaction = prop_rural_num * bene_cc_ph_copd_v2_num;

    /* Keep relevant variables */
    KEEP prop_rural_num tot_mdcr_alowd_amt_num bene_cc_ph_asthma_v2_num bene_cc_ph_copd_v2_num 
         rural_asthma_interaction rural_copd_interaction;
RUN;
PROC REG DATA=mips_clean;
    MODEL tot_mdcr_alowd_amt_num = prop_rural_num bene_cc_ph_asthma_v2_num bene_cc_ph_copd_v2_num 
                                   rural_asthma_interaction rural_copd_interaction;
    TITLE "Regression: Interaction Between Rural Status & Chronic Disease Burden on Medicare Payments";
RUN;

/* Bar Chart: Medicare Payments in Rural vs. Urban Providers */
PROC SGPLOT DATA=mips_clean;
    VBAR prop_rural_num / RESPONSE=tot_mdcr_alowd_amt_num 
        STAT=MEAN DATALABEL GROUPDISPLAY=CLUSTER;
    TITLE "Average Medicare Payments in Rural vs. Urban Providers";
    XAXIS LABEL="Urban (0) vs. Rural (1)";
    YAXIS LABEL="Average Medicare Payment";
RUN;

/* Box Plot: Chronic Disease Prevalence in Rural vs. Urban */
PROC SGPLOT DATA=mips_clean;
    VBOX tot_mdcr_alowd_amt_num / CATEGORY=prop_rural_num;
    TITLE "Medicare Payment Distribution in Rural vs. Urban Providers";
    XAXIS LABEL="Urban (0) vs. Rural (1)";
    YAXIS LABEL="Total Medicare Payments";
RUN;
/* Does provider spec explain diff in medicare payments*/
DATA mips_clean;
    SET Health_data_comp;

    /* Ensure Rural Status is Numeric */
    IF prop_rural_status = "1" THEN prop_rural_num = 1;
    ELSE IF prop_rural_status = "0" THEN prop_rural_num = 0;
    ELSE prop_rural_num = .;  

    /* Convert Medicare Payments */
    tot_mdcr_alowd_amt_num = INPUT(COMPRESS(tot_mdcr_alowd_amt), BEST12.);

    /* Convert Chronic Disease Variables */
    bene_cc_ph_asthma_v2_num = INPUT(COMPRESS(bene_cc_ph_asthma_v2_pct), BEST12.);
    bene_cc_ph_copd_v2_num = INPUT(COMPRESS(bene_cc_ph_copd_v2_pct), BEST12.);

    /* Convert Provider Specialty (Categorical) */
    pri_spec_clean = PUT(pri_spec, $20.); /* Ensures it is correctly formatted */

    /* Keep Relevant Variables */
    KEEP prop_rural_num tot_mdcr_alowd_amt_num pri_spec_clean 
         bene_cc_ph_asthma_v2_num bene_cc_ph_copd_v2_num;
RUN;

PROC GLM DATA=mips_clean;
    CLASS prop_rural_num pri_spec_clean;
    MODEL tot_mdcr_alowd_amt_num = prop_rural_num pri_spec_clean prop_rural_num*pri_spec_clean;
    MEANS pri_spec_clean / TUKEY;
    TITLE "Does Provider Specialty Impact Medicare Payments Differently in Rural vs. Urban Areas?";
RUN;

PROC SQL;
    CREATE TABLE top_specialties AS
    SELECT pri_spec_clean, MEAN(tot_mdcr_alowd_amt_num) AS avg_payment
    FROM mips_clean
    GROUP BY pri_spec_clean
    ORDER BY avg_payment DESC;
QUIT;

PROC SGPLOT DATA=top_specialties (OBS=20);
    HBAR pri_spec_clean / RESPONSE=avg_payment 
        STAT=MEAN DATALABEL CATEGORYORDER=RESPDESC 
        FILLATTRS=(COLOR=pink); /* Change color here */
    TITLE "Top 20 Medicare Payments by Provider Specialty";
    XAXIS LABEL="Average Medicare Payment";
    YAXIS LABEL="Provider Specialty";
RUN;

PROC SQL;
    CREATE TABLE bottom_specialties AS
    SELECT pri_spec_clean, MEAN(tot_mdcr_alowd_amt_num) AS avg_payment
    FROM mips_clean
    GROUP BY pri_spec_clean
    ORDER BY avg_payment ASC; /* Ascending for bottom */

QUIT;

PROC SGPLOT DATA=bottom_specialties (OBS=20); /* Only take the bottom 20 */
    HBAR pri_spec_clean / RESPONSE=avg_payment
        STAT=MEAN DATALABEL CATEGORYORDER=RESPASC
                FILLATTRS=(COLOR=gray); /* Change color here */
    TITLE "Bottom 20 Medicare Payments by Provider Specialty";
    XAXIS LABEL="Average Medicare Payment";
    YAXIS LABEL="Provider Specialty";
RUN;










