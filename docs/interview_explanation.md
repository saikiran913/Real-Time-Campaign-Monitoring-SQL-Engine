# Interview Explanation

## How To Explain This Project

This project is a SQL-first campaign monitoring engine built locally in SQLite. Phase 1 focuses on the foundation: realistic synthetic source data, raw table creation, data loading, and validation checks.

## Why This Project Is Useful

It mirrors a common analytics engineering problem: marketing teams need clean, reliable campaign data before they can calculate KPIs, monitor budgets, or trigger performance alerts.

## What Phase 1 Proves

Phase 1 proves that the project has a clear schema, consistent synthetic datasets, repeatable setup scripts, and basic validation coverage. It also shows discipline around scope by keeping staging, KPIs, alerts, dashboards, and orchestration for later phases.

## How To Explain Phase 2

In Phase 2, I created a staging layer to clean and standardize raw campaign data. I added quality flags to detect invalid campaign dates, metric issues, invalid budgets, unknown campaign IDs, and invalid hourly records.

The key design choice is that bad rows are not removed silently. They stay in staging tables and are flagged so the business can review them before later KPI calculations use the data.

This prepares the project for Phase 3 KPI calculations by creating cleaner, more consistent inputs without hiding data quality problems.

## What Future Phases Will Add

Future phases will transform raw data into staging tables, calculate campaign KPIs, evaluate targets and budgets, generate alerts, assign campaign health scores, and produce output tables for reporting.
