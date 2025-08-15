/*
----------------------------------------------------------------
Vérification de la qualité des données dans la table bronze.erp_loc_a101 et silver.erp_loc_a101
------------------------------------------------------------------------------------
1. Vérifie la duplication des identifiants (cid).
2. Vérifie la présence d'espaces additionnels dans les identifiants (cid).
3. Vérifie la consistance des valeurs de la colonne cntry.
4. Vérifie la présence de retours chariot et de saut de ligne dans la colonne

*/




SELECT *
FROM bronze.erp_loc_a101;
GO

PRINT ' ----------------------------------- Test de qualité des données dans la table bronze.erp_loc_a101 -----------------------------------';
PRINT '---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cid,
    COUNT(*) as id_reptition
FROM bronze.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les cid  ----------------------------------';
SELECT
    cid
FROM bronze.erp_loc_a101
WHERE TRIM(cid) != cid;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- Verifier la consistance des valeurs de la colonne cntry ----------------------------------';
SELECT DISTINCT
    cntry
FROM bronze.erp_loc_a101
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- Verifier la presence de retour chariot dans les cntry ----------------------------------';
SELECT
    cntry,
    UNICODE(RIGHT(cntry, 1)) AS last_char
FROM bronze.erp_loc_a101
PRINT '---------------------------------------------------------------------';
GO


SELECT *
FROM silver.erp_loc_a101;
GO

PRINT ' ----------------------------------- Test de qualité des données dans la table silver.erp_loc_a101 -----------------------------------';
PRINT '---------------------------------- verifier la duplication ID  ----------------------------------';
SELECT 
    cid,
    COUNT(*) as id_reptition
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- verifier la presence d''espace additionnel dans les cid  ----------------------------------';
SELECT
    cid
FROM silver.erp_loc_a101
WHERE TRIM(cid) != cid;
PRINT '---------------------------------------------------------------------';
GO

PRINT '---------------------------------- Verifier la consistance des valeurs de la colonne cntry ----------------------------------';
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
PRINT '---------------------------------------------------------------------';
GO
