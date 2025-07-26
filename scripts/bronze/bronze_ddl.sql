/*

======================================================================================================
Le fichier bronze_ddl.sql contient les définitions de tables pour le schéma bronze du Data Warehouse.
======================================================================================================

objectif du script :
Ce script crée les tables nécessaires dans le schéma bronze du Data Warehouse pour stocker les données
brutes provenant de différentes sources. Il est conçu pour être exécuté après la création des schémas
bronze, silver et gold dans la base de données DataWarehouse.


Attention :
- Les tables créées dans ce script sont destinées à stocker les données brutes avant leur transformation et leur enrichissement.
- Assurez-vous que le schema bronze n'exite pas déjà avant d'exécuter ce script, ou faites un backup de vos données existantes car ce script va supprimer les tables existantes.

======================================================================================================
*/


USE [DataWarehouse];
GO


IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname VARCHAR(255),
    cst_lastname VARCHAR(255),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date DATE
);
GO

IF OBJECT_ID('bronze.crm_prod_info','U') IS NOT NULL
    DROP TABLE bronze.crm_prod_info;
CREATE TABLE bronze.crm_prod_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(255),
    prd_cost INT,
    prd_line VARCHAR(10),
    prd_start_dt DATE,
    prd_end_dt DATE
);
GO

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen VARCHAR(10)
);
GO

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    px_cat_id NVARCHAR(10),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance VARCHAR(10)
);
GO
