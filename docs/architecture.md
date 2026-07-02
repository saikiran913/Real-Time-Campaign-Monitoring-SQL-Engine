# Architecture

## Layered Architecture

This project uses a layered SQLite architecture that mirrors a small analytics engineering workflow.

```text
Synthetic CSV data
  -> raw SQLite tables
  -> staging tables
  -> KPI calculation tables
  -> budget pacing and performance monitoring layer
  -> anomaly detection and alert engine
  -> campaign health score
  -> investigation scenarios
  -> final validation layer
```

## Raw Layer

The raw layer stores synthetic source-like records. It includes campaign master data, platforms, regions, calendar rows, daily metrics, hourly metrics, budgets, targets, and alert rules.

## Staging Layer

The staging layer trims text, standardizes values, handles null numeric fields, and adds data quality flags. Bad rows are not removed silently.

## KPI Layer

The KPI layer calculates CTR, CPC, CPM, CVR, CPA, ROAS, and AOV. It also creates campaign, platform, region, daily, and hourly summaries.

## Monitoring Layer

The monitoring layer adds budget pacing, projected spend, previous-day comparisons, and 7-day average comparisons.

## Anomaly And Alert Layer

The anomaly layer flags campaign issues. The alert layer assigns severity, creates readable messages, and recommends actions.

## Health Score Layer

The health score layer assigns each campaign a score from 0 to 100 and classifies campaigns as Healthy, Watch, At Risk, or Critical.

## Investigation Layer

Investigation SQL files provide focused views for common campaign problems.

## Final Validation Layer

Final validation checks table existence, row counts, reconciliations, business outputs, alerts, and health scores.
