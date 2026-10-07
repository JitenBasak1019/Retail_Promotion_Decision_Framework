# Project Progress

## Project Status

The project is being developed as a complete end-to-end retail analytics project, progressing through:

Raw Data
→ SQL Data Preparation & Analysis
→ Analytical Tables
→ Python EDA
→ Customer Segmentation
→ Machine Learning
→ Optimization
→ Power BI

The project has currently progressed through the SQL pipeline and most of the initial Python EDA.

Current position:

- SQL pipeline: COMPLETED
- Python EDA 4.1–4.8: COMPLETED
- Feature Preparation & Engineering (Section 5): COMPLETED
- Customer Segmentation (Section 6): COMPLETED
- Machine Learning (Section 7–8): COMPLETED (Notebook 03)
- Optimization & Decision Support (Section 9): COMPLETED (Notebook 03)
- Scenario & What-If Analysis (Section 10): COMPLETED (Notebook 03)
- Power BI Data Materialization: COMPLETED (`Data/Output/`)
- Power BI Dashboard Design: COMPLETED (`Power_BI/Final_Dashboard.pbix`)
- Final Business Recommendations & Portfolio Packaging: COMPLETED (`README.md`)
- Project Status: **100% COMPLETE & PORTFOLIO READY**

---

# PART 1 — DATA PREPARATION

## 1. Raw Data Loading

### Status: COMPLETED

The project started with the raw retail/marketing dataset containing multiple related CSV files covering areas such as:

- Household/customer demographics
- Transactions
- Products
- Campaigns
- Coupons
- Coupon redemptions
- Other supporting retail/marketing information

The raw files were inspected before loading.

A PostgreSQL database was selected as the main SQL environment because the transaction data is large and SQL is more appropriate for large-scale joins, aggregation, validation, and feature engineering.

The raw source tables were loaded into PostgreSQL under the `raw` schema.

One important data-preparation issue was identified with the coupon data: the original coupon file contained exact duplicate records. Those duplicates were handled before loading the processed version into PostgreSQL.

All required source CSVs were subsequently loaded into the database.

The raw database setup is therefore complete.

---

# PART 2 — SQL ANALYTICS PIPELINE

The SQL work was deliberately divided into five separate stages/files so that the project has a clean progression from loading the data to producing analytical tables.

---

## 2.1 SQL Stage 1 — Data Loading

### Status: COMPLETED

This stage handled the initial PostgreSQL setup and loading of the source CSV data.

Main activities:

- Created/used the PostgreSQL database environment.
- Loaded the source CSV files.
- Assigned appropriate data types.
- Stored source data under the `raw` schema.
- Prepared the database for subsequent profiling and analysis.

This stage was focused on getting the raw data into a reliable SQL environment.

---

## 2.2 SQL Stage 2 — Data Profiling

### Status: COMPLETED

After loading the data, the next SQL file was used for systematic data profiling.

The purpose was to understand the structure and characteristics of the source tables before performing business analysis.

The profiling included checks such as:

- Table row counts
- Column information
- Data types
- Distinct values
- Key fields
- Date ranges
- Numerical distributions
- Categorical distributions
- Potential anomalies
- Basic relationship checks

The profiling stage was also used to identify issues that required further investigation in the data-quality stage.

The profiling queries were kept together as the dedicated data-profiling SQL stage.

---

## 2.3 SQL Stage 3 — Data Quality

### Status: COMPLETED

The third SQL stage focused specifically on validating the quality and consistency of the loaded data.

The checks included:

- Null-value inspection
- Duplicate inspection
- Exact duplicate checks
- Key uniqueness
- Referential integrity
- Unexpected values
- Invalid or inconsistent records
- Data-range checks
- Other anomalies identified during profiling

Important results were reviewed rather than simply assuming that every unusual value was a data error.

The data-quality stage was completed after the identified checks were investigated.

This stage established confidence in using the data for downstream sales and marketing analysis.

---

## 2.4 SQL Stage 4 — Sales Analysis

### Status: COMPLETED

After data profiling and quality validation, the project moved into actual business analysis.

This stage was organized around the major sales and retail questions.

### 2.4.1 Overall Sales Analysis

The analysis established the overall scale and performance of the retail dataset.

The work examined key sales-level metrics and transaction activity to understand the overall business baseline.

### 2.4.2 Time-Based Sales Trends

Sales were analyzed across time to understand how purchasing activity changes over the available period.

The analysis covered relevant time-based patterns and trends and established the foundation for understanding temporal behavior.

