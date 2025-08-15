/*
----------------------------------------------------------------------------------------------
    File: process_erp_cust_az12.sql
    Description: Ce script traite les données clients ERP de la couche bronze vers la couche argent.
----------------------------------------------------------------------------------------------
    Created by: TOFFE GOKALE MICHEL
    Date: 2023-10-01
    Version: 1.0
----------------------------------------------------------------------------------------------
    Ce script nettoie l'ID client, la date de naissance et le champ de genre.
    il s'agit d'un script pour traiter les données clients ERP de la couche bronze vers la couche argent.
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