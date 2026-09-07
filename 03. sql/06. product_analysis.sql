USE kimia_farma;


-- 1. TOP 10 PRODUCT BERDASARKAN REVENUE
-- Metric:
-- - Revenue
-- - Transactions
-- - AOV

SELECT
    p.product_id,
    p.product_name,
    p.product_category,

    SUM(t.price * (1 - t.discount_percentage)) AS revenue,

    COUNT(DISTINCT t.transaction_id) AS transactions,

    SUM(t.price * (1 - t.discount_percentage))
        / COUNT(DISTINCT t.transaction_id) AS aov

FROM transaction t

JOIN product p
    ON t.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.product_category

ORDER BY revenue DESC

LIMIT 10;


-- 2. TOP 10 PRODUCT BERDASARKAN TRANSACTIONS

SELECT
    p.product_id,
    p.product_name,
    p.product_category,

    COUNT(DISTINCT t.transaction_id) AS transactions,

    SUM(t.price * (1 - t.discount_percentage)) AS revenue,

    SUM(t.price * (1 - t.discount_percentage))
        / COUNT(DISTINCT t.transaction_id) AS aov

FROM transaction t

JOIN product p
    ON t.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.product_category

ORDER BY transactions DESC

LIMIT 10;


-- 3. PRODUCT CATEGORY PERFORMANCE

SELECT
    p.product_category,

    SUM(t.price * (1 - t.discount_percentage)) AS revenue,

    COUNT(DISTINCT t.transaction_id) AS transactions,

    SUM(t.price * (1 - t.discount_percentage))
        / COUNT(DISTINCT t.transaction_id) AS aov

FROM transaction t

JOIN product p
    ON t.product_id = p.product_id

GROUP BY
    p.product_category

ORDER BY revenue DESC;


-- 4. REVENUE SHARE BERDASARKAN PRODUCT CATEGORY

WITH category_sales AS (
    SELECT
        p.product_category,

        SUM(t.price * (1 - t.discount_percentage)) AS revenue,

        COUNT(DISTINCT t.transaction_id) AS transactions,

        SUM(t.price * (1 - t.discount_percentage))
            / COUNT(DISTINCT t.transaction_id) AS aov

    FROM transaction t

    JOIN product p
        ON t.product_id = p.product_id

    GROUP BY
        p.product_category
)

SELECT
    product_category,
    revenue,
    transactions,
    aov,

    revenue / SUM(revenue) OVER () * 100 AS revenue_share

FROM category_sales

ORDER BY revenue DESC;