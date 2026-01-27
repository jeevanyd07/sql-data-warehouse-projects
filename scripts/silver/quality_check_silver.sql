/*
=================================================================================
Quality Checks
=================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicates primary keys.
    - Unwanted spaces in string fields.
    - Data standarization and consistency.
    - Invalid data ranges and others.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Layer.
    - Invessting and resolve any discrepancies found duaring the checks.
===============================================================================
*/

-- 1️⃣ Silver CRM Customer Info – Quality Checks
-- ✅ Duplicate Check (1 record per customer)
SELECT cst_id, COUNT(*) AS cnt
FROM bronz."silver.crm_cust_info"
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- ✅ Null Check – Mandatory Columns
SELECT *
FROM bronz."silver.crm_cust_info"
WHERE cst_id IS NULL
   OR cst_key IS NULL;

-- ✅ Domain Check – Marital Status
SELECT DISTINCT cst_material_status
FROM bronz."silver.crm_cust_info"
WHERE cst_material_status NOT IN ('Married', 'Single', 'N/A');

-- ✅ Domain Check – Gender
SELECT DISTINCT cst_gndr
FROM bronz."silver.crm_cust_info"
WHERE cst_gndr NOT IN ('Male', 'Female', 'N/A');

-- 2️⃣ Silver CRM Product Info – Quality Checks
✅ Null & Default Cost Validation
SELECT *
FROM bronz."silver.crm_prd_info"
WHERE prd_cost < 0;

-- ✅ Product Line Domain Validation
SELECT DISTINCT prd_line
FROM bronz."silver.crm_prd_info"
WHERE prd_line NOT IN ('Mountain', 'Road', 'Touring', 'Other Sales', 'N/A');

-- ✅ Date Integrity Check
SELECT *
FROM bronz."silver.crm_prd_info"
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;

-- 3️⃣ Silver CRM Sales Details – Quality Checks
-- ✅ Invalid Order Dates
SELECT *
FROM bronz."silver.crm_sales_details"
WHERE sls_order_dt IS NULL;

-- ✅ Sales Consistency Check
SELECT *
FROM bronz."silver.crm_sales_details"
WHERE sls_sales <> sls_quantity * sls_price;

-- ✅ Quantity & Price Validation
SELECT *
FROM bronz."silver.crm_sales_details"
WHERE sls_quantity <= 0
   OR sls_price <= 0;

-- 4️⃣ Silver ERP Customer AZ12 – Quality Checks
✅ Future Birth Date Check
SELECT *
FROM bronz."silver.erp_cust_az12"
WHERE bdate > CURRENT_DATE;

-- ✅ Gender Domain Validation
SELECT DISTINCT gen
FROM bronz."silver.erp_cust_az12"
WHERE gen NOT IN ('Male', 'Female', 'N/A');

-- 5️⃣ Silver ERP Location A101 – Quality Checks
-- ✅ Country Standardization Check
SELECT DISTINCT cntry
FROM bronz."silver.erp_loc_a101"
WHERE cntry IN ('US', 'USA', 'DE');

-- ✅ Null Country Check
SELECT *
FROM bronz."silver.erp_loc_a101"
WHERE cntry IS NULL;

-- 6️⃣ Silver ERP Catalogue – Quality Checks
-- ✅ Null Check
SELECT *
FROM bronz."silver.erp_px_cat_g1v2"
WHERE id IS NULL
   OR cat IS NULL;

-- 7️⃣ Row Count Reconciliation (Bronze vs Silver)
SELECT 
  (SELECT COUNT(*) FROM bronz."bronze.crm_cust_info") AS bronze_cnt,
  (SELECT COUNT(*) FROM bronz."silver.crm_cust_info") AS silver_cnt;

-- 8️⃣ Load Validation – No Empty Silver Tables
SELECT COUNT(*) FROM bronz."silver.crm_cust_info";
SELECT COUNT(*) FROM bronz."silver.crm_prd_info";
SELECT COUNT(*) FROM bronz."silver.crm_sales_details";
