# Real-Time Campaign Monitoring SQL Engine

SQL-first portfolio project for campaign performance monitoring, budget pacing, anomaly detection, alerts, and campaign health scoring using SQLite.

## Project Status

Version 1.0 is complete.

This project simulates a real-time campaign monitoring engine with synthetic marketing data. It starts with raw CSV-style source data, loads it into SQLite, cleans it in staging, calculates KPIs, monitors budget pacing and performance trends, generates alerts, assigns campaign health scores, and provides investigation scenarios.

## Business Problem

Marketing teams need a reliable way to detect campaign issues before they waste budget or miss performance targets. Common problems include high spend with no conversions, ROAS drops, budget overspend, CTR drops, delivery problems, and active campaigns with no impressions.

## Project Features

- Synthetic campaign, platform, region, budget, target, alert, calendar, daily metric, and hourly metric data.
- Raw SQLite tables and sample insert scripts.
- Staging tables with cleaning, standardization, and quality flags.
- KPI calculations for CTR, CPC, CPM, CVR, CPA, ROAS, and AOV.
- Campaign, platform, region, daily, and hourly summaries.
- Budget pacing calculations and projected spend.
- Previous-day and 7-day performance monitoring.
- SQL-based anomaly detection.
- Alert severity, readable messages, and recommended actions.
- Campaign health score from 0 to 100.
- Critical campaign summary.
- Investigation scenario queries.
- Final validation and sample output queries.

## Tools Used

- SQLite
- DB Browser for SQLite
- SQL
- CSV
- VS Code or any text editor

No Python, PySpark, APIs, Docker, cloud services, dashboards, stored procedures, temporary functions, or machine learning are used in Version 1.0.

## Architecture

```text
Synthetic CSV data
  -> raw SQLite tables
  -> staging tables
  -> KPI calculation tables
  -> budget pacing and performance monitoring layer
  -> anomaly detection and alert engine
  -> campaign health score
  -> investigation scenarios
  -> final validation and sample outputs
```

## Final Folder Structure

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
  FINAL_PROJECT_REVIEW.md
  PROJECT_COMPLETION_SUMMARY.md
  MANUAL_TESTING_CHECKLIST.md
  GITHUB_PORTFOLIO_DESCRIPTION.md
  LICENSE
  data/
    raw/
    sample_outputs/
  database/
  docs/
  investigations/
  sql/
  validation/
```

## Phase Summary

- Phase 1: Raw data foundation and synthetic datasets.
- Phase 2: Staging layer, cleaning, and data quality flags.
- Phase 3: KPI calculation engine and summaries.
- Phase 4: Budget pacing and performance monitoring.
- Phase 5: Anomaly detection, alerts, health scoring, and investigations.
- Phase 6: Final validation, documentation, and GitHub polish.

## How To Run Locally

1. Open DB Browser for SQLite.
2. Create a new SQLite database file.
3. Open the Execute SQL tab.
4. Run the SQL scripts in the exact order below.
5. Run validation scripts.
6. Review sample output and investigation queries.

## Exact SQL Run Order

1. `sql/01_create_raw_tables.sql`
2. `sql/02_insert_sample_data.sql`
3. `sql/03_create_staging_tables.sql`
4. `sql/04_data_quality_checks.sql`
5. `sql/05_kpi_calculations.sql`
6. `sql/06_budget_pacing_and_monitoring.sql`
7. `sql/07_anomaly_detection_and_alerts.sql`
8. `sql/08_final_project_validation.sql`

## Validation Process

Run validation files after the SQL pipeline has completed. The final validation files are:

- `validation/final_pipeline_validation_checks.sql`
- `validation/final_business_output_checks.sql`

Earlier validation files check raw loads, staging quality, KPI reconciliation, budget pacing, performance monitoring, alerts, and health scores.

## Sample Output Queries

Use `data/sample_outputs/sample_output_queries.sql` to review demo-ready outputs such as campaign KPIs, platform summaries, budget pacing, alerts, health scores, critical campaigns, and an executive summary.

## Investigation Scenarios

The `investigations/` folder includes six SQL scenarios:

- High spend with zero conversions
- ROAS drop
- Budget overspend
- CTR or traffic drop
- Active campaign with no impressions
- Critical campaigns

## What This Project Demonstrates

- SQL data engineering
- Analytics engineering design
- Data quality and reconciliation checks
- KPI modeling
- Budget pacing logic
- Window functions
- Alerting rules
- Campaign health scoring
- Business-oriented documentation

## Known Limitations

This is a SQLite simulation with synthetic data. It does not include live API ingestion, real streaming, dashboard files, cloud orchestration, or machine learning. It is designed as a portfolio project, not a production system.

## Future Enhancements

Future versions could add CSV exports, a Power BI or Looker Studio dashboard, a BigQuery version, dbt or Python pipeline orchestration, real ad platform ingestion, alert notifications, and ML-based anomaly detection.

## Interview Talking Points

This project shows how to design an end-to-end SQL monitoring engine. It demonstrates how raw marketing data can be transformed into clean staged data, KPI outputs, budget pacing, alert severity, health scores, and actionable investigation views.

## Final Project Status

Version 1.0 is complete and ready for manual review, GitHub portfolio presentation, and interview walkthroughs.
