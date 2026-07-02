# Phase 4 Budget Pacing And Monitoring

## What Phase 4 Adds

Phase 4 adds a budget pacing and performance monitoring layer. It compares actual spend against expected spend, projects final campaign spend, and monitors daily KPI movement against previous-day and 7-day baselines.

## Why Budget Pacing Matters

Campaigns can overspend or underspend before teams notice. Budget pacing helps analysts understand whether spend is tracking against budget expectations and whether a campaign may finish above or below its allocation.

## Why Previous-Day And 7-Day Comparisons Are Useful

Previous-day comparisons show short-term movement. Seven-day averages provide a steadier baseline so single-day traffic drops, spend spikes, conversion drops, and ROAS changes are easier to review.

## KPI Layer vs Monitoring Layer

- KPI layer: calculates CTR, CPC, CPM, CVR, CPA, ROAS, and AOV.
- Monitoring layer: compares KPI and spend behavior over time and labels pacing or performance trends.

Phase 4 does not create final alerts or campaign health scores.

## New Tables Created

- `campaign_budget_pacing_daily`
- `campaign_budget_pacing_summary`
- `campaign_daily_performance_monitoring`
- `campaign_performance_monitoring_summary`
- `campaign_monitoring_dashboard_summary`

## Budget Pacing Formulas

- `actual_spend_to_date = cumulative campaign spend ordered by metric_date`
- `budget_duration_days = budget_end_date - budget_start_date + 1`
- `budget_day_number = metric_date position within the budget date range`
- `expected_spend_to_date = daily_budget * budget_day_number`
- `remaining_budget = total_budget - actual_spend_to_date`
- `spend_variance_amount = actual_spend_to_date - expected_spend_to_date`
- `spend_variance_percentage = spend_variance_amount / expected_spend_to_date`
- `pacing_ratio = actual_spend_to_date / expected_spend_to_date`
- `projected_total_spend = actual_spend_to_date / budget_day_number * budget_duration_days`
- `projected_budget_variance = projected_total_spend - total_budget`
- `budget_utilization_percentage = actual_spend_to_date / total_budget`

## Trend Monitoring Formulas

- Previous-day percentage change compares the current metric to `LAG(metric)`.
- Seven-day comparison compares the current metric to `AVG(metric)` over the previous seven rows.
- Divide-by-zero cases return `0`.

## Status Rules

Budget pacing status values include `No Budget`, `No Spend Yet`, `Critical Overspend`, `Overspending`, `On Track`, `Underspending`, `Critical Underspend`, and `Unknown`.

Trend monitoring status values identify traffic drops or spikes, conversion drops or spikes, spend drops or spikes, and ROAS drops or improvements.

The overall watch status highlights combinations such as spend spike with ROAS drop, traffic drop, conversion drop, improvement, or stable performance.

## How To Run Phase 4 Locally

1. Run `sql/01_create_raw_tables.sql`.
2. Run `sql/02_insert_sample_data.sql`.
3. Run `sql/03_create_staging_tables.sql`.
4. Run `sql/04_data_quality_checks.sql`.
5. Run `sql/05_kpi_calculations.sql`.
6. Run `sql/06_budget_pacing_and_monitoring.sql`.
7. Run the Phase 4 validation scripts in `validation/`.

## Manual Checks To Perform

- Confirm budget pacing table row counts look reasonable.
- Review records with negative remaining budget.
- Review campaigns with high budget utilization.
- Review counts by budget pacing status and budget risk level.
- Review traffic, conversion, spend, and ROAS trend status counts.
- Open `campaign_monitoring_dashboard_summary` and review the highest-spend campaigns.

## What Phase 4 Does Not Include Yet

Phase 4 does not include final anomaly detection, alert generation, campaign health scores, dashboards, APIs, cloud services, Docker, Python, PySpark, or machine learning.
