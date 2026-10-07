-- MATERIALIZE CUSTOMER FEATURES
-- Storing the validated household-level feature dataset in the analytics schema for downstream ML and analysis.
CREATE TABLE analytics.customer_features AS

WITH household_behavior AS (
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
                END)::numeric / NULLIF(COUNT(*), 0), 4) AS coupon_usage_rate,
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

-- MATERIALIZE PRODUCT-LEVEL FEATURES
-- Creating an analytical table containing product-level sales, customer reach, basket reach, discount, and coupon metrics.
CREATE TABLE analytics.product_features AS
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

-- MATERIALIZE CAMPAIGN AND COUPON FEATURES
-- Create a household-level analytical table containing campaign assignment, campaign redemption, coupon redemption, and campaign redemption rate metrics.
CREATE TABLE analytics.campaign_features AS

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
    ROUND(COALESCE(r.campaigns_redeemed, 0)::numeric / NULLIF(a.campaigns_assigned, 0), 4) AS campaign_redemption_rate
FROM campaign_assignments a
LEFT JOIN campaign_redemptions r
ON a.household_key = r.household_key;

