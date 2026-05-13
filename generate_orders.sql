INSERT INTO orders (
    customer_id,
    store_id,
    order_date,
    total_amount
)
SELECT
    floor(random() * 10000 + 1)::INT,
    floor(random() * 5 + 1)::INT,
    CURRENT_DATE - (random() * 365)::INT,
    round((random() * 2000 + 20)::numeric, 2)
FROM generate_series(1,50000);