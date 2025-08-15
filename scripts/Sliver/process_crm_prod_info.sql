/*
--------------------------------------------------------------
Project: Data Warehouse Project
File: process_crm_prod_info.sql
Description: Ce script traite les informations produit de la couche bronze vers la couche argent.
--------------------------------------------------------------  
created by: TOFFE GOKALE MICHEL
Date: 2023-10-01
Version: 1.0
--------------------------------------------------------------
Ce script effectue les opérations suivantes :
ATTENTION:
    1. Truncate la table silver.crm_prod_info.
    2. Insère les données nettoyées de bronze.crm_prod_info dans silver.crm_prod_info.
    3. S'assure que les clés de produit sont correctement formatées et que les lignes de produit sont catégorisées.
    4. Gère les valeurs nulles et garantit l'intégrité des dates.

*/


TRUNCATE TABLE silver.crm_prod_info;
GO

INSERT INTO silver.crm_prod_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
    REPLACE(SUBSTRING(prd_key,7,LEN(prd_key)),'-','_') as prd_key,
    TRIM(prd_nm) as prd_nm,
    ISNULL(prd_cost, 0) as prd_cost,
    CASE TRIM(prd_line)
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,
    CAST(
        prd_start_dt AS DATE
    ) AS prd_start_dt,
    CAST(
        DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) 
        AS DATE
    ) AS prd_end_dt
FROM bronze.crm_prod_info
