USE kimia_farma;


-- 1. VALIDASI DISCOUNT

SELECT
    MIN(discount_percentage) AS min_discount,
    MAX(discount_percentage) AS max_discount,
    AVG(discount_percentage) AS avg_discount
FROM transaction;


-- 2. OVERALL SALES KPI
-- KPI utama:
-- Revenue      = total nilai transaksi setelah discount
-- Transactions = jumlah transaksi
-- AOV          = Revenue / jumlah transaksi

-- 2.1 Total Revenue
SELECT
    SUM(price * (1 - discount_percentage)) AS total_revenue
FROM transaction;


-- 2.2 Total Transactions
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM transaction;


-- 2.3 Average Transaction Value (AOV)
SELECT
    SUM(price * (1 - discount_percentage))
        / COUNT(DISTINCT transaction_id) AS aov
FROM transaction;


-- 3. PERIODE DATA
SELECT
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM transaction;


-- 4. MONTHLY SALES PERFORMANCE

SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(price * (1 - discount_percentage)) AS monthly_revenue,
    COUNT(DISTINCT transaction_id) AS monthly_transactions,
    SUM(price * (1 - discount_percentage))
        / COUNT(DISTINCT transaction_id) AS monthly_aov
FROM transaction
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;


-- 5. ANNUAL SALES PERFORMANCE

SELECT
    YEAR(date) AS year,
    SUM(price * (1 - discount_percentage)) AS annual_revenue,
    COUNT(DISTINCT transaction_id) AS annual_transactions,
    SUM(price * (1 - discount_percentage))
        / COUNT(DISTINCT transaction_id) AS annual_aov
FROM transaction
GROUP BY YEAR(date)
ORDER BY year;


-- 6. YEAR-OVER-YEAR (YoY) ANALYSIS

WITH yearly_sales AS (
    SELECT
        YEAR(date) AS year,
        SUM(price * (1 - discount_percentage)) AS revenue,
        COUNT(DISTINCT transaction_id) AS transactions,
        SUM(price * (1 - discount_percentage))
            / COUNT(DISTINCT transaction_id) AS aov
    FROM transaction
    GROUP BY YEAR(date)
)

SELECT
    year,
    revenue,
    transactions,
    aov,

    -- Perubahan Revenue dibanding tahun sebelumnya
    (
        revenue - LAG(revenue) OVER (ORDER BY year)
    )
    / LAG(revenue) OVER (ORDER BY year) * 100
        AS yoy_revenue,

    -- Perubahan Transactions dibanding tahun sebelumnya
    (
        transactions - LAG(transactions) OVER (ORDER BY year)
    )
    / LAG(transactions) OVER (ORDER BY year) * 100
        AS yoy_transactions,

    -- Perubahan AOV dibanding tahun sebelumnya
    (
        aov - LAG(aov) OVER (ORDER BY year)
    )
    / LAG(aov) OVER (ORDER BY year) * 100
        AS yoy_aov

FROM yearly_sales
ORDER BY year;