### 2.4.3 Product-Level Analysis

Product-level analysis was then performed to understand:

- Product performance
- Product/category contribution
- Quantity behavior
- Sales contribution
- Product-level purchasing patterns

Product-level analytical features were created as part of this stage.

### 2.4.4 Promotion Analysis

Promotion-related purchasing behavior was analyzed.

The analysis investigated the role of promotional purchases and related sales behavior.

Promotion-related features were also prepared for later customer-level analysis.

### 2.4.5 Campaign Analysis

Campaign-related behavior was analyzed at the household level.

The SQL work included campaign assignment and redemption-related aggregation.

Campaign features included measures such as:

- Number of campaigns assigned
- Campaign redemption behavior
- Campaign engagement

These campaign-related features were subsequently incorporated into the household-level analytical dataset.

### 2.4.6 Validation of Analytical Queries

The important SQL outputs were checked after creation.

The results of the analytical queries were reviewed, including checks for unexpected duplicates and incorrect aggregation behavior.

The SQL sales-analysis stage was considered complete after the analytical outputs were validated.

---

# 2.5 SQL Stage 5 — Analytics Table Materialization

### Status: COMPLETED

This was the final stage of the SQL pipeline.

The purpose of this stage was to create a small set of reusable analytical tables from the raw/source tables so that downstream Python analysis would not need to repeatedly work with the large raw transaction-level data.

Three analytical tables were created:

- `customer_features`
- `product_features`
- `campaign_features`

### `customer_features`

This table contains household/customer-level analytical features derived from the underlying customer and transaction-related data.

It provides the customer-level behavioral foundation required for the Python EDA and later customer analytics.

### `product_features`

This table contains product-level analytical features required for product-level analysis.

It provides the product-side analytical information without requiring Python to repeatedly rebuild product-level aggregations from the raw transactional data.

### `campaign_features`

This table contains campaign-related features at the household level.

The campaign analysis performed in SQL was aggregated into reusable household-level campaign features so that campaign behavior could be incorporated into the customer-level Python analysis.

The three analytical tables were validated after creation.

With the creation and validation of:

- `customer_features`
- `product_features`
- `campaign_features`

the SQL portion of the project was considered **complete**.

---

# PART 3 — PYTHON ANALYTICS / EDA

After completing the SQL analytics-table materialization, the project moved to the Python/Jupyter notebook stage.

The Python notebook begins with the environment/database setup and then loads the SQL analytical tables for analysis.

The Python workflow is:

1. Import required libraries.
2. Connect to PostgreSQL.
3. Inspect the analytics schema.
4. Inspect the analytics table structures and sizes.
5. Load the three analytics tables into pandas.
6. Combine the required analytical tables to create the two main analysis dataframes.
7. Begin Section 4 — Exploratory Data Analysis.

---

## PART 1 — Environment Setup & Database Connection

### Status: COMPLETED

The notebook begins with the environment setup.

### 1.1 Importing Important Libraries

The required Python libraries for:

- Data manipulation
- Numerical analysis
- Visualization
- Statistical analysis
- Database connectivity

were imported.

### 1.2 PostgreSQL Database Connection

A PostgreSQL connection was established so that the notebook could access the analytics tables created during the SQL stage.

---

## PART 2 — Inspect Analytics Schema

### Status: COMPLETED

Before loading the analytical data into pandas, the notebook inspected the analytics schema.

### 2.1 Inspect Analytics Table Structures

The structures of the three analytical tables were inspected to understand:

- Available columns
- Data types
- Table structure
- Analytical features available for downstream analysis

### 2.2 Analytics Table Size and Sample

The analytical tables were also inspected for their sizes and sample records.

This confirmed the structure and scale of the analytical data before loading it into pandas.

---

## PART 3 — Load Analytics Tables

### Status: COMPLETED

The three SQL analytical tables were loaded into pandas.

The three source analytical tables were:

- `customer_features`
- `product_features`
- `campaign_features`

The notebook then combined these tables into two main analysis dataframes.

### 3.1 Combine Customer & Campaign Features

The customer-level and campaign-level analytical features were combined at the household level.

This produced the main household/customer analysis dataframe:

`household_eda`

The product analytical data remained as the separate product analysis dataframe:

`product_df`

Therefore, although three SQL analytical tables were created, the Python EDA works primarily with two analysis dataframes:

- `household_eda`
- `product_df`

Campaign-related features are already incorporated into `household_eda`.

There is therefore no need during Python EDA to go back to the raw campaign tables to reconstruct campaign information.

