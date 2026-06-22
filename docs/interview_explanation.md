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

## How To Explain Phase 3

In Phase 3, I created a KPI calculation engine on top of the staging layer. I calculated marketing KPIs such as CTR, CPC, CPM, CVR, CPA, ROAS, and AOV.

I created daily, hourly, campaign, platform, region, and trend summary tables. I also added target comparison logic so each campaign can be evaluated against CTR, CPC, CPA, ROAS, and CVR targets.

To make the layer trustworthy, I added validation and reconciliation checks that compare metric totals between the staging layer, KPI facts, and KPI summaries.

## What Future Phases Will Add

Future phases will transform raw data into staging tables, calculate campaign KPIs, evaluate targets and budgets, generate alerts, assign campaign health scores, and produce output tables for reporting.
