/*
------------------------------------------------------------------------------------
    Script Name: process_crm_sales_details.sql
    Description: Ce script traite les détails des ventes CRM de la couche bronze vers la couche argent.
    Il s'assure que les données sont nettoyées, formatées et prêtes pour l'analyse.
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
ATTENTION:
    1. Truncate la table silver.crm_sales_details.
    2. Insère les données nettoyées de bronze.crm_sales_details dans silver.crm_sales_details.
    3. Valide et formate les champs de date.
    4. S'assure que les champs de vente, de quantité et de prix sont cohérents et cohérents.
    5. Gère les valeurs nulles de manière appropriée.
------------------------------------------------------------------------------------
*/

TRUNCATE TABLE silver.crm_sales_details;
GO
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt ,
    sls_ship_dt ,
    sls_due_dt,
    sls_sales ,
    sls_quantity,
    sls_price 
)
SELECT
    sls_ord_num,
    REPLACE(sls_prd_key, '-', '_') AS sls_prd_key,
    sls_cust_id,
    CASE WHEN LEN(sls_order_dt) != 8 OR sls_order_dt <= 0 
            THEN NULL 
        ELSE CAST(CAST(sls_order_dt AS varchar(8)) AS DATE)
    END AS sls_order_dt,
    CASE WHEN LEN(sls_ship_dt) !=8 OR sls_ship_dt <= 0
            THEN NULL 
        ELSE CAST(CAST(sls_ship_dt AS varchar(8)) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN LEN(sls_due_dt) != 8 OR sls_due_dt <= 0
            THEN NULL 
        ELSE CAST(CAST(sls_due_dt AS varchar(8)) AS DATE)
    END AS sls_due_dt,
    CASE WHEN sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
        WHEN sls_price <= 0 THEN ABS(sls_price)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;