### 3.2 Validate Household-Level Merge

The customer + campaign merge was validated to ensure that the household-level analytical dataframe had been created correctly.

This completed the transition from the SQL analytical layer to the Python EDA layer.

---

# PART 4 — EXPLORATORY DATA ANALYSIS

### Status: COMPLETED

The main exploratory analysis was conducted in Section 4 of the `02_Python_EDA.ipynb` notebook.

The EDA was structured across sections **4.1 through 4.8**:

- 4.1 — COMPLETED (Household-Level Descriptive Statistics)
- 4.2 — COMPLETED (Customer Spending & Purchase Behavior)
- 4.3 — COMPLETED (Customer Recency & Engagement)
- 4.4 — COMPLETED (Customer Segmentation Patterns — RFM Distributions & Quartiles)
- 4.5 — COMPLETED (Demographic Patterns)
- 4.6 — COMPLETED (Campaign Performance & Redemption)
- 4.7 — COMPLETED (Product-Level Analysis)
- 4.8 — COMPLETED (Relationships & Correlations — Customer & Product Spearman Heatmaps)

The following section descriptions reflect the actual notebook structure and numbering.

---

## 4.1 Household-Level Descriptive Statistics

### Status: COMPLETED

This section established the basic descriptive understanding of the household-level analytical dataset.

### 4.1.1 Numerical Feature Analysis

The numerical household-level features were examined using descriptive statistics.

This established the central tendency, spread, and range of the major behavioral variables.

### 4.1.2 Distribution of Household Behavior Variables

The distributions of important household behavioral variables were visualized and examined.

Important observations included:

- Household behavioral variables are generally right-skewed.
- A relatively small number of highly active/high-spending households create long upper tails.
- `total_units_purchased` showed particularly strong skewness.
- `total_spend`, `total_baskets`, `active_days`, and `unique_products` also showed substantial right-skewness.
- Most households had relatively low coupon usage rates.
- Most households had relatively recent activity, although `recency_days` had a long upper tail.

### 4.1.3 Categorical Feature Analysis

The available household demographic/categorical features were examined.

A major data limitation identified here was that demographic information was available for only:

- 801 of 2,500 households
- 32.04% of households

Therefore, demographic analyses need to be interpreted using the available demographic subset rather than the full household population.

The observed demographic categories were also unevenly distributed.

Key findings from this section were documented directly in the notebook.

---

## 4.2 Customer Spending & Purchase Behavior

### Status: COMPLETED

This section examined household spending and purchasing behavior in greater detail.

### 4.2.1 Household Spending Distribution

The distribution of household total spending was analyzed to understand customer spending heterogeneity and the presence of high-spending households.

### 4.2.2 Purchase Frequency vs. Total Spending

The relationship between purchase frequency and total spending was examined.

### 4.2.3 Distribution of Average Basket Value

Average basket value was analyzed to understand variation in spending per shopping basket.

### 4.2.4 Average Basket Value vs. Total Baskets

The relationship between average basket value and the number of baskets was examined.

### 4.2.5 Distribution of Total Units Purchased

Total units purchased showed extreme right-skewness.

The maximum was around 4.48 million units compared with a median of approximately 11,084.5 units.

Because the extreme values compressed the majority of observations, the need for a transformed view of the variable was identified.

A log transformation was subsequently used for more meaningful visualization.

### 4.2.6 Total Units Purchased vs. Total Baskets

The relationship between total units purchased and total baskets was analyzed.

The observed correlation was approximately 0.496, indicating a moderate positive relationship.

Households with more baskets generally purchased more units, but basket frequency alone did not explain purchase volume.

### 4.2.7 Total Units Purchased vs. Total Spend

A positive relationship between purchase volume and total spending was observed, although substantial variation remained among households with similar purchase volumes.

### 4.2.8 Average Retail Discount vs. Total Spend

The correlation was approximately 0.041, indicating an essentially negligible linear relationship between average retail discount and total household spending.

The analysis explicitly treated this as an association rather than evidence that discounts have no effect on purchasing.

### 4.2.9 Coupon Usage Rate vs. Total Spend

The correlation was approximately 0.133, indicating a weak positive linear relationship.

Most households had very low coupon usage rates, and coupon usage alone did not explain household spending.

Again, the observed relationship was treated as descriptive association rather than causal evidence.

---

## 4.3 Customer Recency & Engagement

### Status: COMPLETED

This section examined how recently and how frequently households interacted with the store.

### 4.3.1 Distribution of Active Days

The distribution of active shopping days was analyzed.

