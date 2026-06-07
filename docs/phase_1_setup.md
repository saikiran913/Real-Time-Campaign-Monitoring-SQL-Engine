# Phase 1 Setup

## What Was Created

Phase 1 creates synthetic campaign CSV files, SQLite raw table DDL, matching insert statements, validation queries, and documentation.

## How To Run The Scripts

Open DB Browser for SQLite, create or open a local database file, and run the scripts in this order:

1. `sql/01_create_raw_tables.sql`
2. `sql/02_insert_sample_data.sql`
3. `validation/expected_row_counts.sql`
4. `validation/null_check_queries.sql`
5. `validation/duplicate_check_queries.sql`

## What To Manually Check

- Raw tables were created successfully.
- Insert script completed without errors.
- Row counts match expected values.
- Required fields have no nulls.
- Duplicate checks return no records.

## Common Issues And Fixes

- If insert statements fail, rerun `01_create_raw_tables.sql` first to reset the raw tables.
- If row counts are too high, the insert script may have been run more than once without recreating tables.
- If a database file is locked, close other DB Browser windows and reopen the database.
