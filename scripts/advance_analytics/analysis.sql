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
