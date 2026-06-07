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
