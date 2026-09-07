USE kimia_farma;


-- 1. BRANCH PERFORMANCE
-- Metric:
-- - Revenue
-- - Transactions
-- - AOV

SELECT
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.branch_category,
    c.rating,

    SUM(t.price * (1 - t.discount_percentage)) AS revenue,

    COUNT(DISTINCT t.transaction_id) AS transactions,

    SUM(t.price * (1 - t.discount_percentage))
        / COUNT(DISTINCT t.transaction_id) AS aov

FROM transaction t

JOIN cabang c
    ON t.branch_id = c.branch_id

GROUP BY
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.branch_category,
    c.rating

ORDER BY revenue DESC;


-- 2. PERFORMANCE BERDASARKAN RATING CABANG

WITH branch_performance AS (
    SELECT
        c.branch_id,
        c.rating,

        SUM(t.price * (1 - t.discount_percentage)) AS revenue,

        COUNT(DISTINCT t.transaction_id) AS transactions,

        SUM(t.price * (1 - t.discount_percentage))
            / COUNT(DISTINCT t.transaction_id) AS aov

    FROM transaction t

    JOIN cabang c
        ON t.branch_id = c.branch_id

    GROUP BY
        c.branch_id,
        c.rating
)

SELECT
    rating,
    COUNT(*) AS total_branches,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue_per_branch,
    AVG(transactions) AS avg_transactions_per_branch,
    AVG(aov) AS avg_aov

FROM branch_performance

GROUP BY rating

ORDER BY rating;


-- 3. KORELASI RATING DENGAN REVENUE

-- Nilai Pearson Correlation (r):
-- mendekati +1 = hubungan positif kuat
-- mendekati -1 = hubungan negatif kuat
-- mendekati  0 = tidak terdapat hubungan linear yang berarti

WITH branch_performance AS (
    SELECT
        c.branch_id,
        c.rating,

        SUM(t.price * (1 - t.discount_percentage)) AS revenue

    FROM transaction t

    JOIN cabang c
        ON t.branch_id = c.branch_id

    GROUP BY
        c.branch_id,
        c.rating
)

SELECT
    (
        COUNT(*) * SUM(rating * revenue)
        - SUM(rating) * SUM(revenue)
    )
    /
    SQRT(
        (
            COUNT(*) * SUM(rating * rating)
            - POWER(SUM(rating), 2)
        )
        *
        (
            COUNT(*) * SUM(revenue * revenue)
            - POWER(SUM(revenue), 2)
        )
    ) AS correlation_rating_revenue

FROM branch_performance;