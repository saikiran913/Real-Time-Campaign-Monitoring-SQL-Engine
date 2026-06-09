# Validation

Use these queries after loading the Phase 1 sample data.

- `expected_row_counts.sql` confirms table row counts.
- `null_check_queries.sql` checks important required fields.
- `duplicate_check_queries.sql` checks uniqueness at the expected raw data grains.
- `staging_row_counts.sql` compares raw and staging row counts.
- `referential_integrity_checks.sql` checks whether IDs connect across staging tables.
- `metric_sanity_checks.sql` checks negative and suspicious metric relationships.

Run Phase 1 validation after `sql/01_create_raw_tables.sql` and `sql/02_insert_sample_data.sql` are complete. Run Phase 2 validation after `sql/03_create_staging_tables.sql` is complete.

Phase 2 validation is designed to surface questionable rows. It should not be used to delete rows silently.
