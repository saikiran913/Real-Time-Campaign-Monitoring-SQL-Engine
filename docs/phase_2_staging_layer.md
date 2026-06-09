# Phase 2 Staging Layer

## What Phase 2 Adds

Phase 2 adds SQLite staging tables, basic cleaning, standardized values, data quality flags, referential integrity checks, campaign activity date validation, and duplicate detection.

## Why Staging Tables Are Needed

Raw tables are landing tables. They keep source-like records as loaded. Staging tables prepare those records for later analysis by trimming text, standardizing categories, handling null numeric values, and adding flags that make data issues visible.

## Raw Layer vs Staging Layer

- Raw layer: stores source-like synthetic records with minimal structure.
- Staging layer: keeps the same row grain, cleans obvious formatting issues, and flags records that need review.

Bad rows are not removed silently. They remain in staging tables with quality flags so later phases can decide how to handle them.

## Staging Tables

- `stg_ad_platforms`
- `stg_regions`
- `stg_calendar`
- `stg_campaigns`
- `stg_campaign_daily_metrics`
- `stg_campaign_hourly_metrics`
- `stg_budget_allocations`
- `stg_campaign_targets`
- `stg_campaign_alert_rules`

## Cleaning Rules Applied

- Text fields are trimmed.
- Campaign status and alert severity values are standardized.
- Currency values are uppercased.
- Null numeric metric, budget, and target values are replaced with `0`.
- Negative metric values are converted to `0` in staging while the row is flagged.
- Hour values are checked for the valid `0` to `23` range.

## Data Quality Flags Added

- `campaign_date_quality_flag`
- `metric_quality_flag`
- `hourly_quality_flag`
- `budget_quality_flag`
- `target_quality_flag`
- `alert_rule_quality_flag`
- `is_campaign_date_valid`
- `is_known_campaign`

## How To Run Phase 2 Locally

1. Run `sql/01_create_raw_tables.sql`.
2. Run `sql/02_insert_sample_data.sql`.
3. Run `sql/03_create_staging_tables.sql`.
4. Run `sql/04_data_quality_checks.sql`.
5. Run the Phase 2 validation scripts in `validation/`.

## Manual Checks To Perform

- Confirm raw and staging row counts match.
- Review any records where quality flags are not valid.
- Check unknown campaign IDs.
- Check invalid campaign metric dates.
- Check invalid hourly records.
- Check duplicate daily and hourly metric grains.

## What Phase 2 Does Not Include Yet

Phase 2 does not calculate CTR, CPC, CPA, CVR, ROAS, budget pacing, anomaly detection, alert outputs, campaign health scores, dashboards, APIs, cloud workflows, Docker, Python, PySpark, or machine learning.
