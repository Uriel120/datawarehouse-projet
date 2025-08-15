/*
-------------------------------------------------------------------------------
-- File: crm_sales_details.sql
-- Description: Test de qualité pour la table silver.crm_sales_details
------------------------------------------------------------------------------- 
Note: Ce script effectue les opérations suivantes :
1. Vérifie la présence d'espaces supplémentaires dans les colonnes varchar.
2. Valide les champs de date pour s'assurer qu'ils ne contiennent pas de valeurs invalides.
3. S'assure que les champs de vente, de quantité et de prix sont cohérents et cohérents.
------------------------------------------------------------------------------- 
*/

USE [DataWarehouse];
GO

PRINT '--------------------------------------- Test de qualité pour le niver bronze.crm_cust_info ---------------------------------------';

USE [DataWarehouse];
GO

PRINT '------------------------------------- verifier la presence d''espace additionnel dans les colonnes varchar -------------------------------------';
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE TRIM(sls_ord_num) != sls_ord_num;
GO

SELECT 
    sls_prd_key
FROM bronze.crm_sales_details
WHERE TRIM(sls_prd_key) != sls_prd_key;
GO

SELECT
    sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id IS NULL;
GO
PRINT '-------------------------------------- Verifier que les champs date ne contient pas de valeur au format date -------------------------------';

SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt
OR sls_order_dt IS NULL 
OR sls_order_dt <= 0
OR LEN(sls_order_dt) != 8;
GO 

SELECT sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt IS NULL 
OR sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8;
GO


SELECT sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt IS NULL 
OR sls_due_dt <= 0
OR LEN(sls_due_dt) != 8;
GO
PRINT '-------------------------------------- Verifier que les champs sales, quantity et price sont conforme et coherent -------------------------------';

SELECT DISTINCT sls_quantity
FROM bronze.crm_sales_details
WHERE sls_quantity <= 0 OR sls_quantity IS NULL;
GO

SELECT sls_sales,sls_quantity,sls_price
FROM bronze.crm_sales_details
WHERE sls_sales < 0 OR sls_sales IS NULL
OR sls_sales != sls_quantity * sls_price;
GO

SELECT sls_price,sls_quantity,sls_sales
FROM bronze.crm_sales_details
WHERE sls_price < 0 OR sls_price IS NULL;
GO

SELECT TOP 10 *
FROM bronze.crm_sales_details;
GO

PRINT'--------------------------------------- Test de qualité pour le niver silver.crm_sales_details ---------------------------------------';
GO
PRINT '------------------------------------- verifier la presence d''espace additionnel dans les colonnes varchar -------------------------------------';
SELECT sls_ord_num
FROM silver.crm_sales_details
WHERE TRIM(sls_ord_num) != sls_ord_num;
GO

SELECT 
    sls_prd_key
FROM silver.crm_sales_details
WHERE TRIM(sls_prd_key) != sls_prd_key;
GO

SELECT
    sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL;
GO
PRINT '-------------------------------------- Verifier que les champs date ne contient pas de valeur au format date -------------------------------';

SELECT sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt
OR sls_order_dt IS NULL 
GO 

SELECT sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL 
GO


SELECT sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL 
GO
PRINT '-------------------------------------- Verifier que les champs sales, quantity et price sont conforme et coherent -------------------------------';

SELECT DISTINCT sls_quantity
FROM silver.crm_sales_details
WHERE sls_quantity <= 0 OR sls_quantity IS NULL;
GO

SELECT sls_sales,sls_quantity,sls_price
FROM silver.crm_sales_details
WHERE sls_sales < 0 OR sls_sales IS NULL
OR sls_sales != sls_quantity * sls_price;
GO

SELECT sls_price,sls_quantity,sls_sales
FROM silver.crm_sales_details
WHERE sls_price < 0 OR sls_price IS NULL;
GO

SELECT TOP 10 *
FROM silver.crm_sales_details;
GO