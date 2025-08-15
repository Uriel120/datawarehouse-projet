/*
------------------------------------------------------------------------------------
    Script Name: process_crm_sales_details.sql
    Description: This script processes CRM sales details from the bronze layer to the silver layer. 
    It ensures that the data is cleaned, formatted, and ready for analysis.
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
ATTENTION:
    1. Truncates the silver.crm_sales_details table.
    2. Inserts cleaned data from bronze.crm_sales_details into silver.crm_sales_details.
    3. Validates and formats date fields.
    4. Ensures sales, quantity, and price fields are consistent and coherent.
    5. Handles null values appropriately.
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
    sls_prd_key,
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