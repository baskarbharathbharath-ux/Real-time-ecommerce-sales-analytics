-- 1. Overall project KPIs
SELECT COUNT(*) AS total_orders,
       SUM(quantity) AS units_sold,
       ROUND(SUM(net_amount), 2) AS total_order_value,
       ROUND(AVG(net_amount), 2) AS average_order_value,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM ecommerce_orders;

-- 2. Revenue from completed orders by day
SELECT TRUNC(CAST(order_timestamp AS DATE)) AS sales_date,
       COUNT(*) AS completed_orders,
       ROUND(SUM(net_amount), 2) AS revenue
FROM ecommerce_orders
WHERE order_status = 'COMPLETED'
GROUP BY TRUNC(CAST(order_timestamp AS DATE))
ORDER BY sales_date;

-- 3. Best-performing products
SELECT product_name, category,
       SUM(quantity) AS units_sold,
       ROUND(SUM(net_amount), 2) AS revenue
FROM ecommerce_orders
WHERE order_status = 'COMPLETED'
GROUP BY product_name, category
ORDER BY revenue DESC;

-- 4. Category performance
SELECT category,
       COUNT(*) AS order_count,
       ROUND(SUM(net_amount), 2) AS revenue
FROM ecommerce_orders
WHERE order_status = 'COMPLETED'
GROUP BY category
ORDER BY revenue DESC;

-- 5. Payment method summary
SELECT payment_method, COUNT(*) AS order_count,
       ROUND(SUM(net_amount), 2) AS order_value
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- 6. City performance
SELECT city, COUNT(*) AS order_count,
       ROUND(SUM(net_amount), 2) AS order_value
FROM ecommerce_orders
GROUP BY city
ORDER BY order_value DESC;

-- 7. Cancellation rate
SELECT COUNT(*) AS total_orders,
       SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders,
       ROUND(
         100 * SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0), 2
       ) AS cancellation_pct
FROM ecommerce_orders;

-- 8. Most recent orders
SELECT order_id, order_timestamp, product_name, quantity,
       net_amount, city, payment_method, order_status
FROM ecommerce_orders
ORDER BY order_timestamp DESC
FETCH FIRST 20 ROWS ONLY;
