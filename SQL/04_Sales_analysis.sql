SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'transaction_data'
ORDER BY ordinal_position;

-- SECTION 1: Overall Sales KPIs
-- Calculate the core sales KPIs from transaction-level data. Measures total sales, units sold, households, baskets, products, and average basket value.
SELECT
    COUNT(*) AS transaction_rows,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales_value), 2) AS total_sales,
    COUNT(DISTINCT household_key) AS unique_households,
    COUNT(DISTINCT basket_id) AS unique_baskets,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(
        SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0),
        2
    ) AS avg_basket_value
FROM raw.transaction_data;

-- SECTION 2: Time-Based Sales Trends
-- Weekly analysis
-- Analyze weekly sales performance to identify changes in sales, units sold, baskets, and average basket value over time.
SELECT
    week_no,
    COUNT(DISTINCT basket_id) AS unique_baskets,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales_value), 2) AS total_sales,
    ROUND(
        SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0),
        2
    ) AS avg_basket_value
FROM raw.transaction_data
GROUP BY week_no
ORDER BY week_no;

-- daily analysis
-- Analyze daily sales performance to identify short-term fluctuations and understand the underlying sales trend.
SELECT
    day,
    COUNT(DISTINCT basket_id) AS unique_baskets,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales_value), 2) AS total_sales,
    ROUND(
        SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0),
        2
    ) AS avg_basket_value
FROM raw.transaction_data
GROUP BY day
ORDER BY day;

-- Quantify the trend
-- average basket value to identify growth patterns and significant weekly fluctuations.
WITH weekly_sales AS (
    SELECT
        week_no,
        COUNT(DISTINCT basket_id) AS unique_baskets,
        SUM(quantity) AS total_units_sold,
        SUM(sales_value) AS total_sales,
        SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0)
            AS avg_basket_value
    FROM raw.transaction_data
    GROUP BY week_no
),

weekly_change AS (
    SELECT
        week_no,
        unique_baskets,
        total_units_sold,
        total_sales,
        avg_basket_value,

        LAG(total_sales) OVER (
            ORDER BY week_no
        ) AS previous_week_sales,

        LAG(unique_baskets) OVER (
            ORDER BY week_no
        ) AS previous_week_baskets,

        LAG(avg_basket_value) OVER (
            ORDER BY week_no
        ) AS previous_week_avg_basket

    FROM weekly_sales
)

SELECT
    week_no,
    unique_baskets,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(avg_basket_value, 2) AS avg_basket_value,

    ROUND(
        100.0 * (total_sales - previous_week_sales)
        / NULLIF(previous_week_sales, 0),
        2
    ) AS sales_change_pct,

    ROUND(
        100.0 * (unique_baskets - previous_week_baskets)
        / NULLIF(previous_week_baskets, 0),
        2
    ) AS basket_change_pct,

    ROUND(
        100.0 * (avg_basket_value - previous_week_avg_basket)
        / NULLIF(previous_week_avg_basket, 0),
        2
    ) AS avg_basket_change_pct

FROM weekly_change
ORDER BY week_no;


-- SECTION 3: PRODUCT-LEVEL FEATURES
-- Create product-level behavioral and sales features.
SELECT
    t.product_id,
    p.department,
    p.brand,
    p.commodity_desc,
    p.sub_commodity_desc,
    p.manufacturer,
    p.curr_size_of_product,
    SUM(t.quantity) AS total_units_sold,
    ROUND(SUM(t.sales_value), 2) AS total_sales,
    COUNT(DISTINCT t.household_key) AS unique_households,
    COUNT(DISTINCT t.basket_id) AS unique_baskets,
    ROUND(SUM(t.sales_value)/ NULLIF(SUM(t.quantity), 0), 2) AS avg_unit_sales_value,
    ROUND(AVG(t.retail_disc), 4) AS avg_retail_discount,
    ROUND(SUM(CASE
                WHEN t.coupon_disc <> 0
                  OR t.coupon_match_disc <> 0
                THEN 1
                ELSE 0
            END)::numeric / NULLIF(COUNT(*), 0), 4) AS coupon_usage_rate
FROM raw.transaction_data t
INNER JOIN raw.product p
ON t.product_id = p.product_id
GROUP BY
    t.product_id,
    p.department,
    p.brand,
    p.commodity_desc,
    p.sub_commodity_desc,
    p.manufacturer,
    p.curr_size_of_product;


-- SECTION 4: CUSTOMER / HOUSEHOLD FEATURES
-- Create household-level behavioral features for customer segmentation, targeting, and downstream ML modeling.
SELECT
    household_key,
    COUNT(DISTINCT basket_id) AS total_baskets,
    COUNT(DISTINCT day) AS active_days,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(quantity) AS total_units_purchased,
    ROUND(SUM(sales_value), 2) AS total_spend,
    ROUND(SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0), 2) AS avg_basket_value,
    ROUND(AVG(retail_disc), 4) AS avg_retail_discount,
    ROUND(SUM(CASE
                WHEN coupon_disc <> 0
                  OR coupon_match_disc <> 0
                THEN 1
                ELSE 0
            END)::numeric / NULLIF(COUNT(*), 0), 4) AS coupon_usage_rate
FROM raw.transaction_data
GROUP BY household_key;

-- Recency
-- Add customer recency by calculating the number of days since each household's most recent purchase relative to the final observed transaction day.
WITH dataset_end AS (
    SELECT
        MAX(day) AS max_day
    FROM raw.transaction_data
),

household_recency AS (
    SELECT
        household_key,
        MAX(day) AS last_purchase_day
    FROM raw.transaction_data
    GROUP BY household_key
)

SELECT
    h.household_key,
    h.last_purchase_day,
    d.max_day - h.last_purchase_day AS recency_days
FROM household_recency h
CROSS JOIN dataset_end d
ORDER BY h.household_key;

-- Combining the household purchasing behavior, promotion response, recency, and demographic attributes into one ML-ready household-level dataset.
WITH household_behavior AS (
    SELECT
        household_key,
        COUNT(DISTINCT basket_id) AS total_baskets,
        COUNT(DISTINCT day) AS active_days,
        COUNT(DISTINCT product_id) AS unique_products,
        SUM(quantity) AS total_units_purchased,
        ROUND(SUM(sales_value), 2) AS total_spend,
        ROUND(SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0),2) AS avg_basket_value,
        ROUND(AVG(retail_disc), 4) AS avg_retail_discount,
        ROUND(SUM(CASE
                    WHEN coupon_disc <> 0
                      OR coupon_match_disc <> 0
                    THEN 1
                    ELSE 0
                END)::numeric / NULLIF(COUNT(*), 0),4) AS coupon_usage_rate,
        MAX(day) AS last_purchase_day
    FROM raw.transaction_data
    GROUP BY household_key
),

dataset_end AS (
    SELECT MAX(day) AS max_day
    FROM raw.transaction_data
)

SELECT
    hb.household_key,
    hb.total_baskets,
    hb.active_days,
    hb.unique_products,
    hb.total_units_purchased,
    hb.total_spend,
    hb.avg_basket_value,
    hb.avg_retail_discount,
    hb.coupon_usage_rate,
    dataset_end.max_day - hb.last_purchase_day AS recency_days,
    d.age_desc,
    d.marital_status_code,
    d.income_desc,
    d.homeowner_desc,
    d.hh_comp_desc,
    d.household_size_desc,
    d.kid_category_desc
FROM household_behavior hb
CROSS JOIN dataset_end
LEFT JOIN raw.hh_demographic d
ON hb.household_key = d.household_key;

-- SECTION 5: PROMOTION / COUPON FEATURES
-- Inspecting the coupon redemption table structure to identify the keys and fields required for promotion-response features.
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'coupon_redempt'
ORDER BY ordinal_position;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'coupon'
ORDER BY ordinal_position;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'campaign_table'
ORDER BY ordinal_position;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'campaign_desc'
ORDER BY ordinal_position;

-- Validate promotion and coupon keys before joining tables to ensure campaign and coupon lookups do not duplicate redemption records and distort promotion-response features.
SELECT
    'campaign_desc' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT campaign) AS duplicate_rows
FROM raw.campaign_desc

UNION ALL

SELECT
    'coupon' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT coupon_upc) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT coupon_upc) AS duplicate_rows
FROM raw.coupon;
/* The result of above query shows that coupon_upc is NOT a unique key in raw.coupon. */

-- checking whether coupon_upc + product_id + campaign forms a unique coupon-to-product-to-campaign mapping. This prevents row multiplication when joining coupon data.
SELECT
    COUNT(*) AS total_rows,
    COUNT(
        DISTINCT (coupon_upc, product_id, campaign)
    ) AS unique_combinations,
    COUNT(*) -
    COUNT(
        DISTINCT (coupon_upc, product_id, campaign)
    ) AS duplicate_combinations
FROM raw.coupon;
/* No duplicate combinations */

WITH campaign_assignments AS (
    SELECT
        household_key,
        COUNT(DISTINCT campaign) AS campaigns_assigned
    FROM raw.campaign_table
    GROUP BY household_key
),

campaign_redemptions AS (
    SELECT
        household_key,
        COUNT(DISTINCT campaign) AS campaigns_redeemed,
        COUNT(DISTINCT coupon_upc) AS coupons_redeemed
    FROM raw.coupon_redempt
    GROUP BY household_key
)

SELECT
    a.household_key,

    a.campaigns_assigned,

    COALESCE(r.campaigns_redeemed, 0) AS campaigns_redeemed,

    COALESCE(r.coupons_redeemed, 0) AS coupons_redeemed,

    ROUND(
        COALESCE(r.campaigns_redeemed, 0)::numeric
        / NULLIF(a.campaigns_assigned, 0),
        4
    ) AS campaign_redemption_rate

FROM campaign_assignments a
LEFT JOIN campaign_redemptions r
    ON a.household_key = r.household_key
ORDER BY a.household_key;