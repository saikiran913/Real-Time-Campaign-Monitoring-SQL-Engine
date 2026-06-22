# Real-Time Campaign Monitoring SQL Engine

A SQL-first portfolio project that simulates real-time marketing campaign monitoring with synthetic CSV data and SQLite. Phase 1 builds the raw data foundation. Phase 2 adds a staging and data quality layer. Phase 3 adds the KPI calculation engine.

## Problem This Project Solves

Marketing teams need a reliable way to monitor campaign health before spend waste, tracking failures, or performance drops become expensive. This project models the foundation of a campaign monitoring engine that can later calculate KPIs, detect alert conditions, and support reporting.

## Tools Used

- SQLite
- DB Browser for SQLite
- CSV files
- SQL
- VS Code or any text editor

## Phase 1 Scope

Phase 1 includes synthetic raw datasets, SQLite raw table creation, sample data inserts, validation checks, and documentation. It does not include staging tables, KPI logic, alert outputs, dashboards, orchestration, APIs, cloud services, machine learning, Docker, Python, or PySpark.

## Phase 2 Status

Phase 2 is now added. It creates staging tables from raw tables, applies beginner-friendly cleaning rules, standardizes selected fields, and adds quality flags.

Bad rows are not removed silently. Staging keeps raw rows visible and flags issues such as unknown campaign IDs, invalid campaign metric dates, negative metrics, invalid budgets, invalid hourly records, and missing alert rule information.

## Phase 3 Status

Phase 3 is now added. It creates KPI facts and summaries from the staging layer, calculates marketing KPIs, adds target comparison statuses, and includes KPI validation and reconciliation checks.

New KPI tables:

- `fact_campaign_daily_performance`
- `fact_campaign_hourly_performance`
- `campaign_kpi_summary`
- `platform_kpi_summary`
- `region_kpi_summary`
- `daily_kpi_trend_summary`
- `hourly_kpi_trend_summary`

## Folder Structure

```text
real-time-campaign-monitoring-sql-engine/
  README.md
  project_overview.md
  data_dictionary.md
  business_rules.md
  run_order.md
  known_limitations.md
  future_enhancements.md
  CHANGELOG.md
  data/
    raw/
      campaigns.csv
      ad_platforms.csv
      campaign_daily_metrics.csv
      campaign_hourly_metrics.csv
      budget_allocations.csv
      campaign_targets.csv
      campaign_alert_rules.csv
      calendar.csv
      regions.csv
    sample_outputs/
      README.md
  database/
    README.md
  sql/
    01_create_raw_tables.sql
    02_insert_sample_data.sql
    03_create_staging_tables.sql
    04_data_quality_checks.sql
    05_kpi_calculations.sql
    README.md
  docs/
    architecture.md
    phase_1_setup.md
    phase_2_staging_layer.md
    phase_3_kpi_engine.md
    interview_explanation.md
  investigations/
    README.md
  validation/
    expected_row_counts.sql
    null_check_queries.sql
    duplicate_check_queries.sql
    staging_row_counts.sql
    referential_integrity_checks.sql
    metric_sanity_checks.sql
    kpi_validation_checks.sql
    kpi_reconciliation_checks.sql
    README.md
```

## How To Run Phase 1 Locally

1. Open DB Browser for SQLite.
2. Create a new SQLite database file, for example `database/campaign_monitoring.db`.
3. Open the Execute SQL tab.
4. Run `sql/01_create_raw_tables.sql`.
5. Run `sql/02_insert_sample_data.sql`.
6. Run the validation scripts in `validation/` to confirm row counts, null checks, and duplicate checks.

## What To Run First

Run `sql/01_create_raw_tables.sql` before `sql/02_insert_sample_data.sql`. Validation scripts should be run after both setup scripts are complete.

## How To Run Phase 2 After Phase 1

After Phase 1 data is loaded, run `sql/03_create_staging_tables.sql` to build the staging layer. Then run `sql/04_data_quality_checks.sql` and the Phase 2 validation scripts.

## How To Run Phase 3 After Phase 2

After Phase 2 staging tables are built, run `sql/05_kpi_calculations.sql`. Then run `validation/kpi_validation_checks.sql` and `validation/kpi_reconciliation_checks.sql`.

## Updated SQL Run Order

1. `sql/01_create_raw_tables.sql`
2. `sql/02_insert_sample_data.sql`
3. `sql/03_create_staging_tables.sql`
4. `sql/04_data_quality_checks.sql`
5. `sql/05_kpi_calculations.sql`
6. `validation/expected_row_counts.sql`
7. `validation/null_check_queries.sql`
8. `validation/duplicate_check_queries.sql`
9. `validation/staging_row_counts.sql`
10. `validation/referential_integrity_checks.sql`
11. `validation/metric_sanity_checks.sql`
12. `validation/kpi_validation_checks.sql`
13. `validation/kpi_reconciliation_checks.sql`

## What To Validate Manually

- Raw and staging row counts match.
- Quality flags clearly identify records that need review.
- Referential integrity checks return no unexpected unknown IDs.
- Metric sanity checks are reviewed before any future KPI logic is added.
- No Phase 2 script filters out bad rows without making the issue visible.
- KPI fact row counts match staging metric row counts.
- KPI reconciliation checks return `Pass`.
- Divide-by-zero KPI checks return no unexpected records.

## What Is Not Included Yet

No budget pacing logic, alert output tables, anomaly detection, campaign health score, dashboard, live data connection, streaming, cloud deployment, orchestration, or machine learning is included yet.

## Future Phases

Future phases will add staging transformations, KPI calculations, budget pacing, monitoring alerts, campaign health scores, sample outputs, and dashboard-ready datasets.
