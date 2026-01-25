/*
==========================================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
==========================================================================================================
Script Purpose:
        This stored procedure performs the ETL (Extract, Transfer, Load) process to
        populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleased data from Bronze into Silver tables.

Parameters:
        None.
        This stored procedure does not accept any parameters or return any values.

Usage Example:
        EXEC Bronz.load_silver;
===========================================================================================================
*/
CREATE OR REPLACE PROCEDURE bronz.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start TIMESTAMP;
BEGIN
    ------------------------------------------------------------
    -- Silver CRM Customer Info
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.crm_cust_info";

    INSERT INTO bronz."silver.crm_cust_info"
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE
            WHEN cst_material_status = 'M' THEN 'Married'
            WHEN cst_material_status = 'S' THEN 'Single'
            ELSE 'N/A'
        END,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronz."bronze.crm_cust_info"
    ) t
    WHERE flag_last = 1;

    RAISE NOTICE 'silver.crm_cust_info completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

    ------------------------------------------------------------
    -- Silver CRM Product Info
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.crm_prd_info";

    INSERT INTO bronz."silver.crm_prd_info"
    SELECT  
        prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_'),
        SUBSTRING(prd_key,7),
        prd_nm,
        COALESCE(prd_cost,0),
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'N/A'
        END,
        CAST(prd_start_dt AS DATE),
        CAST(
            LEAD(prd_start_dt)
            OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
            AS DATE
        )
    FROM bronz."bronze.crm_prd_info";

    RAISE NOTICE 'silver.crm_prd_info completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

    ------------------------------------------------------------
    -- Silver CRM Sales Details
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.crm_sales_details";

    INSERT INTO bronz."silver.crm_sales_details"
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_id = 0 OR LENGTH(sls_order_id::TEXT) <> 8 THEN NULL
            ELSE TO_DATE(sls_order_id::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) <> 8 THEN NULL
            ELSE TO_DATE(sls_ship_dt::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) <> 8 THEN NULL
            ELSE TO_DATE(sls_due_dt::TEXT,'YYYYMMDD')
        END,
        CASE
            WHEN sls_sales IS NULL
              OR sls_sales <= 0
              OR sls_sales <> sls_quantity * sls_price
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,
        sls_quantity,
        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
        END
    FROM bronz."bronze.crm_sales_details";

    RAISE NOTICE 'silver.crm_sales_details completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

    ------------------------------------------------------------
    -- Silver ERP Customer AZ12
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.erp_cust_az12";

    INSERT INTO bronz."silver.erp_cust_az12"
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4) ELSE cid END,
        CASE WHEN bdate > NOW() THEN NULL ELSE bdate END,
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'N/A'
        END
    FROM bronz."bronze.erp_cust_az12";

    RAISE NOTICE 'silver.erp_cust_az12 completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

    ------------------------------------------------------------
    -- Silver ERP Location A101 
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.erp_loc_a101";

    INSERT INTO bronz."silver.erp_loc_a101"
    SELECT
        REPLACE(cid,'-',''),
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'N/A'
            ELSE TRIM(cntry)
        END
    FROM bronz."bronze.erp_loc_a101";

    RAISE NOTICE 'silver.erp_loc_a101 completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

    ------------------------------------------------------------
    -- Silver ERP Catalogue G1V2  
    ------------------------------------------------------------
    v_start := clock_timestamp();

    TRUNCATE TABLE bronz."silver.erp_px_cat_g1v2";

    INSERT INTO bronz."silver.erp_px_cat_g1v2"
    SELECT id, cat, subcat, maintenance
    FROM bronz."bronze.erp_px_cat_g1v2";

    RAISE NOTICE 'silver.erp_px_cat_g1v2 completed in % sec',
        EXTRACT(EPOCH FROM clock_timestamp() - v_start);

END;
$$;

