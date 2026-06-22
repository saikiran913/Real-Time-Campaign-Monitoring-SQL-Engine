# SQL Scripts

## 01_create_raw_tables.sql

Drops and recreates the Phase 1 raw tables using SQLite-compatible SQL.

## 02_insert_sample_data.sql

Inserts the same synthetic records that are provided in the CSV files under `data/raw/`.

## 03_create_staging_tables.sql

Drops and recreates Phase 2 staging tables, then populates them from the raw tables. The script trims text, standardizes selected values, replaces null numeric values with `0`, and adds quality flags.

Bad rows are not removed silently. They remain in staging tables with flags such as `metric_quality_flag`, `is_known_campaign`, and `is_campaign_date_valid`.

## 04_data_quality_checks.sql

Contains SELECT-only checks for row counts, unknown campaign IDs, invalid dates, suspicious metrics, invalid budgets, invalid hourly records, missing alert rule details, and duplicate metric grains.

## 05_kpi_calculations.sql

Drops and recreates the Phase 3 KPI tables using only Phase 2 staging tables as sources. It creates daily and hourly performance facts, campaign summaries, platform summaries, region summaries, and daily/hourly trend summaries.

The script calculates CTR, CPC, CPM, CVR, CPA, ROAS, and AOV with `CASE WHEN` divide-by-zero handling. It also adds target comparison statuses where target values exist.

Phase 3 includes KPI calculation logic only. Budget pacing, anomaly detection, alert evaluation, and campaign health score logic will be added in later phases.