The majority of households had relatively low numbers of active shopping days, while a smaller group remained active across a much larger portion of the observation period.

The distribution was strongly right-skewed.

### 4.3.2 Distribution of Recency Days

Recency days were analyzed to understand how recently households had last purchased.

Most households had relatively recent activity, while a smaller number had substantially larger recency values.

### 4.3.3 Recency vs. Total Spending

The relationship between recency and total spending was examined.

The analysis showed a concentration of high-spending households at lower recency values, while households with larger recency values generally had lower spending.

### 4.3.4 Purchase Frequency vs. Recency

The relationship between purchase frequency and recency was examined.

The observed correlation was approximately -0.234, indicating a modest negative relationship: households with more days since their last purchase tended to have lower purchase frequency.

---

## 4.4 Customer Segmentation Patterns

### Status: COMPLETED

This section introduced the main customer segmentation analysis.

### 4.4.1 RFM Feature Distributions

RFM-related behavioral variables were examined.

The analysis used:

- Recency
- Frequency
- Monetary value

Because total baskets and total spending were highly skewed, log-transformed versions were also examined to reduce the influence of extreme outliers.

The resulting relationships were then inspected through correlation analysis.

Important observed relationships included:

- Total baskets and total spend: approximately 0.856
- Recency and total baskets: approximately -0.572
- Recency and total spend: approximately -0.525

These relationships provided the foundation for the subsequent RFM segmentation analysis.

### 4.4.2 Behavioral Patterns Across Recency Quartiles

Customer behavior was compared across recency quartiles.

The analysis examined how frequency and monetary behavior differed across recency groups.

The heatmaps showed that:

- More recent households generally had higher purchase frequency.
- More recent households generally had higher historical spending.
- Higher frequency was strongly associated with higher spending.
- Recency provided an additional separation between customer groups.

The analysis also established the interpretation of the four quartile groups.

Three percentile boundaries create four groups:

- Q1: approximately 0–25%
- Q2: approximately 25–50%
- Q3: approximately 50–75%
- Q4: approximately 75–100%

The fourth quartile therefore represents the remaining highest 25% interval; it is not an additional percentile boundary.

The RFM/segmentation analysis was then used as a foundation for understanding broader customer behavior.

---

## 4.5 Demographic Patterns

### Status: COMPLETED

This section examined how available household demographic characteristics relate to customer spending and purchase engagement.

A critical limitation identified earlier in the EDA was retained throughout this section:

Only 801 of the 2,500 households had demographic information.

Therefore, demographic analyses were based on the available 801 households.

### 4.5.1 Demographic Distribution

The distributions of the available demographic variables were examined.

The analysis also distinguished between:

- Actual missing demographic information
- Recorded categories such as `None/Unknown`

For example, `None/Unknown` under `kid_category_desc` was treated as a recorded category rather than automatically interpreting it as missing data.

### 4.5.2 Demographics vs. Customer Spending

Spending was compared across demographic dimensions including:

- Age
- Income
- Household size

Important findings included:

- The 35–44 age group had the highest median spending at approximately 5,494.
- The 65+ group had the lowest median spending at approximately 3,552.
- Spending was not simply linear with age.
- Higher-income households generally showed higher spending, although the relationship was not perfectly monotonic.
- Some upper-income categories had small sample sizes and therefore less stable estimates.
- Median spending generally increased from 1-person to 4-person households.
- Four-person households had the highest median spending at approximately 5,992.
- The 5+ group had a somewhat lower median than the 4-person group.

### 4.5.3 Demographics vs. Purchase Engagement

Purchase frequency was compared across demographic characteristics.

The main observations were:

- Age differences in purchase frequency were relatively modest compared with spending differences.
- The 55–64 and 19–24 groups had the highest median basket counts among the observed age groups.
- The 65+ group had the lowest median basket count.
- Purchase frequency did not increase consistently with income.
- Some high-income groups had very small sample sizes.
- Median purchase frequency was actually highest for 1-person households.
- Median basket frequency generally declined as household size increased.

This showed that higher spending does not necessarily mean more shopping trips.

### 4.5.4 Marital Status vs. Customer Behavior

Marital-status categories were compared on spending, purchase frequency, and units purchased.

The analysis showed that the group with the highest median spending did not necessarily have the highest purchase frequency.

This further reinforced the distinction between:

- How often a household shops
- How much it spends
- How many units it purchases

### 4.5.5 Household Children vs. Customer Behavior

Households were compared based on the available children-related categories.

The 2-children category had the highest median spending and substantially higher median units purchased.

