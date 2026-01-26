-- Find Out Any Duplicates --
SELECT cst_id, COUNT(*) FROM( 
SELECT 
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_material_status,
ci.cst_gndr,
ci.cst_create_dste,
ca.bdate,
ca.gen,
la.cntry
FROM bronz."silver.crm_cust_info" ci
LEFT JOIN bronz."silver.erp_cust_az12" ca
ON ci.cst_key = ca.cid
LEFT JOIN bronz."silver.erp_loc_a101" la
ON ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*)>1;

-- Data Integration Gender in customer information --
SELECT DISTINCT 
ci.cst_gndr,
ca.gen,
CASE
	WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen,'N/A')
END AS new_gen
FROM bronz."silver.crm_cust_info" ci
LEFT JOIN bronz."silver.erp_cust_az12" ca
ON ci.cst_key = ca.cid
LEFT JOIN bronz."silver.erp_loc_a101" la
ON ci.cst_key = la.cid
ORDER BY 1,2;
