USE [DataWarehouse];
GO

CREATE OR ALTER PROCEDURE [bronze].[load_bronze] AS 
BEGIN
    BEGIN TRY
        DECLARE @start_date DATETIME , @end_date DATETIME, @batch_start_date DATETIME, @batch_end_date DATETIME;
        PRINT '==================================================';
        PRINT 'INGESTION DES DONNÉES DANS LA TABLE BRONZE A ' + CONVERT(NVARCHAR(20), GETDATE(), 120);
        PRINT '==================================================';

        PRINT '---------------------------------------------------------';
        PRINT 'Ingestion des données CRM dans les tables du schéma bronze';
        PRINT '---------------------------------------------------------';


        PRINT '>>> Ingestion de la table : crm_cust_info';
        SET @start_date = GETDATE();
        SET @batch_start_date = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM '/home/cust_info.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_cust_info : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '>>> Ingestion de la table : crm_prod_info';

        SET @start_date = GETDATE();
        TRUNCATE TABLE bronze.crm_prod_info;
        BULK INSERT bronze.crm_prod_info
        FROM '/home/prd_info.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_prod_info : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------';
        PRINT '>>> Ingestion de la table : crm_sales_details';
        SET @start_date = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM '/home/sales_details.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table crm_sales_details : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------'
        PRINT '---------------------------------------------------------';
        PRINT 'Ingestion des données ERP dans les tables du schéma bronze';
        PRINT '---------------------------------------------------------';

        PRINT '>>> Ingestion de la table : erp_cust_az12';

        SET @start_date = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM '/home/CUST_AZ12.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table erp_cust_az12 : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------'
        PRINT '>>> Ingestion de la table : erp_loc_a101';

        SET @start_date = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM '/home/LOC_A1O1.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table erp_loc_a101 : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------'
        PRINT '>>> Ingestion de la table : erp_px_cat_g1v2';

        SET @start_date = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/home/PX_CAT_G1V2.csv'
        WITH (  FIRSTROW = 2,
                FIELDTERMINATOR = ',');
        SET @end_date = GETDATE();
        SET @batch_end_date = GETDATE();
        PRINT 'Durée de l''ingestion de la table erp_px_cat_g1v2 : ' + CAST(DATEDIFF(SECOND, @start_date, @end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '>>> -----------------'


        PRINT '****************************************************';
        PRINT 'DUREE TOTAL DE L''INGESTION DES DONNEE'
        PRINT '        - DUREE TOTAL : ' + CAST(DATEDIFF(SECOND, @batch_start_date, @batch_end_date) AS NVARCHAR(10)) + ' secondes';
        PRINT '*****************************************************';
        PRINT '===================================================';
        PRINT 'INGESTION DES DONNÉES TERMINÉE AVEC SUCCÈS A ' + CONVERT(NVARCHAR(20), GETDATE(), 120);
        PRINT '===================================================';
    END TRY
    BEGIN CATCH
        PRINT '===================================================';
        PRINT 'ERREUR DANS L''INGESTION DES DONNÉES';
        PRINT '===================================================';
        PRINT 'Message d''erreur : ' + ERROR_MESSAGE();
        PRINT 'Numéro de l''erreur : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'État de l''erreur : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Procédure stockée : ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
        PRINT 'Ligne de l''erreur : ' + CAST(ERROR_LINE() AS NVARCHAR(10));
    END CATCH
END;

EXEC [bronze].[load_bronze];
