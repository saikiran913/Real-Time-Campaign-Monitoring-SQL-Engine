# Validation

Use these queries after loading the Phase 1 sample data.

- `expected_row_counts.sql` confirms table row counts.
- `null_check_queries.sql` checks important required fields.
- `duplicate_check_queries.sql` checks uniqueness at the expected raw data grains.

Run validation after `sql/01_create_raw_tables.sql` and `sql/02_insert_sample_data.sql` are complete.
