/*

=======================================================================================================
                    sliver.crm_prod_info data quality check
=======================================================================================================

This script checks the data quality of the silver.crm_prod_info table.
*/

PRINT '---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    prd_id,
    COUNT(*) as id_reptition
FROM bronze.crm_prod_info
GROUP BY prd_id
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la duplication key  ----------------------------------';
SELECT 
    prd_key,
    COUNT(*) as id_reptition
FROM bronze.crm_prod_info
GROUP BY prd_key
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les prd_nm  ----------------------------------';
SELECT 
    prd_nm
FROM bronze.crm_prod_info
WHERE TRIM(prd_nm) != prd_nm;
PRINT '---------------------------------------------------------------------';
GO


PRINT '---------------------------------- verifier la presence de valeur negatif et null dans le prix ----------------------------------';
SELECT 
    prd_cost
FROM bronze.crm_prod_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier que la date de debut est inferieur à la date de fin ----------------------------------';
SELECT 
    *
FROM bronze.crm_prod_info
WHERE prd_start_dt > prd_end_dt;
PRINT '---------------------------------------------------------------------';
GO

select DISTINCT PRD_LINE
from bronze.crm_prod_info