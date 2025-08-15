/*

------------------------------------------------------------------------------------
    File Name: erp_px_cat_g1v2_data_quality_check.sql
    Description: Ce script effectue des vérifications de qualité des données sur la table silver.erp_px_cat_g1v2.
--------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
--------------------------------------------------------------------------------------
    ce script effectue les opérations suivantes:
    1. Vérifie la duplication des valeurs px_cat_id.
    2. Valide la présence d'espaces supplémentaires dans px_cat_id.
    3. Assure la cohérence des valeurs dans les colonnes cat, subcat et maintenance.
    4. Vérifie la présence de retours chariot dans px_cat_id.
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