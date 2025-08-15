SELECT TOP 10 *
FROM silver.erp_cust_az12;
GO

PRINT ' ----------------------------------- Test de qualité des données dans la table silver.erp_cust_az12 -----------------------------------';

PRINT '---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cid,
    COUNT(*) as id_reptition
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les cid  ----------------------------------';
SELECT
    cid
FROM bronze.erp_cust_az12
WHERE TRIM(cid) != cid;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence de valeur futur dans la date d''anniversaire ----------------------------------';
SELECT
    bdate
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE();
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier les valeur unique dans le genre ----------------------------------';
SELECT
    DISTINCT
    gen
FROM bronze.erp_cust_az12;
PRINT '---------------------------------------------------------------------';
GO
PRINT' ----------------------------------- Verifier la presence de retours chariot et de saut de ligne dans le genre -----------------------------------';
SELECT DISTINCT
    gen,
    LEN(gen) AS len,
    UNICODE(RIGHT(gen,1)) AS last_char
FROM bronze.erp_cust_az12
GO


PRINT' ----------------------------------- Test de qualité des données dans la table silver.erp_cust_az12 -----------------------------------';

PRINT '---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cid,
    COUNT(*) as id_reptition
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les cid  ----------------------------------';
SELECT
    cid
FROM silver.erp_cust_az12
WHERE TRIM(cid) != cid;
PRINT '---------------------------------------------------------------------';
GO  

PRINT '---------------------------------- verifier la presence de valeur futur dans la date d''anniversaire ----------------------------------';
SELECT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier les valeur unique dans le genre ----------------------------------';
SELECT
    DISTINCT
    gen
FROM silver.erp_cust_az12;
PRINT '---------------------------------------------------------------------';
GO

PRINT' ----------------------------------- Verifier la presence de retours chariot et de saut de ligne dans le genre -----------------------------------';
SELECT DISTINCT
    gen,
    LEN(gen) AS len,
    UNICODE(RIGHT(gen,1)) AS last_char
FROM silver.erp_cust_az12
GO

SELECT top 10 *
FROM bronze.erp_cust_az12;
GO

SELECT TOP 10 *
FROM bronze.crm_cust_info;