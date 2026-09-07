USE kimia_farma;

-- 1. ROW COUNT
SELECT 
    'transaction' AS table_name,
    COUNT(*) AS row_count
FROM transaction

UNION ALL

SELECT 
    'cabang',
    COUNT(*)
FROM cabang

UNION ALL

SELECT 
    'product',
    COUNT(*)
FROM product

UNION ALL

SELECT 
    'inventory',
    COUNT(*)
FROM inventory;

-- 2. NULL CHECK

-- Transaction
SELECT
    SUM(transaction_id IS NULL) AS transaction_id_null,
    SUM(date IS NULL) AS date_null,
    SUM(branch_id IS NULL) AS branch_id_null,
    SUM(customer_name IS NULL) AS customer_name_null,
    SUM(product_id IS NULL) AS product_id_null,
    SUM(price IS NULL) AS price_null,
    SUM(discount_percentage IS NULL) AS discount_null,
    SUM(rating IS NULL) AS rating_null
FROM transaction;

-- Cabang
SELECT
    SUM(branch_id IS NULL) AS branch_id_null,
    SUM(branch_category IS NULL) AS category_null,
    SUM(branch_name IS NULL) AS branch_name_null,
    SUM(kota IS NULL) AS kota_null,
    SUM(provinsi IS NULL) AS provinsi_null,
    SUM(rating IS NULL) AS rating_null
FROM cabang;

-- Product
SELECT
    SUM(product_id IS NULL) AS product_id_null,
    SUM(product_name IS NULL) AS product_name_null,
    SUM(product_category IS NULL) AS category_null,
    SUM(price IS NULL) AS price_null
FROM product;

-- Inventory
SELECT
    SUM(Inventory_ID IS NULL) AS inventory_id_null,
    SUM(branch_id IS NULL) AS branch_id_null,
    SUM(product_id IS NULL) AS product_id_null,
    SUM(product_name IS NULL) AS product_name_null,
    SUM(opname_stock IS NULL) AS stock_null
FROM inventory;

-- 3. DUPLICATE CHECK

-- Transaction ID
SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM transaction
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Product ID
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Branch ID
SELECT
    branch_id,
    COUNT(*) AS duplicate_count
FROM cabang
GROUP BY branch_id
HAVING COUNT(*) > 1;

-- Inventory ID
SELECT
    Inventory_ID,
    COUNT(*) AS duplicate_count
FROM inventory
GROUP BY Inventory_ID
HAVING COUNT(*) > 1;

-- 4. TRANSACTION GRAIN VALIDATION
-- 1 row = 1 transaction

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT branch_id) AS unique_branches
FROM transaction;


-- (Memastikan satu transaction_id hanya memiliki satu product dan satu branch)

SELECT
    transaction_id,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT branch_id) AS unique_branches
FROM transaction
GROUP BY transaction_id
HAVING COUNT(DISTINCT product_id) > 1
    OR COUNT(DISTINCT branch_id) > 1;


-- 5. TABLE GRAIN VALIDATION

-- Product
-- Grain: 1 row = 1 product
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM product;

-- Cabang
-- Grain: 1 row = 1 branch

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT branch_id) AS unique_branches
FROM cabang;

-- Inventory
-- Grain: 1 row = 1 inventory record

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Inventory_ID) AS unique_inventory_records
FROM inventory;


-- 6. INVENTORY GRAIN & REPETITION CHECK
-- (Mengetahui apakah branch + product dapat muncul lebih dari satu kali)
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT branch_id, product_id) AS unique_branch_product
FROM inventory;

SELECT
    COUNT(*) AS number_of_branch_product_combinations,
    MIN(record_count) AS minimum_records,
    MAX(record_count) AS maximum_records,
    AVG(record_count) AS average_records
FROM (
    SELECT
        branch_id,
        product_id,
        COUNT(*) AS record_count
    FROM inventory
    GROUP BY branch_id, product_id
) AS inventory_summary;


-- (Memastikan repeated branch-product records bukan sekadar duplicate identik)
SELECT
    branch_id,
    product_id,
    COUNT(*) AS record_count,
    COUNT(DISTINCT product_name) AS product_name_variations,
    COUNT(DISTINCT opname_stock) AS stock_variations,
    MIN(opname_stock) AS min_stock,
    MAX(opname_stock) AS max_stock
FROM inventory
GROUP BY branch_id, product_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 10;

-- (Mengecek apakah Inventory_ID dapat digunakan sebagai indikator urutan waktu)
SELECT
    branch_id,
    product_id,
    COUNT(*) AS record_count,
    MIN(Inventory_ID) AS first_inventory_id,
    MAX(Inventory_ID) AS last_inventory_id
FROM inventory
GROUP BY branch_id, product_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 10;


-- 7. RELATIONSHIP VALIDATION

-- Transaction → Product
SELECT COUNT(*) AS unmatched_product
FROM transaction t
LEFT JOIN product p
    ON t.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Transaction → Cabang
SELECT COUNT(*) AS unmatched_branch
FROM transaction t
LEFT JOIN cabang c
    ON t.branch_id = c.branch_id
WHERE c.branch_id IS NULL;


-- Inventory → Product
SELECT COUNT(*) AS unmatched_inventory_product
FROM inventory i
LEFT JOIN product p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Inventory → Cabang
SELECT COUNT(*) AS unmatched_inventory_branch
FROM inventory i
LEFT JOIN cabang c
    ON i.branch_id = c.branch_id
WHERE c.branch_id IS NULL;

-- =========================================================
-- VALIDATION SUMMARY
-- =========================================================

-- Transaction:
-- Grain = 1 baris merepresentasikan 1 transaksi
-- transaction_id bersifat unik
-- Tidak ditemukan nilai NULL
--
-- Product:
-- Grain = 1 baris merepresentasikan 1 produk
-- product_id bersifat unik
-- Tidak ditemukan nilai NULL
--
-- Cabang:
-- Grain = 1 baris merepresentasikan 1 cabang
-- branch_id bersifat unik
-- Tidak ditemukan nilai NULL
--
-- Inventory:
-- Grain = 1 baris merepresentasikan 1 inventory record
-- Inventory_ID bersifat unik
-- Kombinasi branch_id + product_id dapat muncul lebih dari satu kali
-- Nilai opname_stock berbeda pada beberapa record berulang
-- Tidak terdapat kolom tanggal/snapshot inventory
--
-- Keterbatasan Inventory:
-- Stok terkini/terbaru tidak dapat ditentukan karena inventory tidak memiliki kolom tanggal/snapshot.
-- =========================================================