Purchase frequency was relatively similar across the observed categories.

The `None/Unknown` category was treated carefully because it represented recorded unknown/unspecified information rather than automatically meaning that the household had no children.

The demographic EDA therefore concluded that household characteristics showed some association with spending and purchase behavior, but these relationships should be interpreted with the limitation of the small demographic coverage.

---

# 4.6 Campaign Performance & Redemption

### Status: COMPLETED

This section examined marketing campaign exposure and coupon redemption behavior across households.

### 4.6.1 Overall Campaign Exposure & Redemption
- Assessed campaign reach: 1,584 households (63.36%) were targeted with at least one marketing campaign, while 916 households were never targeted.
- Evaluated redemption activity among targeted households: only a minority of targeted households actively redeemed campaign coupons, establishing the baseline conversion rate.

### 4.6.2 Campaign Exposure & Redemption Distribution
- Analyzed the distribution of campaigns assigned, campaigns redeemed, and coupons redeemed.
- Documented heavy right-skewness: most households receive few campaigns and redeem zero or one, while a small segment accounts for the majority of redemptions.

### 4.6.3 Campaign Exposure vs. Redemption
- Explored the relationship between the number of campaigns assigned and the likelihood/volume of redemption.
- Confirmed that higher exposure increases overall redemption opportunities, but redemption rate does not scale linearly with assigned campaigns.

---

# 4.7 Product-Level Analysis

### Status: COMPLETED

This section explored the product dimension using the materialized `product_df` dataset (92,339 products).

### 4.7.1 Overall Product Sales & Reach
- Evaluated total sales, units sold, and unique household penetration across the catalog.
- Identified heavy concentration: a small fraction of high-velocity items drives the bulk of store revenue and basket presence (Pareto-like distribution).

### 4.7.2 Department-Level Product Performance
- Analyzed sales volume, revenue contribution, and household reach across store departments (GROCERY, DRUG GM, PRODUCE, MEAT, etc.).
- Grocery and fresh departments dominated trip penetration and volume.

### 4.7.3 Commodity-Level Performance
- Examined performance at the commodity group level to identify the primary revenue-driving categories.

### 4.7.4 Product Pricing & Promotion Patterns
- Investigated the distributions of unit selling price (`avg_unit_sales_value`), retail discounts (`avg_retail_discount`), and product-level coupon usage (`coupon_usage_rate`).
- Noted right-skewed pricing and confirmed that coupon usage is concentrated in specific categories and branded products.

---

# 4.8 Relationships & Correlations

### Status: COMPLETED

This section synthesized behavioral associations across both customer and product dimensions using Spearman rank correlations.

### 4.8.1 Customer Behavioral Correlations
- Examined monotonic relationships among key household metrics:
  - `total_spend` ↔ `total_baskets`: **0.85** (very strong positive association; frequent shoppers drive total spend).
  - `total_spend` ↔ `total_units_purchased`: **0.67** (moderate-to-strong positive association).
  - `recency_days` ↔ `total_baskets` / `total_spend`: Moderate negative associations (more lapsed shoppers exhibit lower volume and spend).

### 4.8.2 Product Performance Correlations
- Analyzed rank correlations among sales, units sold, household reach, basket reach, unit price, discounts, and coupon usage.
- High correlation between household reach and basket reach; discount and coupon metrics exhibited specific categorical clustering.

---

# PART 5 — FEATURE PREPARATION / ENGINEERING (Section 5)

### Status: COMPLETED

Implemented in `02_Python_EDA.ipynb` (Section 5) to transform the exploratory dataset into structured, model-ready feature sets.

### 5.1 Feature Preparation Overview
- Established objectives: feature selection, transformations, derived variables, missing value handling, categorical encoding, and scaling.

### 5.2 Derived Feature Creation
Created business-meaningful behavioral ratios:
- `spend_per_active_day`: Spending intensity per shopping day.
- `baskets_per_active_day`: Shopping trip frequency per active day.
- `units_per_basket`: Average basket physical size.
- `product_diversity_ratio`: Distinct products purchased relative to total baskets.

### 5.3 Missing Value Treatment & Business Flags
- **Campaign features (916 missing households):** Imputed with `0` because these households were never targeted. Created explicit flags:
  - `was_campaign_targeted`: Binary indicator (1 if assigned ≥ 1 campaign, 0 otherwise).
  - `is_campaign_redeemer`: Binary indicator (1 if redeemed ≥ 1 campaign, 0 otherwise) — acts as the candidate ML classification target.
