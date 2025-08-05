/*
--------------------------------------------------------------
Project: Data Warehouse Project
File: process_crm_prod_info.sql
Description: This script processes product information from the bronze layer to the silver layer.
--------------------------------------------------------------  
created by: TOFFE GOKALE MICHEL
Date: 2023-10-01
Version: 1.0
--------------------------------------------------------------
This script performs the following operations:
ATTENTION:
    1. Truncates the silver.crm_prod_info table.
    2. Inserts cleaned data from bronze.crm_prod_info into silver.crm_prod_info.
    3. Ensures that product keys are formatted correctly and that product lines are categorized.
    4. Handles null values and ensures date integrity.


*/



INSERT INTO silver.crm_prod_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
    REPLACE(SUBSTRING(prd_key,7,LEN(prd_key)),'-','_') as prd_key,
    TRIM(prd_nm) as prd_nm,
    ISNULL(prd_cost, 0) as prd_cost,
    CASE TRIM(prd_line)
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,
    CAST(
        prd_start_dt AS DATE
    ) AS prd_start_dt,
    CAST(
        DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) 
        AS DATE
    ) AS prd_end_dt
FROM bronze.crm_prod_info

SELECT TOP 10 *
FROM silver.crm_prod_info;