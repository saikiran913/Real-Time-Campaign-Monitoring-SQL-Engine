# SQL Scripts

## 01_create_raw_tables.sql

Drops and recreates the Phase 1 raw tables using SQLite-compatible SQL.

## 02_insert_sample_data.sql

Inserts the same synthetic records that are provided in the CSV files under `data/raw/`.

Phase 1 includes only raw table creation and sample data insertion. Staging, analytics, KPI, budget pacing, and alert logic will be added in later phases.
