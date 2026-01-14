/* 
=======================================================================================================
Create Database and Schemas
=======================================================================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the scripts sets up three schemas
    within the databse: 'bronze','silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. All data in the database
    will be permanetly deleted. Proceed with caution and ensure you have proper backup before running this script.
*/

USE MASTER;
GO

-- Drpo and Recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWherehouse')
BEGIN
    ALTER DATABASE DataWherehouse SET SINGLE_USER WITH ROLLBACK IMMEDAITE;
    DROP DATABASE DataWherehouse;
END;
GO

-- Create the 'DataWherehouse' database
CREATE DATABASE DataWherehouse;
GO

USE DataWherehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO












