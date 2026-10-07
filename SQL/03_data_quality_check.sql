-- 01: Inspectiion of table structure
-- Review columns and data types before running primary-key, duplicate, and relationship checks
SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name IN (
      'campaign_desc',
      'campaign_table',
      'causal_data',
      'coupon',
      'coupon_redempt',
      'hh_demographic',
      'product',
      'transaction_data'
  )
ORDER BY
    table_name,
    ordinal_position;

-- 02: Inspect existing primary-key and foreign-key constraints
-- Determine which relationships are already enforced by PostgreSQL before performing manual validation
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
   AND tc.table_name = kcu.table_name
WHERE tc.table_schema = 'raw'
  AND tc.table_name IN (
      'campaign_desc',
      'campaign_table',
      'causal_data',
      'coupon',
      'coupon_redempt',
      'hh_demographic',
      'product',
      'transaction_data'
  )
ORDER BY
    tc.table_name,
    tc.constraint_type,
    kcu.ordinal_position;

-- 03: Validate uniqueness of expected entity identifiers
-- Identify duplicate values in tables where an ID should represent a unique entity
SELECT
    'hh_demographic.household_key' AS identifier,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT household_key) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT household_key) AS duplicate_rows
FROM raw.hh_demographic

UNION ALL

SELECT
    'product.product_id' AS identifier,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_rows
FROM raw.product

UNION ALL

SELECT
    'campaign_desc.campaign' AS identifier,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT campaign) AS duplicate_rows
FROM raw.campaign_desc;

-- 04: Identify exact duplicate records
-- Determine whether reference tables contain completely duplicated rows
SELECT
    'campaign_desc' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (description, campaign, start_day, end_day))
        AS duplicate_rows
FROM raw.campaign_desc

UNION ALL

SELECT
    'campaign_table' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (description, household_key, campaign))
        AS duplicate_rows
FROM raw.campaign_table

UNION ALL

SELECT
    'coupon' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (coupon_upc, product_id, campaign))
        AS duplicate_rows
FROM raw.coupon

UNION ALL

SELECT
    'coupon_redempt' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (household_key, day, coupon_upc, campaign))
        AS duplicate_rows
FROM raw.coupon_redempt

UNION ALL

SELECT
    'product' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT (
        product_id,
        manufacturer,
        department,
        brand,
        commodity_desc,
        sub_commodity_desc,
        curr_size_of_product
    )) AS duplicate_rows
FROM raw.product;

-- 05: Validate transaction-to-household relationships
-- Identify transaction records whose household_key does not exist in the household demographic table
SELECT
    COUNT(*) AS orphan_transaction_rows,
    COUNT(DISTINCT t.household_key) AS orphan_households
FROM raw.transaction_data AS t
LEFT JOIN raw.hh_demographic AS h
    ON t.household_key = h.household_key
WHERE h.household_key IS NULL;

-- 06: Validate transaction-to-product relationships
-- Identify transaction records whose product_id does not exist in the product reference table
SELECT
    COUNT(*) AS orphan_transaction_rows,
    COUNT(DISTINCT t.product_id) AS orphan_products
FROM raw.transaction_data AS t
LEFT JOIN raw.product AS p
    ON t.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 07: Validate coupon-to-product relationships
-- Identify coupon records whose product_id does not exist in the product reference table
SELECT
    COUNT(*) AS orphan_coupon_rows,
    COUNT(DISTINCT c.product_id) AS orphan_products
FROM raw.coupon AS c
LEFT JOIN raw.product AS p
    ON c.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 08: Validate coupon-redemption-to-coupon relationships
-- Identify redemption records whose coupon_upc does not exist in the coupon reference table
SELECT
    COUNT(*) AS orphan_redemption_rows,
    COUNT(DISTINCT r.coupon_upc) AS orphan_coupons
FROM raw.coupon_redempt AS r
LEFT JOIN raw.coupon AS c
    ON r.coupon_upc = c.coupon_upc
WHERE c.coupon_upc IS NULL;

-- 09: Validate campaign references
-- Identify campaign IDs appearing in related tables that do not exist in the campaign description table
SELECT
    'campaign_table' AS source_table,
    COUNT(*) AS orphan_rows,
    COUNT(DISTINCT ct.campaign) AS orphan_campaigns
FROM raw.campaign_table AS ct
LEFT JOIN raw.campaign_desc AS cd
    ON ct.campaign = cd.campaign
WHERE cd.campaign IS NULL

UNION ALL

SELECT
    'coupon' AS source_table,
    COUNT(*) AS orphan_rows,
    COUNT(DISTINCT c.campaign) AS orphan_campaigns
FROM raw.coupon AS c
LEFT JOIN raw.campaign_desc AS cd
    ON c.campaign = cd.campaign
WHERE cd.campaign IS NULL;

-- 10: Validate transaction quantity and sales values
-- Identify zero/negative quantities and sales values that may require special treatment during analysis
SELECT
    COUNT(*) FILTER (WHERE quantity < 0) AS negative_quantity_rows,
    COUNT(*) FILTER (WHERE quantity = 0) AS zero_quantity_rows,
    COUNT(*) FILTER (WHERE sales_value < 0) AS negative_sales_rows,
    COUNT(*) FILTER (WHERE sales_value = 0) AS zero_sales_rows
FROM raw.transaction_data;

-- 11: Investigate negative sales transactions
-- Determine whether negative sales values represent legitimate returns/adjustments or data errors
SELECT
    quantity,
    sales_value,
    COUNT(*) AS transaction_rows
FROM raw.transaction_data
WHERE quantity < 0
   OR sales_value < 0
GROUP BY
    quantity,
    sales_value
ORDER BY
    transaction_rows DESC;

-- 12: Inspect transaction value relationships
-- Examine sales, retail price, quantity, and discount fields before defining business-rule validations
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE sales_value IS NULL) AS null_sales_value,
    COUNT(*) FILTER (WHERE retail_disc IS NULL) AS null_retail_disc,
    COUNT(*) FILTER (WHERE coupon_disc IS NULL) AS null_coupon_disc,
    COUNT(*) FILTER (WHERE coupon_match_disc IS NULL) AS null_coupon_match_disc
FROM raw.transaction_data;

-- 13: Investigate zero quantity and zero sales values
-- Determine whether zero-value transaction records follow a consistent pattern before sales analysis
SELECT
    quantity,
    sales_value,
    COUNT(*) AS transaction_rows
FROM raw.transaction_data
WHERE quantity = 0
   OR sales_value = 0
GROUP BY
    quantity,
    sales_value
ORDER BY
    transaction_rows DESC;

-- 14: Validate discount value ranges
-- Identify unusual positive discount values and summarize the range of discount-related fields
SELECT
    MIN(retail_disc) AS min_retail_disc,
    MAX(retail_disc) AS max_retail_disc,
    MIN(coupon_disc) AS min_coupon_disc,
    MAX(coupon_disc) AS max_coupon_disc,
    MIN(coupon_match_disc) AS min_coupon_match_disc,
    MAX(coupon_match_disc) AS max_coupon_match_disc,
    COUNT(*) FILTER (WHERE retail_disc > 0) AS positive_retail_disc_rows,
    COUNT(*) FILTER (WHERE coupon_disc > 0) AS positive_coupon_disc_rows,
    COUNT(*) FILTER (WHERE coupon_match_disc > 0) AS positive_coupon_match_disc_rows
FROM raw.transaction_data;
/* From the above query (14), The important observation is that coupon discounts are always zero or negative, which is consistent with a discount being represented as a deduction.

retail_disc has 10 positive values, so rather than declaring those errors, we have to inspect those exact records. */

-- 15: Investigate positive retail discount values
-- Inspect the small number of transactions where retail_disc is positive instead of zero/negative
SELECT
    household_key,
    basket_id,
    day,
    product_id,
    quantity,
    sales_value,
    retail_disc,
    coupon_disc,
    coupon_match_disc
FROM raw.transaction_data
WHERE retail_disc > 0
ORDER BY retail_disc DESC;