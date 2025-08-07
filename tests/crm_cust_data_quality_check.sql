/*

=======================================================================================================
                    sliver.crm_cust_info data quality check
=======================================================================================================

This script checks the data quality of the bronze.crm_cust_info , silver.crm_cust_info table and ensures that the data is accurate and consistent.
*/


PRINT'---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cst_id,
    COUNT(*) as id_reptition
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO


PRINT '------------------------------------- verifier la presence d''espace additionnel dans les firstname -------------------------------------';
SELECT 
    cst_firstname
FROM bronze.crm_cust_info
WHERE TRIM(cst_firstname) != cst_firstname;
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier la presence d''espace additionnel dans les lastname -------------------------------------';
SELECT 
    cst_lastname
FROM bronze.crm_cust_info
WHERE TRIM(cst_lastname) != cst_lastname;
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier les valeurs unique de marital_status -------------------------------------';
SELECT
    DISTINCT(cst_marital_status) as marital_status
FROM bronze.crm_cust_info
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier les valeurs unique du genre -------------------------------------';
SELECT
    DISTINCT(cst_gndr) as gender
FROM bronze.crm_cust_info
PRINT '---------------------------------------------------------------------';
GO


--------------------------------------- Verifier les test de qualité des données dans silver.crm_cust_info ---------------------------------------
PRINT'---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cst_id,
    COUNT(*) as id_reptition
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO


PRINT '------------------------------------- verifier la presence d''espace additionnel dans les firstname -------------------------------------';
SELECT 
    cst_firstname
FROM silver.crm_cust_info
WHERE TRIM(cst_firstname) != cst_firstname;
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier la presence d''espace additionnel dans les lastname -------------------------------------';
SELECT 
    cst_lastname
FROM silver.crm_cust_info
WHERE TRIM(cst_lastname) != cst_lastname;
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier les valeurs unique de marital_status -------------------------------------';
SELECT
    DISTINCT(cst_marital_status) as marital_status
FROM silver.crm_cust_info
PRINT '---------------------------------------------------------------------';
GO

PRINT '------------------------------------- verifier les valeurs unique du genre -------------------------------------';
SELECT
    DISTINCT(cst_gndr) as gender
FROM silver.crm_cust_info
PRINT '---------------------------------------------------------------------';
GO