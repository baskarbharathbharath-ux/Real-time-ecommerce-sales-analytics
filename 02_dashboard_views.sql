CREATE OR REPLACE VIEW v_sales_daily AS
SELECT TRUNC(CAST(order_timestamp AS DATE)) AS sales_date,
       COUNT(DISTINCT order_id) AS total_orders,
       SUM(quantity) AS units_sold,
       SUM(CASE WHEN order_status = 'COMPLETED' THEN net_amount ELSE 0 END) AS completed_revenue,
       SUM(net_amount) AS all_order_value
FROM ecommerce_orders
GROUP BY TRUNC(CAST(order_timestamp AS DATE));

CREATE OR REPLACE VIEW v_product_performance AS
SELECT product_id, product_name, category,
       COUNT(DISTINCT order_id) AS order_count,
       SUM(quantity) AS units_sold,
       SUM(net_amount) AS revenue
FROM ecommerce_orders
WHERE order_status = 'COMPLETED'
GROUP BY product_id, product_name, category;

CREATE OR REPLACE VIEW v_category_performance AS
SELECT category,
       COUNT(DISTINCT order_id) AS order_count,
       SUM(quantity) AS units_sold,
       SUM(net_amount) AS revenue
FROM ecommerce_orders
WHERE order_status = 'COMPLETED'
GROUP BY category;

CREATE OR REPLACE VIEW v_payment_summary AS
SELECT payment_method,
       COUNT(DISTINCT order_id) AS order_count,
       SUM(net_amount) AS order_value
FROM ecommerce_orders
GROUP BY payment_method;

CREATE OR REPLACE VIEW v_latest_orders AS
SELECT order_id, order_timestamp, customer_id, product_name, category,
       quantity, net_amount, payment_method, city, order_status
FROM ecommerce_orders;
