# Business Rules

## Metric Rules

- Impressions should usually be greater than clicks.
- Clicks should usually be greater than conversions.
- Spend should be positive for paid active campaigns.
- Revenue may be zero when a campaign has no conversions or when attribution is not available.
- CTR, CPC, CPA, CVR, and ROAS will be calculated in later phases, not Phase 1.

## Campaign Monitoring Assumptions

- Synthetic records simulate campaign activity over a 90-day calendar window.
- Hourly metrics represent near-real-time monitoring samples, not true streaming data.
- Planned campaigns may still have example data in Phase 1 to keep the raw dataset broad for future testing.

## Budget Assumptions

- Each campaign has one budget allocation row.
- Budgets vary by channel and campaign length.
- Budget pacing logic will be added in a future phase.

## Alert Rule Assumptions

- Alert rules are stored as definitions only in Phase 1.
- Rule evaluation and alert output tables will be added later.
- Severity values are Low, Medium, High, and Critical.

## Data Quality Assumptions

- Raw tables intentionally do not enforce constraints so they behave like landing tables.
- Validation scripts are used to manually check row counts, nulls, and duplicates.
- A few intentional monitoring problems are included in the metric data for future investigation logic.

## Phase 2 Cleaning Rules

- Staging tables are populated from raw tables.
- Text fields are trimmed where appropriate.
- Campaign statuses are standardized to Active, Paused, Completed, Planned, or Unknown.
- Alert rule severity values are standardized to Low, Medium, High, Critical, or Unknown.
- Currency values are uppercased.
- Null numeric metric, budget, and target values are replaced with `0`.
- Negative metric values are set to `0` in staging and flagged as `Negative Metric Found`.

## Phase 2 Validation Rules

- Bad rows must not be removed silently.
- Staging row counts should match raw row counts.
- Unknown campaign IDs are flagged with `is_known_campaign = 0`.
- Metric dates outside campaign start and end dates are flagged with `is_campaign_date_valid = 0`.
- Invalid campaign dates, budgets, targets, alert rules, and hourly values receive explicit quality flags.
- KPI calculations are not included in Phase 2.

## Phase 3 KPI Formula Definitions

- `ctr = clicks / impressions`
- `cpc = spend / clicks`
- `cpm = spend / impressions * 1000`
- `cvr = conversions / clicks`
- `cpa = spend / conversions`
- `roas = revenue / spend`
- `aov = revenue / conversions`

## Phase 3 Target Comparison Rules

- CTR meets target when `ctr >= target_ctr`.
- CPC meets target when `cpc <= target_cpc` and `cpc > 0`.
- CPA meets target when `cpa <= target_cpa` and `cpa > 0`.
- ROAS meets target when `roas >= target_roas`.
- CVR meets target when `cvr >= target_cvr`.
- Missing or zero targets return `No Target`.

## Phase 3 Divide-By-Zero Rules

- If impressions are `0`, CTR and CPM return `0`.
- If clicks are `0`, CPC and CVR return `0`.
- If conversions are `0`, CPA and AOV return `0`.
- If spend is `0`, ROAS returns `0`.

## Phase 3 Reconciliation Assumptions

- KPI fact tables should preserve staging metric totals.
- Campaign, platform, region, daily, and hourly summaries should reconcile back to their fact table sources.
- Rounding is applied to currency-like and ratio values for readability.
- Budget pacing, anomaly detection, alert generation, and campaign health scoring are outside Phase 3 scope.

## Phase 4 Budget Pacing Formula Definitions

- `actual_spend_to_date` is cumulative campaign spend ordered by metric date.
- `budget_duration_days` is the inclusive number of days between budget start and end date.
- `budget_day_number` is the metric date position within the budget date range.
- `expected_spend_to_date = daily_budget * budget_day_number`.
- `remaining_budget = total_budget - actual_spend_to_date`.
- `spend_variance_amount = actual_spend_to_date - expected_spend_to_date`.
- `spend_variance_percentage = spend_variance_amount / expected_spend_to_date`.
- `pacing_ratio = actual_spend_to_date / expected_spend_to_date`.
- `projected_total_spend = actual_spend_to_date / budget_day_number * budget_duration_days`.
- `projected_budget_variance = projected_total_spend - total_budget`.
- `budget_utilization_percentage = actual_spend_to_date / total_budget`.

## Phase 4 Budget Status Rules

