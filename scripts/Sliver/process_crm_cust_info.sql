/*
----------------------------------------------------------------------
File: process_crm_cust_info.sql
Description: This script processes customer information from the bronze layer to the silver layer.
----------------------------------------------------------------------
Author: TOFFE GOKALE MICHEL
Date: 2023-10-01
Version: 1.0
----------------------------------------------------------------------
This script performs the following operations:
ATTENTION: 
    1. Truncates the silver.crm_cust_info table.
    2. Inserts cleaned data from bronze.crm_cust_info into silver.crm_cust_info.

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