- **Demographic features (1,699 missing households):** Imputed with `'Unknown'` to preserve the complete 2,500 household population for modeling. Created `has_demographics` binary flag.

### 5.4 Categorical Encoding
- **Ordinal encoding:** Applied to naturally ordered demographic variables:
  - `age_desc` → `age_encoded` (19–24 up to 65+, Unknown = 0)
  - `income_desc` → `income_encoded` (Under 15K up to 250K+, Unknown = 0)
  - `household_size_desc` → `household_size_encoded` (1 to 5+, Unknown = 0)
- **Label encoding:** Applied to unordered attributes (`marital_status_code`, `homeowner_desc`, `hh_comp_desc`, `kid_category_desc`).

### 5.5 Log Transformations of Skewed Features
- Applied `log1p` to compress extreme upper tails for: `total_spend`, `total_baskets`, `total_units_purchased`, `active_days`, and `unique_products`.

### 5.6 Feature Matrix Construction & Export
- Built unified working DataFrame `features_df` and clean numerical modeling matrix `df_model` (indexed by `household_key`).
- Saved processed datasets:
  - `Data/Processed/household_engineered.csv`
  - `Data/Processed/household_model_ready.csv`

---

# PART 6 — CUSTOMER SEGMENTATION (Section 6)

### Status: COMPLETED

Implemented in `02_Python_EDA.ipynb` (Section 6) using both rule-based and unsupervised learning approaches.

### 6.1 RFM Scoring & Segment Assignment
- Built directly on the Section 4.4 RFM quartile exploration by converting Q1–Q4 quartiles into numerical scores (1–4) for Recency, Frequency, and Monetary value.
- Mapped score combinations into business-actionable RFM segments:
  - Champions
  - Loyal Customers
  - Potential Loyalists
  - At Risk
  - Needs Attention
  - Hibernating
  - Others

### 6.2 K-Means Clustering (K=5)
- Standardized 12 behavioral, derived, and campaign features using `StandardScaler`.
- Evaluated cluster quality across K=2 through K=10 using inertia (Elbow Method) and Silhouette analysis.
- **Selected K=5** (Silhouette score: ~0.2956): While K=2 provided a mathematically high score, it only separated high vs. low spenders; K=5 was selected for actionable marketing differentiation.

### 6.2.1 Cluster Profiling & Naming
Detailed median profiles identified 5 distinct customer groups:
- **Cluster 0 — Light Shoppers (747 households):** Low spend (\$683.3 median), 34 baskets, 15 days recency, small basket value (\$20.8).
- **Cluster 1 — Core Regulars (1,111 households):** Large backbone group (44.4%), solid spend (\$3,082.5 median), 128 baskets, 3 days recency, reliable frequent shoppers.
- **Cluster 2 — Lapsed (62 households):** Churned / dormant group, \$164 median spend, 7 baskets, 293.5 days recency.
- **Cluster 3 — High-Value Champions (250 households):** Top tier across all metrics (\$5,909.6 median spend, 158 baskets, 2 days recency, \$40.6 basket value) and the only group with strong campaign engagement (50% redemption rate).
- **Cluster 4 — Big-Basket Occasional (330 households):** Fewer visits (46 baskets, 9 days recency) but highest average basket value (\$58.3 median spend per basket).

### 6.2.2 PCA 2D Visualization & Cross-Comparison
- Reduced 12 dimensions to 2 principal components to confirm cluster separation.
- Cross-tabulated and visualized overlap between RFM segments and K-Means clusters via heatmaps, confirming strong alignment and added multi-dimensional depth from clustering.
- Saved finalized dataset: `Data/Processed/household_segmented.csv` (includes `cluster`, `segment_name`, and `rfm_segment`).

---

# PART 7 — MACHINE LEARNING & MODEL EVALUATION (Notebook 03, Section 7–8)

### Status: COMPLETED

Implemented in `03_ML_and_Optimization.ipynb` to predict campaign coupon redemption (`is_campaign_redeemer`) among 1,584 targeted households.

### 7.1 Problem Formulation & Leakage Prevention
- Target variable: `is_campaign_redeemer` (1 = redeemed ≥ 1 campaign, 0 = no redemptions).
- Scope: Filtered strictly to the 1,584 households assigned to campaigns (excluded 916 untargeted households to avoid non-response bias).
- Excluded outcome-derived leakage columns: `campaigns_redeemed`, `coupons_redeemed`, `campaign_redemption_rate`, `was_campaign_targeted`.
- Applied stratified 80/20 train/test split.

