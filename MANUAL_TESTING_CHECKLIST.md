# Manual Testing Checklist

## Local Setup

- [ ] Open the project in VS Code.
- [ ] Open DB Browser for SQLite.
- [ ] Create a new SQLite database file.
- [ ] Open the Execute SQL tab.

## SQL Script Execution

- [ ] Run `sql/01_create_raw_tables.sql`.
- [ ] Run `sql/02_insert_sample_data.sql`.
- [ ] Run `sql/03_create_staging_tables.sql`.
- [ ] Run `sql/04_data_quality_checks.sql`.
- [ ] Run `sql/05_kpi_calculations.sql`.
- [ ] Run `sql/06_budget_pacing_and_monitoring.sql`.
- [ ] Run `sql/07_anomaly_detection_and_alerts.sql`.
- [ ] Run `sql/08_final_project_validation.sql`.

## Table Checks

- [ ] Check raw tables.
- [ ] Check staging tables.
- [ ] Check KPI tables.
- [ ] Check monitoring tables.
- [ ] Check anomaly and alert tables.
- [ ] Check health score tables.

## Validation Checks

- [ ] Run all files in `validation/`.
- [ ] Confirm Pass/Fail checks are understood.
- [ ] Confirm health scores are between 0 and 100.
- [ ] Confirm alert messages are populated.
- [ ] Confirm recommended actions are populated.

## Investigation Checks

- [ ] Run each investigation scenario.
- [ ] Review critical campaign outputs.
- [ ] Confirm scenario queries are easy to explain.

## Documentation Checks

- [ ] Review `README.md`.
- [ ] Review `run_order.md`.
- [ ] Review `docs/final_project_walkthrough.md`.
- [ ] Review `docs/final_validation_guide.md`.
- [ ] Review `GITHUB_PORTFOLIO_DESCRIPTION.md`.
