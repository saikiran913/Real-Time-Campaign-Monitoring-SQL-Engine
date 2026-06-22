# Phase 3 KPI Engine

## What Phase 3 Adds

Phase 3 adds a KPI calculation engine on top of the Phase 2 staging layer. It creates daily and hourly campaign performance fact tables, campaign-level summaries, platform-level summaries, region-level summaries, and trend summary tables.

## Why A KPI Layer Is Needed

Staging tables clean and standardize the data, but they do not answer performance questions. The KPI layer converts cleaned metrics into marketing performance measures such as CTR, CPC, CPM, CVR, CPA, ROAS, and AOV.

## Staging Layer vs KPI Layer

- Staging layer: cleans raw data, standardizes fields, and adds quality flags.
- KPI layer: calculates performance measures and compares results against campaign targets.

Phase 3 does not remove staging rows silently. The daily and hourly fact tables carry forward Phase 2 quality fields.

## KPI Tables

- `fact_campaign_daily_performance`
- `fact_campaign_hourly_performance`
- `campaign_kpi_summary`
- `platform_kpi_summary`
- `region_kpi_summary`
- `daily_kpi_trend_summary`
- `hourly_kpi_trend_summary`

## KPI Formulas

- `ctr = clicks / impressions`
- `cpc = spend / clicks`
- `cpm = spend / impressions * 1000`
- `cvr = conversions / clicks`
- `cpa = spend / conversions`
- `roas = revenue / spend`
- `aov = revenue / conversions`

## Target Comparison Logic

- CTR meets target when `ctr >= target_ctr`.
- CPC meets target when `cpc <= target_cpc` and `cpc > 0`.
- CPA meets target when `cpa <= target_cpa` and `cpa > 0`.
- ROAS meets target when `roas >= target_roas`.
- CVR meets target when `cvr >= target_cvr`.
- If a target is missing or `0`, the status is `No Target`.

## Divide-By-Zero Handling

All KPI formulas use `CASE WHEN` logic. If the denominator is `0`, the KPI returns `0`.

## How To Run Phase 3 Locally

1. Run `sql/01_create_raw_tables.sql`.
2. Run `sql/02_insert_sample_data.sql`.
3. Run `sql/03_create_staging_tables.sql`.
4. Run `sql/04_data_quality_checks.sql`.
5. Run `sql/05_kpi_calculations.sql`.
6. Run the KPI validation and reconciliation checks in `validation/`.

## Manual Checks To Perform

- Confirm KPI fact table row counts match staging metric row counts.
- Confirm reconciliation checks return `Pass`.
- Review any KPI rates above expected boundaries, such as CTR greater than `1`.
- Review rows where carried-forward quality fields show invalid campaign dates or unknown campaigns.
- Spot-check a few KPI formulas manually.

## What Phase 3 Does Not Include Yet

Phase 3 does not include budget pacing, anomaly detection, alert generation, campaign health scores, dashboards, APIs, cloud services, Docker, Python, PySpark, or machine learning.
