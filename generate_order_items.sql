INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    item_total
)
SELECT
    floor(random() * 50000 + 1)::INT,
    floor(random() * 20 + 1)::INT,
    floor(random() * 5 + 1)::INT,
    round((random() * 1000 + 10)::numeric, 2)
FROM generate_series(1,100000);