# Run Order

This file is the final source of truth for running Version 1.0.

## SQL Pipeline Run Order

1. `sql/01_create_raw_tables.sql`
2. `sql/02_insert_sample_data.sql`
3. `sql/03_create_staging_tables.sql`
4. `sql/04_data_quality_checks.sql`
5. `sql/05_kpi_calculations.sql`
6. `sql/06_budget_pacing_and_monitoring.sql`
7. `sql/07_anomaly_detection_and_alerts.sql`
8. `sql/08_final_project_validation.sql`

## Validation Run Order

1. `validation/expected_row_counts.sql`
2. `validation/null_check_queries.sql`
3. `validation/duplicate_check_queries.sql`
4. `validation/staging_row_counts.sql`
5. `validation/referential_integrity_checks.sql`
6. `validation/metric_sanity_checks.sql`
7. `validation/kpi_validation_checks.sql`
8. `validation/kpi_reconciliation_checks.sql`
9. `validation/budget_pacing_validation_checks.sql`
10. `validation/performance_monitoring_validation_checks.sql`
11. `validation/anomaly_detection_validation_checks.sql`
12. `validation/alert_validation_checks.sql`
13. `validation/health_score_validation_checks.sql`
14. `validation/final_pipeline_validation_checks.sql`
15. `validation/final_business_output_checks.sql`

## Investigation Run Order

1. `investigations/scenario_01_high_spend_zero_conversion.sql`
2. `investigations/scenario_02_roas_drop.sql`
3. `investigations/scenario_03_budget_overspend.sql`
4. `investigations/scenario_04_ctr_drop.sql`
5. `investigations/scenario_05_campaign_no_impressions.sql`
6. `investigations/scenario_06_critical_campaigns.sql`

## Manual Review Checklist

- Confirm all SQL scripts run without errors.
- Confirm key raw, staging, KPI, monitoring, alert, and health score tables have rows.
- Confirm row count and metric reconciliation checks return `Pass`.
- Confirm health scores are between `0` and `100`.
- Confirm alert messages and recommended actions are populated.
- Review sample output queries.
- Review investigation scenarios.
