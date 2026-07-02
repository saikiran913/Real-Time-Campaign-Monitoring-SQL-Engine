# SQL Scripts

Run these files in numeric order. Later files depend on tables created by earlier files.

## Table-Creating Scripts

- `01_create_raw_tables.sql`: Creates raw SQLite tables.
- `02_insert_sample_data.sql`: Inserts synthetic sample data into raw tables.
- `03_create_staging_tables.sql`: Creates and populates staging tables.
- `05_kpi_calculations.sql`: Creates KPI fact and summary tables.
- `06_budget_pacing_and_monitoring.sql`: Creates budget pacing and monitoring tables.
- `07_anomaly_detection_and_alerts.sql`: Creates anomaly, alert, health score, critical campaign, and alert rule mapping tables.

## SELECT-Only Scripts

- `04_data_quality_checks.sql`: Data quality checks after staging.
- `08_final_project_validation.sql`: Final project-level validation and review queries.

## Safe Running Notes

- Run scripts in numeric order.
- Do not run later scripts before dependencies exist.
- Re-running table-creating scripts may drop and recreate their own output tables.
- Validation scripts are SELECT-only and do not modify data.
