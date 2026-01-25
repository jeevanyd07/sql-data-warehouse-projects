-- Creating Silver Layer Customer Information --
TRUNCATE TABLE bronz."silver.crm_cust_info";
INSERT INTO bronz."silver.crm_cust_info"(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gndr,
	cst_create_dste
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname),
TRIM(cst_lastname),
CASE
	WHEN cst_material_status = 'M' THEN 'Married'
	WHEN cst_material_status = 'S' THEN 'Single'
	ELSE 'N/A'
END cst_material_status,
CASE
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM(
SELECT 
* ,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronz."bronze.crm_cust_info")T
WHERE flag_last = 1;

-------------------------------------------------------
-------------------------------------------------------
-- Creating Silver Layer Product Information --
SELECT * FROM bronz."silver.crm_prd_info";
TRUNCATE TABLE bronz."silver.crm_prd_info";
INSERT INTO bronz."silver.crm_prd_info"(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT  
prd_id,
REPLACE(SUBSTRING(prd_key,1, 5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7,LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
CASE
	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'N/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt 
FROM bronz."bronze.crm_prd_info";
