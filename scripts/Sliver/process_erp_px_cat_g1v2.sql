/*
--------------------------------------------------------------------------------------------
    Script Name: process_erp_px_cat_g1v2.sql
    Description: Processes the px_cat_g1v2 data from bronze to silver layer.    
---------------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
---------------------------------------------------------------------------------------------
    This script performs the following operations:
    1. Truncates the silver.erp_px_cat_g1v2 table.
    2. Inserts cleaned data from bronze.erp_px_cat_g1v2 into silver.erp_px_cat_g1v2.
    3. remove carriage returns and line feeds from the maintenance column.
*/


TRUNCATE TABLE silver.erp_px_cat_g1v2;
GO
INSERT INTO silver.erp_px_cat_g1v2 (
    px_cat_id,
    cat,
    subcat,
    maintenance
)
SELECT 
    px_cat_id,
    cat,
    subcat,
    REPLACE(REPLACE(maintenance, CHAR(13), ''), CHAR(10), '') AS maintenance
FROM bronze.erp_px_cat_g1v2;