### 7.2 Model Performance Benchmarking
Trained three candidate algorithms with class imbalance handling (`class_weight='balanced'`):

| Model | Accuracy | Precision | Recall | F1-Score | ROC-AUC |
|---|---|---|---|---|---|
| **Logistic Regression** | 77.60% | 57.14% | 73.56% | 0.6432 | 0.8491 |
| **Random Forest (Champion)** | **81.39%** | **64.89%** | **70.11%** | **0.6740** | **0.8869** |
| **Gradient Boosting** | 81.39% | 64.89% | 70.11% | 0.6740 | 0.8857 |

**Model Selection:** Random Forest selected as the champion model for its superior ranking performance (ROC-AUC 0.8869) and native feature importance.

### 7.3 Feature Importance & Redeemer Profile (Section 8)
- **Top Predictive Features:**
  - `coupon_usage_rate` (0.155) — Prior regular coupon usage is the single strongest predictor of campaign response.
  - `cluster` (0.145) — Customer segment captures engagement; redeemers heavily concentrate in *High-Value Champions*.
  - `total_spend` & `total_spend_log` (0.061–0.063) — Higher historical spend strongly correlates with campaign engagement.
  - `unique_products` (0.043) — Breadth of catalog exploration.
- **Redeemer vs. Non-Redeemer Median Profiling:**
  - Total Spend: $5,651.96 (Redeemer) vs. $2,832.02 (Non-Redeemer) — **+99.6% higher**.
  - Unique Products: 930 vs. 586 — **+58.8% higher**.
  - Active Days: 135.5 vs. 93.0 — **+45.7% higher**.
- **Scoring:** Scored all 2,500 households with `redemption_probability` (bimodal distribution confirming strong model confidence).

---

# PART 8 — OPTIMIZATION & DECISION SUPPORT (Notebook 03, Section 9)

### Status: COMPLETED

Translated predictive probabilities into prescriptive decision-making using retail unit economics:
- Targeting Cost: $3.00 per household.
- Gross Margin Rate: 25% on purchase basket.
- Net Expected Value ($EV$): $P(\text{Redeem}) \times (0.25 \times \text{avg\_basket\_value}) - \$3.00$.

### Core Business Decision Findings:
1. **Segment Marketing Prioritization:** *High-Value Champions* and *Core Regulars* deliver positive campaign margin; *Lapsed* and *Light Shoppers* exhibit negative expected returns under physical mail costs.
2. **2×2 Strategic Targeting Matrix:**
   - **Tier 1 (Core Targets):** High Spend, High Response — primary promotional recipients.
   - **Tier 2 (Protect & Retain):** High Spend, Low Response — retain via non-coupon / white-glove touchpoints.
   - **Tier 3 (Basket Builders):** Low Spend, High Response — volume growth and basket building.
   - **Tier 4 (Deprioritized):** Low Spend, Low Response — low-touch digital maintenance.
3. **Strategy Comparison (Top 500 Households, $1,500 Budget):**
   - *Strategy A (ML Probability):* 386.6 redemptions, 77.3% conversion, $2,922.13 net profit (194.8% ROI).
   - *Strategy B (Historical Spend):* 302.7 redemptions, 60.5% conversion, $1,839.42 net profit (122.6% ROI).
   - *Strategy C (Hybrid EV):* Maximizes total dollar return by balancing response propensity and basket value.
4. **Constrained Resource Allocation:** Cumulative net profit curve reveals the exact mathematical cutoff where marginal campaign profit equals campaign cost (~578 households under standard $3 mailers).

---

# PART 9 — SCENARIO & WHAT-IF ANALYSIS (Notebook 03, Section 10)

### Status: COMPLETED

Simulated strategic sensitivity across four core business planning scenarios:

1. **Budget Scaling Scenarios (100 to 2,500 Households):**
   - ROI peaks at small budgets (100 HHs: **429.5% ROI**, 91.5% conversion).
   - Total Net Profit peaks at **~500 HHs ($2,922.13 net profit)**.
   - Mass marketing (2,500 HHs) costs $7,500 and loses **-$1,641.71 (-21.9% ROI)**.
2. **Probability Threshold Cutoffs ($P \ge 0.80$ to $0.10$):**
   - Setting the eligibility cutoff at **$P \ge 0.30$** captures maximum net profit ($2,764.06, 624 HHs, 73.6% conversion).
   - Cutoffs below 0.20 destroy margin through excessive false positives.