- `No Budget` when total budget is missing or `0`.
- `No Spend Yet` when actual spend to date is `0`.
- `Critical Overspend` when pacing ratio is at least `1.30`.
- `Overspending` when pacing ratio is at least `1.10` and below `1.30`.
- `On Track` when pacing ratio is at least `0.90` and below `1.10`.
- `Underspending` when pacing ratio is at least `0.60` and below `0.90`.
- `Critical Underspend` when pacing ratio is below `0.60`.

## Phase 4 Budget Risk Level Rules

- `Critical` for critical overspend or critical underspend.
- `High` for overspending or underspending.
- `Low` for on track.
- `Medium` for no spend yet.
- `Unknown` otherwise.

## Phase 4 Performance Monitoring Rules

- Previous-day comparisons use `LAG()` by campaign ordered by metric date.
- Seven-day average comparisons use the previous seven campaign rows as the baseline.
- Divide-by-zero cases return `0`.
- Traffic drop or spike is based on impressions versus 7-day average.
- Conversion drop or spike is based on conversions versus 7-day average.
- Spend drop or spike is based on spend versus 7-day average.
- ROAS drop or improvement is based on ROAS versus 7-day average.
- Final alert generation and campaign health scoring are outside Phase 4 scope.

## Phase 5 Anomaly Detection Rules

- High spend zero conversion: total spend greater than `100` and total conversions equal `0`.
- ROAS below target: overall ROAS below target ROAS when a target exists.
- CPA above target: overall CPA above target CPA when a target exists.
- CTR below target: overall CTR below target CTR when a target exists.
- Budget overspend: pacing status is `Overspending` or `Critical Overspend`.
- Budget underspend: pacing status is `Underspending` or `Critical Underspend`.
- Spend spike, traffic drop, conversion drop, and ROAS drop come from Phase 4 trend statuses.
- No impressions active campaign: active campaign with zero total impressions.
- Poor efficiency: total spend is greater than total revenue.

## Phase 5 Alert Severity Rules

- `Critical` when at least one critical anomaly exists.
- `High` when at least two high anomalies exist, or one high and one medium anomaly exist.
- `Medium` when one high anomaly exists, or at least two medium anomalies exist.
- `Low` when one medium anomaly exists.
- `No Alert` when anomaly count is `0`.

## Phase 5 Primary Alert Category Rules

Primary alert category uses a priority order that starts with high spend zero conversion, no impressions active campaign, critical budget overspend, ROAS below target, CPA above target, conversion drop, ROAS drop, budget issues, spend spike, traffic drop, CTR below target, poor efficiency, and finally no alert.

## Phase 5 Recommended Action Rules

Recommended actions are business-friendly text values generated from the primary alert category. They suggest checks such as reviewing targeting, conversion tracking, delivery, bid strategy, budget allocation, creative relevance, and landing page performance.

## Phase 5 Campaign Health Score Formula

- Base score starts at `100`.
- KPI issues subtract points for ROAS below target, CPA above target, CTR below target, and poor efficiency.
- Budget issues subtract points for overspending or underspending.
- Trend issues subtract points for conversion drops, ROAS drops, traffic drops, and spend spikes.
- Severe anomalies subtract points for high spend with zero conversions and no impressions on active campaigns.
- Each anomaly subtracts an additional `5` points.
- Final score is capped between `0` and `100`.

## Phase 5 Health Status Thresholds

- `Critical` when final health score is below `40`.
- `At Risk` when final health score is at least `40` and below `65`.
- `Watch` when final health score is at least `65` and below `80`.
- `Healthy` when final health score is at least `80`.

## Phase 5 Critical Campaign Selection Rules

Critical campaign summary includes campaigns with `Critical` or `At Risk` health status, or `Critical` or `High` alert severity.

## Phase 5 Alert Rule Mapping Assumptions

Generated alert categories are mapped to configured alert rules where a matching rule name exists. If no matching configured rule is found, the mapping status is `No Matching Rule Found`.

## Phase 6 Final Validation Assumptions

- Final validation scripts are SELECT-only.
- Final validation does not create new business logic tables.
- Row count checks should pass when scripts are run in the documented order.
- Metric reconciliation checks compare staging daily metrics to the daily KPI fact table.
- Some validation queries intentionally return zero rows when no issues are found.
- Sample output queries are for review and portfolio demonstrations.
