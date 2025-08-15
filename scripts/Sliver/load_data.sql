/*
===========================================================================================================
   Script de chargement des données dans le schéma Silver
===========================================================================================================
   Ce script est responsable de l'ingestion des données depuis le schéma Bronze vers le schéma Silver.
   Il effectue les opérations suivantes :
   - Ingestion des données CRM dans les tables du schéma Silver
   - Gestion des erreurs et des transactions
----------------------------------------------------------------------------------------------------
   Created by: TOFFE GOKALE MICHEL
   Date: 2023-10-01
   Version: 1.0
----------------------------------------------------------------------------------------------------
   ATTENTION:
    1. Assurez-vous que les tables Bronze sont correctement peuplées avant d'exécuter ce script.
    2. Les tables Silver seront tronquées avant l'insertion des nouvelles données.
    3. Ce script doit être exécuté dans l'ordre correct pour garantir l'intégrité des données.
===========================================================================================================
*/



CREATE OR ALTER PROCEDURE [silver].[load_sliver] AS 
BEGIN
    BEGIN TRY
        DECLARE @start_date DATETIME,@end_date DATETIME, @batch_start_date DATETIME, @batch_end_date DATETIME;
        PRINT '==================================================';
        PRINT 'INGESTION DES DONNÉES DANS LA TABLE SILVER A ' + CONVERT(NVARCHAR(20), GETDATE(), 120);
        PRINT '==================================================';
        PRINT '---------------------------------------------------------';
        PRINT 'Ingestion des données CRM dans les tables du schéma silver';
        PRINT '---------------------------------------------------------';  
        PRINT '>>> Ingestion de la table : crm_cust_info';
        SET @start_date = GETDATE();
        SET @batch_start_date = GETDATE();
        TRUNCATE TABLE silver.crm_cust_info;
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
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_cust_info : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '>>> Ingestion de la table : crm_prod_info';
        SET @start_date = GETDATE();
        TRUNCATE TABLE silver.crm_prod_info;
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
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_prod_info : ' +
        CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '>>> Ingestion de la table : crm_sales_details';
        SET @start_date = GETDATE();
        TRUNCATE TABLE silver.crm_sales_details;
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
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_sales_details : ' +
        CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '---------------------------------------------------------';
        PRINT 'Ingestion des données ERP dans les tables du schéma silver';
        PRINT '---------------------------------------------------------';
        PRINT '>>> Ingestion de la table : erp_cust_az12';
        SET @start_date = GETDATE();
        TRUNCATE TABLE silver.erp_cust_az12;
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
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table erp_cust_az12 : ' + 
        CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '>>> Ingestion de la table : erp_loc_a101';
        SET @start_date = GETDATE();
        TRUNCATE TABLE silver.erp_loc_a101;
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
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table erp_loc_a101 : ' + 
        CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT'>>> Ingestion de la table: erp_px_cat_g1v2';
        SET @start_date = GETDATE();
        TRUNCATE TABLE silver.erp_px_cat_g1v2;
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
        SET @end_date = GETDATE();
        SET @batch_end_date = GETDATE();
        PRINT '>>> -----------------';
        PRINT 'Durée de l''ingestion de la table erp_px_cat_g1v2 : ' + 
        CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '==================================================';
        PRINT 'FIN DE L''INGESTION DES DONNÉES DANS LA TABLE SILVER A ' + CONVERT(NVARCHAR(20), GETDATE(), 120);
        PRINT '==================================================';
        PRINT '****************************************************';
        PRINT 'DUREE TOTAL DE L''INGESTION DES DONNEES';
        PRINT '        - DUREE TOTAL : ' + CAST(DATEDIFF(SECOND, @batch_start_date, @batch_end_date) AS NVARCHAR(10)) + ' secondes';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur lors de l''exécution du script de chargement des données de la table bronze.crm_cust_info dans la couche silver.crm_cust_info';
        PRINT ERROR_MESSAGE();
        PRINT '===================================================';
        PRINT 'ERREUR DANS L''INGESTION DES DONNÉES';
        PRINT '===================================================';
        PRINT 'Message d''erreur : ' + ERROR_MESSAGE();
        PRINT 'Numero de ligne : ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT 'Procedure : ' + OBJECT_NAME(ERROR_PROCEDURE());
        PRINT 'État : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Numéro de l''erreur : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT '===================================================';
        PRINT 'INGESTION DES DONNÉES TERMINÉE AVEC ÉCHEC A ' + CONVERT(NVARCHAR(20), GETDATE(), 120);
        PRINT '===================================================';
        PRINT '*****************************************************';
        PRINT 'DUREE TOTAL DE L''INGESTION DES DONNEES';
        PRINT '        - DUREE TOTAL : ' + CAST(DATEDIFF(SECOND, @batch_start_date, @batch_end_date) AS NVARCHAR(10)) + ' secondes';
    END CATCH;

END


EXEC [silver].[load_sliver];