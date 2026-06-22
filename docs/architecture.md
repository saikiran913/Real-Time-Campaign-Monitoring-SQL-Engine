# Architecture

This is a local SQL simulation project built with synthetic CSV files, SQLite raw tables, SQLite staging tables, and KPI calculation tables.

## Data Flow

Synthetic CSV data -> raw SQLite tables -> staging tables -> KPI calculation tables -> validation and reconciliation checks -> future budget pacing and alert engine

## Phase 1 Architecture

The `data/raw/` folder stores the source-like CSV extracts. The `sql/` folder creates and loads raw SQLite tables. The `validation/` folder contains checks that confirm the load behaves as expected. Later phases will add cleaned staging models, KPI calculations, alerts, health scores, and reporting-ready outputs.

## Phase 2 Architecture

Phase 2 adds staging tables populated from the raw tables. The staging layer keeps the raw row grain, cleans simple formatting issues, standardizes key values, and adds quality flags.

The staging layer does not remove bad rows silently. Rows with unknown campaign IDs, invalid metric dates, invalid budgets, suspicious metric relationships, or invalid hourly values remain available for review.

Future phases will use the staging layer as the input for KPI calculations, budget pacing, alert logic, and campaign health scoring.

## Phase 3 Architecture

Phase 3 creates KPI tables from the staging layer. The daily and hourly fact tables join staged metrics to campaign, platform, region, and target information. Summary tables aggregate those facts by campaign, platform, region, date, and hour.

The KPI layer calculates CTR, CPC, CPM, CVR, CPA, ROAS, and AOV. Validation checks look for impossible KPI values and reconciliation checks confirm totals remain consistent between staging, fact, and summary layers.

Future phases will build budget pacing, alert generation, anomaly-style investigation logic, and campaign health scoring on top of the KPI layer.
