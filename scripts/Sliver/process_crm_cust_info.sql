/*
----------------------------------------------------------------------
File: process_crm_cust_info.sql
Description: Ce script traite les informations client de la couche bronze vers la couche argent.
----------------------------------------------------------------------
Author: TOFFE GOKALE MICHEL
Date: 2023-10-01
Version: 1.0
----------------------------------------------------------------------
Ce script effectue les opérations suivantes :
    1. Truncate la table silver.crm_cust_info.
    2. Insère les données nettoyées de bronze.crm_cust_info dans silver.crm_cust_info.

*/



USE [DataWarehouse];
GO

TRUNCATE TABLE silver.crm_cust_info;
GO

WITH deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as row_num
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE 
        WHEN TRIM(cst_marital_status) = 'M' THEN 'Marie'
        WHEN TRIM(cst_marital_status) = 'S' THEN 'Celibataire'
        ELSE 'N/A'
    END AS cst_marital_status,
    CASE 
        WHEN TRIM(cst_gndr) = 'M' THEN 'Homme'
        WHEN TRIM(cst_gndr) = 'F' THEN 'Femme'
        ELSE 'N/A'
    END AS cst_gndr,
    cst_create_date
FROM deduplicated
WHERE row_num = 1
