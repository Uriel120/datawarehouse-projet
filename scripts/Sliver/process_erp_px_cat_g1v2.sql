/*
--------------------------------------------------------------------------------------------
    Script Name: process_erp_px_cat_g1v2.sql
    Description: Nettoie les données px_cat_g1v2 de la couche bronze vers la couche argent.
---------------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
---------------------------------------------------------------------------------------------
    Ce script effectue les opérations suivantes :
    1. Truncate la table silver.erp_px_cat_g1v2.
    2. Insère les données nettoyées de bronze.erp_px_cat_g1v2 dans silver.erp_px_cat_g1v2.
    3. Supprime les retours chariot et les sauts de ligne de la colonne maintenance.
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