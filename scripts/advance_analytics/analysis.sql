
-- Chaange-Over-Time (TRENDS)
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

