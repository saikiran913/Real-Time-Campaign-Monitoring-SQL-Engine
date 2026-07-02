# Validation

The validation folder contains SELECT-only SQL checks for each project layer.

## Files

- `expected_row_counts.sql`: Raw table row counts.
- `null_check_queries.sql`: Null checks for required fields.
- `duplicate_check_queries.sql`: Duplicate checks.
- `staging_row_counts.sql`: Raw versus staging counts.
- `referential_integrity_checks.sql`: ID relationship checks.
- `metric_sanity_checks.sql`: Metric sanity checks.
- `kpi_validation_checks.sql`: KPI value checks.
- `kpi_reconciliation_checks.sql`: KPI reconciliation checks.
- `budget_pacing_validation_checks.sql`: Budget pacing checks.
- `performance_monitoring_validation_checks.sql`: Monitoring checks.
- `anomaly_detection_validation_checks.sql`: Anomaly checks.
- `alert_validation_checks.sql`: Alert checks.
- `health_score_validation_checks.sql`: Health score checks.
- `final_pipeline_validation_checks.sql`: Final pipeline checks.
- `final_business_output_checks.sql`: Final business output checks.

## When To Run

Run validation after the SQL pipeline has completed through `sql/08_final_project_validation.sql`.

## Good Results

Good results usually mean row counts are populated, Pass/Fail checks show `Pass`, health scores are within bounds, and issue-finding queries return either understandable rows or zero rows.

## Zero Row Results

Some checks are expected to return zero rows when no issue exists, such as null campaign IDs, out-of-range health scores, or missing alert messages.

## Interpreting Fail Results

If a check returns `Fail`, confirm the SQL scripts were run in the documented order and inspect the source and target tables named in the check.
