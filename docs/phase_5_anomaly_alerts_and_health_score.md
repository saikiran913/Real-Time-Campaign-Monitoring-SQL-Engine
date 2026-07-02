# Phase 5 Anomaly Alerts And Health Score

## What Phase 5 Adds

Phase 5 adds SQL-based anomaly detection, campaign alert generation, alert severity classification, recommended actions, campaign health scoring, critical campaign summaries, and investigation scenario queries.

## Why Anomaly Detection Matters

Campaign monitoring is most useful when it highlights records that need attention. Anomaly detection turns KPI, budget pacing, and trend signals into clear issue flags.

## Why Alert Generation Matters

Alert summaries translate technical flags into business-friendly messages and recommended actions. This makes the output easier for analysts, marketers, and interviewers to understand.

## Why Campaign Health Scoring Is Useful

The health score gives each campaign a 0 to 100 status based on KPI performance, budget pacing, trend movement, and anomaly count. It helps prioritize review work.

## Phase 4 Monitoring vs Phase 5 Alerting

- Phase 4 monitors pacing and trends.
- Phase 5 converts those monitoring signals into anomalies, alerts, health scores, and investigation outputs.

## New Tables Created

- `campaign_anomaly_detection`
- `campaign_alert_summary`
- `campaign_health_score`
- `critical_campaign_summary`
- `campaign_alert_rule_mapping`

## Anomaly Rules

Phase 5 flags issues such as high spend with zero conversions, ROAS below target, CPA above target, CTR below target, budget overspend, budget underspend, spend spikes, traffic drops, conversion drops, ROAS drops, no impressions on active campaigns, and poor efficiency.

## Alert Severity Rules

Alerts are classified as `Critical`, `High`, `Medium`, `Low`, or `No Alert` based on the count and severity of detected anomalies.

## Health Score Formula

Each campaign starts at `100`. Points are subtracted for KPI issues, budget pacing issues, performance trend issues, and anomaly count. The final score is capped between `0` and `100`.

## Critical Campaign Summary

`critical_campaign_summary` focuses on campaigns with `Critical` or `At Risk` health status, or `Critical` or `High` alert severity.

## Investigation Scenarios

The `investigations/` folder includes SQL files for high spend with zero conversions, ROAS drops, budget overspend, CTR drops, active campaigns with no impressions, and critical campaigns.

## How To Run Phase 5 Locally

1. Run SQL scripts `01` through `06` in order.
2. Run `sql/07_anomaly_detection_and_alerts.sql`.
3. Run the Phase 5 validation scripts.
4. Run investigation scenario SQL files as needed.

## Manual Checks To Perform

- Review anomaly counts and flag totals.
- Review alert severity and primary alert category counts.
- Confirm alert messages and recommended actions are populated.
- Confirm health scores stay between `0` and `100`.
- Review critical campaign summary for prioritized issues.
- Run each investigation scenario and inspect the output.

## What Phase 5 Does Not Include Yet

Phase 5 does not include final GitHub polish, dashboard files, cloud versions, APIs, Docker, Python, PySpark, or machine learning. Final documentation polish is planned for Phase 6.
