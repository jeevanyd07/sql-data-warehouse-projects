/*
========================================================================================

Store Procedure: Load Bronze Layer (Source -> Bronze)

========================================================================================
Script Purpose
    This stored procedure loads data into the 'Bronze' schema from external CSV files.
    It performs the following actions:
      - Truncates the bronze tables before loading data.
      - User the 'Bulk Insert' command to load data from csv Files to bronze tables.

Parameters:
    None-
  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load bronze;

=======================================================================================
*/


