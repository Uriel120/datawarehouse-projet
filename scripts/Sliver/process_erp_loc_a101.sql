
/*
This script processes the ERP location data from the bronze layer and loads it into the silver layer.
It performs data cleaning and transformation, including:
- Trimming whitespace
- Replacing specific country codes with full names
- Handling null or empty values
*/



TRUNCATE TABLE silver.erp_loc_a101;
GO
INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT 
    REPLACE(TRIM(cid), '-', '') AS cid,
    CASE 
        WHEN REPLACE(REPLACE(TRIM(cntry),CHAR(10), ''), CHAR(13), '') IN ('USA', 'US') THEN 'United States'
        WHEN REPLACE(REPLACE(TRIM(cntry),CHAR(10), ''), CHAR(13), '') = 'DE' THEN 'Germany'
        WHEN REPLACE(REPLACE(TRIM(cntry),CHAR(10), ''), CHAR(13), '') = '' or REPLACE(REPLACE(TRIM(cntry),CHAR(10), ''), CHAR(13), '') IS NULL THEN 'n/a'
        ELSE REPLACE(REPLACE(TRIM(cntry),CHAR(10), ''), CHAR(13), '') 
    END AS cntry
FROM bronze.erp_loc_a101;