
-- ===========================================================================================================================
-- Chaange-Over-Time (TRENDS)
-- ===========================================================================================================================

SELECT 
-- TO_CHAR(order_date, 'YYYY MON') AS order_date,
EXTRACT(YEAR FROM order_date) AS order_year,
EXTRACT(MONTH FROM order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(quantity) AS total_qty
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- =============================================================================================================================
-- Cumulative Analysis: Calculate the total sales per month and the running total of sales over time
-- ==============================================================================================================================

SELECT 
order_year_month,
total_sales,
SUM(total_sales) OVER (PARTITION BY order_year ORDER BY order_year_month) AS running_total,
AVG(avg_price) OVER (ORDER BY order_year_month) AS moving_avarage_price
FROM -- IF YOU WANT ADD PARTITION BY
(
SELECT
EXTRACT(YEAR FROM order_date) AS order_year,
TO_CHAR(order_date, 'YYYY-MM') AS order_year_month,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year,order_year_month
ORDER BY order_year_month
) t


-- ===========================================================================================================================================================================
-- Performance Analysis : Analyze the yearly performance of products by comparing there sales to both the average sales performance of the product and previous years's sales
-- ===========================================================================================================================================================================

WITH yearly_product_sales AS (
SELECT 
EXTRACT(YEAR FROM f.order_date) AS order_year,
p.product_nam,
SUM(f.sales_amount) AS current_sale
FROM gold.fact_sales f LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
group by order_year, p.product_nam
)
SELECT
order_year,
product_nam,
current_sale,
ROUND(AVG(current_sale) OVER (PARTITION BY product_nam)) AS age_sale,
current_sale - ROUND(AVG(current_sale) OVER (PARTITION BY product_nam)) AS diff_avg,
CASE 
	WHEN current_sale - ROUND(AVG(current_sale) OVER (PARTITION BY product_nam)) > 0 THEN 'Above Avg'
	WHEN current_sale - ROUND(AVG(current_sale) OVER (PARTITION BY product_nam)) <0 THEN 'Bealow Avg'
	ELSE 'Avg'
END avg_change,
-- Year Over Year Comparing --
LAG(current_sale) OVER (PARTITION BY product_nam ORDER BY order_year) AS pr_year_sale,
current_sale - LAG(current_sale) OVER (PARTITION BY product_nam ORDER BY order_year) AS diff_py,
CASE 
	WHEN current_sale - LAG(current_sale) OVER (PARTITION BY product_nam ORDER BY order_year) > 0 THEN 'Increase'
	WHEN current_sale - LAG(current_sale) OVER (PARTITION BY product_nam ORDER BY order_year) <0 THEN 'Decrease'
	ELSE 'No Change'
END py_chaange
FROM yearly_product_sales
ORDER BY product_nam, order_year;



-- =============================================================================================================================
-- Part to Whole: Which categories contribute the most to overall sales
-- ==============================================================================================================================

WITH category_sales AS(
SELECT
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales f LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category)

SELECT
category,
total_sales,
SUM(total_sales) OVER () AS overall_sales,
CONCAT(ROUND((total_sales / SUM(total_sales) OVER())*100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

















