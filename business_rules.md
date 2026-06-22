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
