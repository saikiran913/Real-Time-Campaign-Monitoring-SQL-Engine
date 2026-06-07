# Architecture

This is a local SQL simulation project built with synthetic CSV files and SQLite raw tables.

## Data Flow

Synthetic CSV data -> SQLite raw tables -> validation scripts -> future staging and analytics layers

## Phase 1 Architecture

The `data/raw/` folder stores the source-like CSV extracts. The `sql/` folder creates and loads raw SQLite tables. The `validation/` folder contains checks that confirm the load behaves as expected. Later phases will add cleaned staging models, KPI calculations, alerts, health scores, and reporting-ready outputs.
