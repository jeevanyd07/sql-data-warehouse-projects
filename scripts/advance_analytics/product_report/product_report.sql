/*
============================================================================================================================
Product Report
============================================================================================================================
Purpose:
  - This report consolidates key produtc metrics and behaviors

Highlights:
  1. Gathers essential fields such as product name, category, subcategory, and cost.
  2. Segments product by revenue to identify High-Performance, Mid-Range, or Low-Range, or Low-Performers
  3. Aggregates product-level metrics:
    - total orders
    - total sales
    - total quantity sold
    - total customers (unique)
    - lifespan (in months)
  4. Calculates valuable KPIs:
    - recency (month since last sale)
    - avarage order revenue (AOR)
    - average monthly revenue
============================================================================================================================
*/

CREATE OR REPLACE VIEW gold.report_products AS

WITH base_query AS(
/*--------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------*/
	SELECT 
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_nam,
		p.category,
		p.subcategory,
		p.cost AS cost_
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
),

product_aggregation AS(
/*--------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------*/
SELECT 
	product_key,
	product_nam,
	category,
	subcategory,
	cost_,
	DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS tatal_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(
		AVG(sales_amount / NULLIF(quantity, 0))::NUMERIC,
		2
	) AS avg_selling_price
FROM base_query
GROUP BY
	product_key,
	product_nam,
	category,
	subcategory,
	cost_
)

/*-------------------------------------------------------------
3) Final Query
--------------------------------------------------------------*/
SELECT
	product_key,
	product_nam,
	category,
	subcategory,
	cost_,
	last_sale_date,

	DATE_PART('month', AGE(CURRENT_DATE, last_sale_date)) AS recency_in_month,

	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,

	lifespan,
	total_orders,
	tatal_customers,
	total_sales,
	total_quantity,
	avg_selling_price,

	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregation;
