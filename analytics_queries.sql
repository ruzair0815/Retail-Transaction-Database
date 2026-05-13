

-- TOP PRODUCTS BY REVENUE

SELECT
    p.product_name,
    SUM(oi.item_total) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- TOP 10 CUSTOMERS BY TOTAL SPENDING

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;



-- MONTHLY REVENUE

SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;


-- STORE PERFORMANCE

SELECT
    s.store_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM stores s
JOIN orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;


-- PRODUCT CATEGORY PERFORMANCE

SELECT
    p.category,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.item_total), 2) AS category_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- AVERAGE CUSTOMER SPENDING

SELECT
    ROUND(AVG(customer_total), 2) AS avg_customer_spending
FROM (
    SELECT
        customer_id,
        SUM(total_amount) AS customer_total
    FROM orders
    GROUP BY customer_id
) AS customer_spending;


-- CUSTOMERS WITH MORE THAN 10 ORDERS

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > 10
ORDER BY total_orders DESC;


-- TOP PRODUCTS BY QUANTITY SOLD

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;


-- DAILY SALES TREND

SELECT
    order_date,
    ROUND(SUM(total_amount), 2) AS daily_sales
FROM orders
GROUP BY order_date
ORDER BY order_date;


-- HIGHEST VALUE ORDERS

SELECT
    order_id,
    customer_id,
    total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 20;



-- RANK CUSTOMERS BY TOTAL SPENDING

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent,

    RANK() OVER (
        ORDER BY SUM(o.total_amount) DESC
    ) AS spending_rank

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY spending_rank;



-- RUNNING TOTAL OF SALES

SELECT
    order_date,

    ROUND(SUM(total_amount), 2) AS daily_sales,

    ROUND(
        SUM(SUM(total_amount)) OVER (
            ORDER BY order_date
        ),
        2
    ) AS running_total_sales

FROM orders

GROUP BY order_date

ORDER BY order_date;


-- TOP 5 PRODUCTS PER CATEGORY


SELECT *
FROM (

    SELECT
        p.category,
        p.product_name,
        ROUND(SUM(oi.item_total), 2) AS revenue,

        RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.item_total) DESC
        ) AS product_rank

    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id

    GROUP BY
        p.category,
        p.product_name

) ranked_products

WHERE product_rank <= 5

ORDER BY
    category,
    product_rank;


-- CUSTOMER LIFETIME VALUE (CLV)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,

    COUNT(o.order_id) AS total_orders,

    ROUND(SUM(o.total_amount), 2) AS lifetime_value,

    ROUND(AVG(o.total_amount), 2) AS avg_order_value

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY lifetime_value DESC;

-- REPEAT CUSTOMERS

SELECT
    COUNT(*) AS repeat_customers
FROM (

    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1

) repeat_customer_table;


-- MOST POPULAR STORE BY ORDER COUNT

SELECT
    s.store_name,
    COUNT(o.order_id) AS order_count
FROM stores s
JOIN orders o
    ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY order_count DESC;


-- SALES BY CITY

SELECT
    s.city,
    ROUND(SUM(o.total_amount), 2) AS city_revenue
FROM stores s
JOIN orders o
    ON s.store_id = o.store_id
GROUP BY s.city
ORDER BY city_revenue DESC;