/*
===============================================================================================================================
Customer Report
===============================================================================================================================
Purpose:
    - This Report consolidates key customer matrics and behaviours

Highlights:
    1. Gathers essential fields such as names, ages, nad transcations details.
    2. Segments customers into categories (VIP, Regular, New) and age gropus.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calcultes valuable KPIs:
        - recency (month since last order)
        - average order value
        - average manthly spend
================================================================================================================================
*/

CREATE OR REPLACE VIEW gold.report_customer AS

WITH base_query AS (
/*--------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS fullname,
    DATE_PART('year', AGE(CURRENT_DATE, c.birthdate)) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
),

customer_aggragation AS (
/*--------------------------------------------------------------------
2) Customer Aggregation: Summarizes key metrics at the customer level
----------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    fullname,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM base_query
GROUP BY
    customer_key,
    customer_number,
    fullname,
    age
)

SELECT 
    customer_key,
    customer_number,
    fullname,
    age,

    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_segment,

    CASE 
        WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,
    lifespan

FROM customer_aggragation;
