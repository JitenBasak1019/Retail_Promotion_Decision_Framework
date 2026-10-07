SELECT current_database();

CREATE SCHEMA Raw;
CREATE SCHEMA Analytics;

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw','analytics');

CREATE TABLE raw.campaign_desc(
	description VARCHAR(100),
	campaign INTEGER,
	start_day INTEGER,
	end_day INTEGER
);

CREATE TABLE raw.product(
	product_id BIGINT,
	manufacturer INTEGER,
	department VARCHAR(100),
	brand VARCHAR(100),
	commodity_desc VARCHAR(100),
	sub_commodity_desc VARCHAR(100),
	curr_size_of_product VARCHAR(100)
);

CREATE TABLE raw.campaign_table(
	description TEXT,
	household_key BIGINT,
	campaign INTEGER
);

CREATE TABLE raw.hh_demographic(
	age_desc TEXT,
	marital_status_code TEXT,
	income_desc TEXT,
	homeowner_desc TEXT,
	hh_comp_desc TEXT,
	household_size_desc TEXT,
	kid_category_desc TEXT,
	household_key INTEGER
);

CREATE TABLE raw.coupon_redempt (
    hpusehold_key BIGINT,
	day BIGINT,
	coupon_upc BIGINT,
    campaign INTEGER
);

CREATE TABLE raw.transaction_data(
	household_key BIGINT,
	basket_id BIGINT,
	day BIGINT,
	product_id BIGINT,
	quantity INTEGER,
	sales_value DECIMAL(10,2),
	store_id TEXT,
	retail_disc DECIMAL(10,2),
	trans_time INTEGER,
	week_no INTEGER,
	coupon_disc DECIMAL(10,2),
	coupon_match_disc DECIMAL(10,2)
);

DROP TABLE raw.casual_data;

CREATE TABLE raw.causal_data(
	product_id BIGINT,
	store_id BIGINT,
	week_no BIGINT,
	display TEXT,
	mailer TEXT
);

SELECT * FROM raw.causal_data
LIMIT 10;

CREATE TABLE raw.coupon (
    coupon_upc BIGINT,
    product_id BIGINT,
    campaign INTEGER
);

SELECT * FROM raw.coupon_redempt
LIMIT 10;