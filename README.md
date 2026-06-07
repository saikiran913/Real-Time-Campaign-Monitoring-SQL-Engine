# Real-Time Campaign Monitoring SQL Engine

A SQL-first portfolio project that simulates real-time marketing campaign monitoring with synthetic CSV data and SQLite. Phase 1 builds the raw data foundation: source files, raw table DDL, sample inserts, validation scripts, and beginner-friendly documentation.

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
    README.md
  docs/
    architecture.md
    phase_1_setup.md
    interview_explanation.md
  investigations/
    README.md
  validation/
    expected_row_counts.sql
    null_check_queries.sql
    duplicate_check_queries.sql
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

## What Is Not Included Yet

No staging layer, analytics layer, KPI engine, budget pacing logic, alert output tables, dashboard, live data connection, streaming, cloud deployment, orchestration, or machine learning is included in Phase 1.

## Future Phases

Future phases will add staging transformations, KPI calculations, budget pacing, monitoring alerts, campaign health scores, sample outputs, and dashboard-ready datasets.
