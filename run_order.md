# Run Order

## Exact SQL Run Order

1. Run `sql/01_create_raw_tables.sql`.
2. Run `sql/02_insert_sample_data.sql`.
3. Run `sql/03_create_staging_tables.sql`.
4. Run `sql/04_data_quality_checks.sql`.
5. Run `sql/05_kpi_calculations.sql`.
6. Run `validation/expected_row_counts.sql`.
7. Run `validation/null_check_queries.sql`.
8. Run `validation/duplicate_check_queries.sql`.
9. Run `validation/staging_row_counts.sql`.
10. Run `validation/referential_integrity_checks.sql`.
11. Run `validation/metric_sanity_checks.sql`.
12. Run `validation/kpi_validation_checks.sql`.
13. Run `validation/kpi_reconciliation_checks.sql`.

## Manual Checking Steps

- Confirm all raw tables exist.
- Confirm expected row counts match the comments in `expected_row_counts.sql`.
- Confirm null checks return zero for required fields.
- Confirm duplicate checks return no rows.
- Open CSV files in `data/raw/` and confirm headers match raw table columns.
- Confirm staging row counts match raw row counts.
- Review all Phase 2 quality flags.
- Confirm bad rows are flagged and not removed silently.
- Confirm KPI fact row counts match staging metric row counts.
- Confirm KPI reconciliation checks return `Pass`.
- Spot-check a few KPI formulas manually.
