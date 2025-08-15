/*

------------------------------------------------------------------------------------
    File Name: erp_px_cat_g1v2_data_quality_check.sql
    Description: This script performs data quality checks on the silver.erp_px_cat_g1v2 table.  
--------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
--------------------------------------------------------------------------------------
    This script performs the following operations:
    1. Checks for duplicate px_cat_id values.
    2. Validates the presence of additional spaces in px_cat_id.
    3. Ensures the consistency of values in the cat, subcat, and maintenance columns.
    4. Checks for the presence of carriage returns in px_cat_id.
--------------------------------------------------------------------------------------
*/

SELECT *
FROM bronze.erp_px_cat_g1v2;
GO

PRINT '---------------------------------- verifier la duplication px_cat_id  ----------------------------------';
SELECT 
    px_cat_id,
    COUNT(*) as id_reptition
FROM bronze.erp_px_cat_g1v2
GROUP BY px_cat_id
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les px_cat_id  ----------------------------------';
SELECT
    px_cat_id
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(px_cat_id) != px_cat_id;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    cat
FROM bronze.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    subcat
FROM bronze.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    maintenance
FROM bronze.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la presence de retour chariot dans les px_cat_id ----------------------------------';
SELECT
    cat,
    UNICODE(RIGHT(cat, 1)) AS last_char
FROM bronze.erp_px_cat_g1v2

PRINT '---------------------------------- verifier la duplication px_cat_id  ----------------------------------';
SELECT 
    px_cat_id,
    COUNT(*) as id_reptition
FROM silver.erp_px_cat_g1v2
GROUP BY px_cat_id
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les px_cat_id  ----------------------------------';
SELECT
    px_cat_id
FROM silver.erp_px_cat_g1v2
WHERE TRIM(px_cat_id) != px_cat_id;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    cat
FROM silver.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    subcat
FROM silver.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la consistence des valeurs  ----------------------------------';
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la presence de retour chariot dans les px_cat_id ----------------------------------';
SELECT
    cat,
    UNICODE(RIGHT(cat, 1)) AS last_char
FROM silver.erp_px_cat_g1v2
