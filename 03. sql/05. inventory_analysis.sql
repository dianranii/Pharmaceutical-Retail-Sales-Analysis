USE kimia_farma;


-- 1. OVERALL INVENTORY SUMMARY

-- Metric:
-- - Inventory Records
-- - Total Recorded Stock
-- - Average Recorded Stock
-- - Minimum Recorded Stock
-- - Maximum Recorded Stock


SELECT
    COUNT(*) AS inventory_records,

    SUM(opname_stock) AS total_recorded_stock,

    AVG(opname_stock) AS avg_recorded_stock,

    MIN(opname_stock) AS min_recorded_stock,

    MAX(opname_stock) AS max_recorded_stock

FROM inventory;


-- 2. STOCK DISTRIBUTION

SELECT
    opname_stock,

    COUNT(*) AS inventory_records

FROM inventory

GROUP BY
    opname_stock

ORDER BY
    opname_stock;


-- 3. ZERO-STOCK RATE BERDASARKAN PRODUCT

SELECT
    i.product_id,
    p.product_name,
    p.product_category,

    COUNT(*) AS inventory_records,

    SUM(
        CASE
            WHEN i.opname_stock = 0 THEN 1
            ELSE 0
        END
    ) AS zero_stock_records,

    SUM(
        CASE
            WHEN i.opname_stock = 0 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS zero_stock_rate

FROM inventory i

JOIN product p
    ON i.product_id = p.product_id

GROUP BY
    i.product_id,
    p.product_name,
    p.product_category

ORDER BY
    zero_stock_rate DESC;


-- 4. ZERO-STOCK RATE BERDASARKAN CABANG

SELECT
    i.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,

    COUNT(*) AS inventory_records,

    SUM(
        CASE
            WHEN i.opname_stock = 0 THEN 1
            ELSE 0
        END
    ) AS zero_stock_records,

    SUM(
        CASE
            WHEN i.opname_stock = 0 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS zero_stock_rate

FROM inventory i

JOIN cabang c
    ON i.branch_id = c.branch_id

GROUP BY
    i.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi

ORDER BY
    zero_stock_rate DESC;