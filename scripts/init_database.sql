/*
=====================================================================================

Ce fichier est utilisé pour initialiser la base de données SQL Server dans le conteneur Docker.

=====================================================================================

Objectif du script :


*/

USE [master];
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    EXEC('CREATE DATABASE [DataWarehouse]');
    PRINT 'Base de données DataWarehouse créée avec succès.';
END
ELSE
BEGIN
    PRINT 'La base de données DataWarehouse existe déjà.';
END
GO
USE [DataWarehouse];
GO

-- Création du schéma bronze
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schéma bronze créé avec succès.';
END
ELSE
BEGIN
    PRINT 'Le schéma bronze existe déjà.';
END
GO

-- Création du schéma silver
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schéma silver créé avec succès.';
END
ELSE
BEGIN
    PRINT 'Le schéma silver existe déjà.';
END
GO

-- Création du schéma gold
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schéma gold créé avec succès.';
END
ELSE
BEGIN
    PRINT 'Le schéma gold existe déjà.';
END
GO