/*
----------------------------------------------------------------------------------------------
    File: process_erp_cust_az12.sql
    Description: This script processes the ERP customer data from the bronze layer to the silver layer.
    It cleans the customer ID, birth date, and  
 *Script to process ERP customer data from bronze to silver layer.
 * It cleans the customer ID, birth date, and gender fields.
 */

TRUNCATE TABLE silver.erp_cust_az12;
GO
INSERT INTO silver.erp_cust_az12 
(cid, 
bdate, 
gen)
SELECT 
    CASE WHEN cid LIKE 'NAS%' 
            THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() 
            THEN NULL 
        ELSE bdate 
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS cleaned_gen
FROM bronze.erp_cust_az12