3. **Marketing Channel Cost Sensitivity:**
   - **Low-Cost Digital ($1.00 unit cost):** Expands optimal reach to **1,009 households** ($4,446.43 profit); entire customer base (2,500 HHs) remains above break-even.
   - **Standard Direct Mail ($3.00 unit cost):** Optimal at **578 households** ($2,951.94 profit); break-even at 1,943 HHs.
   - **Premium Catalog Kit ($5.00 unit cost):** Contracts optimal reach to **408 households** ($1,991.89 profit); steep losses if mailed beyond 1,108 HHs.
4. **Targeting Value Lift (Proving ML Business Impact):**
   - **Lift vs. Mass Marketing:** **+$4,563.84 net profit gain** while reducing campaign spend by 80% ($1,500 vs. $7,500).
   - **Lift vs. Top Spenders (Same $1,500 Budget):** **+84 additional redemptions (+16.8% conversion lift)** and **+$1,082.71 (+58.9%) higher net profit**.
   - **Lift vs. RFM Champions:** Captures **5x higher profit** ($2,922 vs. $594) by identifying high-EV households across segments.

### Final Analytical Tables Materialized to `Data/Output/`:
- `pbi_household_master.csv` (2,500 rows, 51 columns with RFM, K-Means, ML scores, EV, and targeting flags)
- `pbi_scenario_budgets.csv`
- `pbi_scenario_thresholds.csv`
- `pbi_scenario_channel_costs.csv`
- `pbi_strategy_lift_benchmarks.csv`

---

# PART 10 — POWER BI BUSINESS INTELLIGENCE DASHBOARD

### Status: CURRENTLY IN PROGRESS

Designing an interactive, executive-grade Power BI dashboard connected to the materialized outputs in `Data/Output/`.

Planned dashboard pages:
1. **Executive Overview & KPI Scorecard:** Total sales, household reach, redemption rates, campaign ROI summary.
2. **Customer & Segment Intelligence:** Deep dive into the 5 K-Means clusters and RFM segments across spend, frequency, and demographics.
3. **Product & Category Performance:** Department revenue contributions, product reach, and promotional discount analysis.
4. **Campaign & Marketing Analytics:** Historical campaign exposure, coupon redemption distributions, and redemption efficiency.
5. **Prescriptive ML & What-If Decision Support:** Interactive scenario sliders (budget size, probability cutoffs, delivery channel selection) and household targeting lists.

Delivered file: `Power_BI/Final_Dashboard.pbix` (625 KB).

---

# PART 11 — FINAL BUSINESS RECOMMENDATIONS & PORTFOLIO PACKAGING

### Status: COMPLETED

- Synthesized end-to-end evidence into practical, C-suite business recommendations.
- Finalized comprehensive GitHub portfolio documentation: [`README.md`](file:///D:/DataProject/README.md).
- Formatted with architectural Mermaid diagrams, executive summaries, model comparison tables, unit economics, KPI dictionary, and step-by-step reproduction guide.

---

# CURRENT PROJECT POSITION

## Data Engineering & SQL Pipeline
- **All 5 SQL stages complete:** Raw ingestion, profiling, quality audits, sales analytics, and analytical table materialization (`customer_features`, `product_features`, `campaign_features`).

## Python Analytics & Modeling Pipeline
- **Notebook 01 (Inspection):** COMPLETED
- **Notebook 02 (EDA, Feature Engineering, Segmentation):** COMPLETED
  - EDA 4.1–4.8: Complete
  - Section 5 (Feature Engineering): Complete (`household_engineered.csv`, `household_model_ready.csv`)
  - Section 6 (Customer Segmentation): Complete with RFM + K-Means K=5 (`household_segmented.csv`)
- **Notebook 03 (ML, Evaluation, Optimization, Scenarios):** COMPLETED
  - Section 7 (Machine Learning): Complete (Random Forest Champion, AUC 0.8869)
  - Section 8 (Model Evaluation): Complete (Feature importance, threshold curves, scored 2,500 HHs)
  - Section 9 (Optimization): Complete (Unit economics, 2x2 matrix, strategy comparison, optimal cutoffs)
  - Section 10 (Scenario Analysis): Complete (Budget, threshold, channel cost, and ML lift simulations)
  - Data exports materialized to `Data/Output/`.

## Business Intelligence & Reporting
- **Power BI Dashboard:** COMPLETED (`Power_BI/Final_Dashboard.pbix`)
- **GitHub Documentation:** COMPLETED (`README.md`)

## Project Lifecycle Status:
🎉 **100% COMPLETED — PORTFOLIO READY**