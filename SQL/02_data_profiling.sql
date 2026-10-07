-- OVERALL TRANSACTION DATA SCOPE
SELECT
    MIN(day) AS first_day,
    MAX(day) AS last_day,
    COUNT(DISTINCT household_key) AS unique_households,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT store_id) AS unique_stores,
    COUNT(DISTINCT basket_id) AS unique_baskets
FROM raw.transaction_data;

-- TRANSACTION TABLE SIZE AND NULL VALUE CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE household_key IS NULL) AS null_household_key,
    COUNT(*) FILTER (WHERE basket_id IS NULL) AS null_basket_id,
    COUNT(*) FILTER (WHERE day IS NULL) AS null_day,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE store_id IS NULL) AS null_store_id,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE sales_value IS NULL) AS null_sales_value
FROM raw.transaction_data;

-- DUPLICATE TRANSACTION LINE CHECK
-- Checks whether the same household, basket, and product combination appears more than once.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (household_key, basket_id, product_id)) AS unique_transaction_lines
FROM raw.transaction_data;

-- QUANTITY AND SALES VALUE RANGE CHECK
-- Examines the minimum, maximum, and average values to identify unusual numeric ranges.
SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(quantity) AS avg_quantity,
    MIN(sales_value) AS min_sales_value,
    MAX(sales_value) AS max_sales_value,
    AVG(sales_value) AS avg_sales_value
FROM raw.transaction_data;

-- ZERO, NEGATIVE, AND EXTREME VALUE CHECK
-- Identifies zero/negative values and unusually large quantities for further investigation.
SELECT
    COUNT(*) FILTER (WHERE quantity = 0) AS zero_quantity_rows,
    COUNT(*) FILTER (WHERE quantity < 0) AS negative_quantity_rows,
    COUNT(*) FILTER (WHERE quantity > 100) AS quantity_over_100,
    COUNT(*) FILTER (WHERE quantity > 1000) AS quantity_over_1000,
    COUNT(*) FILTER (WHERE sales_value = 0) AS zero_sales_rows,
    COUNT(*) FILTER (WHERE sales_value < 0) AS negative_sales_rows
FROM raw.transaction_data;

-- EXTREME QUANTITY DISTRIBUTION
-- Examines the products and sales associated with the highest recorded quantities.
SELECT
    quantity,
    COUNT(*) AS row_count,
    SUM(sales_value) AS total_sales
FROM raw.transaction_data
GROUP BY quantity
ORDER BY quantity DESC
LIMIT 20;

-- LOW SALES VALUE DISTRIBUTION
-- Examines the frequency and quantity associated with the lowest sales values, including zero-sales transactions.
SELECT
    sales_value,
    COUNT(*) AS row_count,
    SUM(quantity) AS total_quantity
FROM raw.transaction_data
GROUP BY sales_value
ORDER BY sales_value
LIMIT 20;

-- PRODUCT-LEVEL QUANTITY ANOMALY INVESTIGATION
-- Identifies products associated with unusually high quantities and compares their transaction activity and sales contribution.
SELECT
    product_id,
    COUNT(*) AS transaction_lines,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(quantity) AS avg_quantity,
    SUM(quantity) AS total_quantity,
    SUM(sales_value) AS total_sales
FROM raw.transaction_data
GROUP BY product_id
ORDER BY max_quantity DESC
LIMIT 20;

-- EXTREME QUANTITY TRANSACTION INVESTIGATION
-- Examines individual transactions with quantities above 1,000 to determine whether the values represent genuine transaction patterns.
SELECT
    product_id,
    quantity,
    sales_value,
    household_key,
    basket_id,
    store_id,
    day
FROM raw.transaction_data
WHERE quantity > 1000
ORDER BY quantity DESC
LIMIT 20;

-- ZERO-SALES PRODUCT INVESTIGATION
-- Identifies products with the highest number of zero-sales transaction lines and their associated quantities.
SELECT
    product_id,
    COUNT(*) AS zero_sales_lines,
    SUM(quantity) AS total_quantity
FROM raw.transaction_data
WHERE sales_value = 0
GROUP BY product_id
ORDER BY zero_sales_lines DESC
LIMIT 20;

-- ANOMALOUS PRODUCT ATTRIBUTE CHECK
-- Examines the product descriptions and classifications associated with extreme-quantity and zero-sales products.
SELECT *
FROM raw.product
WHERE product_id IN (
    6534178,
    6544236,
    5978656,
    5978648
);
/* The result of above query shows that those huge quantities are associated with gasoline transactions.
For example, 6534178 has a transaction with:
quantity = 89,638
sales value = $250
That is completely different from a normal grocery product where we'd expect quantity to represent "number of items." Therefore, quantity is not directly comparable across all product types. */

-- SALES AND QUANTITY PROFILE BY DEPARTMENT
-- Compares transaction activity, product coverage, sales, quantity, and zero-sales records across departments.
SELECT
    p.department,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT t.product_id) AS unique_products,
    SUM(t.sales_value) AS total_sales,
    SUM(t.quantity) AS total_quantity,
    COUNT(*) FILTER (WHERE t.sales_value = 0) AS zero_sales_lines
FROM raw.transaction_data t
JOIN raw.product p
ON t.product_id = p.product_id
GROUP BY p.department
ORDER BY total_sales DESC;

-- SALES AND ZERO-SALES PROFILE BY DEPARTMENT/COMMODITY
-- Provides a more detailed view of sales performance and zero-sales activity across product categories.
SELECT
    p.department,
    p.commodity_desc,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT t.product_id) AS unique_products,
    SUM(t.sales_value) AS total_sales,
    COUNT(*) FILTER (WHERE t.sales_value = 0) AS zero_sales_lines
FROM raw.transaction_data t
JOIN raw.product p
    ON t.product_id = p.product_id
GROUP BY
    p.department,
    p.commodity_desc
ORDER BY total_sales DESC
LIMIT 30;