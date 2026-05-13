INSERT INTO customers (
    first_name,
    last_name,
    city,
    state,
    signup_date
)
SELECT
    'Customer_' || gs,
    'Last_' || gs,
    (ARRAY['Dallas','Plano','Austin','Houston','Frisco'])[floor(random()*5 + 1)],
    'TX',
    CURRENT_DATE - (random() * 365)::INT
FROM generate_series(1,10000) AS gs;