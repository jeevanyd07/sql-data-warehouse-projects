-- Creating Gold Layer for Customer -- 
CREATE VIEW gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_material_status AS material_status,
	CASE
		WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen,'N/A')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_dste AS create_date
	FROM bronz."silver.crm_cust_info" ci
	LEFT JOIN bronz."silver.erp_cust_az12" ca
	ON ci.cst_key = ca.cid
	LEFT JOIN bronz."silver.erp_loc_a101" la
ON ci.cst_key = la.cid

-- Creating Gold Layer for Product --
CREATE VIEW gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_nam,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM bronz."silver.crm_prd_info" pn
LEFT JOIN bronz."silver.erp_px_cat_g1v2" pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter out all histrical date


