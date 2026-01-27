/*
============================================================================================================

DDL Script : Create Bronze Table

============================================================================================================
Script Purpose:
      This script create Tables in the 'Bronze' schema, dropping existing tables if they already exist.
      Ran this script to re-define the DDL structure of 'Bronze' Table
============================================================================================================
*/

-- ** Using postgresql **
-- If the table exist drop the table and create the table

-- Create Table bronz."bronze.crm_cust_info"
-- Create Table bronz."bronze.crm_prd_info"
-- Create Table bronz."bronze.crm_sales_details"
-- Create Table bronz."bronze.erp_cust_az12"
-- Create Table bronz."bronze.erp_loc_a101"
-- Create Table bronz."bronze.erp_px_cat_g1v2"
/*
==================================================================================================================
-- And Insert All *RAW* Values into into the bronze table form date set
==================================================================================================================
*/
