
/*
------------------------------------------------------------------------------------
Ce script traite les données de localisation ERP de la couche bronze et les charge dans la couche argent.
------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
------------------------------------------------------------------------------------
Il effectue le nettoyage et la transformation des données, y compris :

- Suppression des espaces
- Remplacement des codes de pays spécifiques par des noms complets
- Gestion des valeurs nulles ou vides
------------------------------------------------------------------------------------
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