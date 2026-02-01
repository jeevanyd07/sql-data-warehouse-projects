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

-- Create Table bronz."bronze.crm_cust_info"
DROP TABLE IF EXISTS bronz."bronze.crm_cust_info";

CREATE TABLE bronz."bronze.crm_cust_info" (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_create_date DATE
);


-- Create Table bronz."bronze.crm_prd_info"
DROP TABLE IF EXISTS  bronz."bronze.crm_prd_info";

CREATE TABLE bronz."bronze.crm_prd_info"(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost VARCHAR(50),
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);


-- Create Table bronz."bronze.crm_sales_details"
DROP TABLE IF EXISTS bronz."bronze.crm_sales_details";

CREATE TABLE bronz."bronze.crm_sales_details"(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_id INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);


-- Create Table bronz."bronze.erp_cust_az12"
DROP TABLE IF EXISTS bronz."bronze.erp_cust_az12";

CREATE TABLE bronz."bronze.erp_cust_az12"(
	cid INT,
	bdate DATE,
	gen VARCHAR
);


-- Create Table bronz."bronze.erp_loc_a101"
DROP TABLE IF EXISTS bronz."bronze.erp_loc_a101";

CREATE TABLE bronz."bronze.erp_loc_a101"(
	cid VARCHAR(50),
	cntry VARCHAR(50)
);


-- Create Table bronz."bronze.erp_px_cat_g1v2"
DROP TABLE IF EXISTS bronz."bronze.erp_px_cat_g1v2";

CREATE TABLE bronz."bronze.erp_px_cat_g1v2"(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);
