# Architecture

This is a local SQL simulation project built with synthetic CSV files, SQLite raw tables, and SQLite staging tables.

## Data Flow

Synthetic CSV data -> raw SQLite tables -> staging tables -> data quality checks -> future KPI and monitoring layer

## Phase 1 Architecture

The `data/raw/` folder stores the source-like CSV extracts. The `sql/` folder creates and loads raw SQLite tables. The `validation/` folder contains checks that confirm the load behaves as expected. Later phases will add cleaned staging models, KPI calculations, alerts, health scores, and reporting-ready outputs.

## Phase 2 Architecture

Phase 2 adds staging tables populated from the raw tables. The staging layer keeps the raw row grain, cleans simple formatting issues, standardizes key values, and adds quality flags.

The staging layer does not remove bad rows silently. Rows with unknown campaign IDs, invalid metric dates, invalid budgets, suspicious metric relationships, or invalid hourly values remain available for review.

Future phases will use the staging layer as the input for KPI calculations, budget pacing, alert logic, and campaign health scoring.
