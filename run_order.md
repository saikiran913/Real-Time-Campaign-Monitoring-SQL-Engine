# Run Order

## Exact SQL Run Order

1. Run `sql/01_create_raw_tables.sql`.
2. Run `sql/02_insert_sample_data.sql`.
3. Run `validation/expected_row_counts.sql`.
4. Run `validation/null_check_queries.sql`.
5. Run `validation/duplicate_check_queries.sql`.

## Manual Checking Steps

- Confirm all raw tables exist.
- Confirm expected row counts match the comments in `expected_row_counts.sql`.
- Confirm null checks return zero for required fields.
- Confirm duplicate checks return no rows.
- Open CSV files in `data/raw/` and confirm headers match raw table columns.
