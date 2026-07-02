# Changelog

## 1.0.0 - Final Project Completion

Completed the Version 1.0 SQL portfolio project.

- Completed final documentation polish
- Added final project validation script
- Added final pipeline validation checks
- Added final business output checks
- Added sample output queries
- Added final project walkthrough
- Added manual testing checklist
- Added GitHub portfolio description
- Updated README as final project landing page
- Updated run order as final source of truth
- Marked project as Version 1.0 complete

## 0.5.0 - Phase 5 Anomaly Detection, Alerts, and Health Score

Added the Phase 5 anomaly detection, alert, health score, and investigation layer.

- Added campaign anomaly detection table
- Added campaign alert summary table
- Added campaign health score table
- Added critical campaign summary table
- Added campaign alert rule mapping table
- Added anomaly detection validation checks
- Added alert validation checks
- Added health score validation checks
- Added investigation scenario SQL files
- Updated documentation

## 0.4.0 - Phase 4 Budget Pacing and Performance Monitoring

Added the Phase 4 budget pacing and performance monitoring layer.

- Added campaign daily budget pacing table
- Added campaign budget pacing summary table
- Added daily performance monitoring table
- Added performance monitoring summary table
- Added campaign monitoring dashboard summary table
- Added budget pacing validation checks
- Added performance monitoring validation checks
- Updated documentation

## 0.3.0 - Phase 3 KPI Calculation Engine

Added the Phase 3 KPI calculation engine.

- Added campaign daily performance fact table
- Added campaign hourly performance fact table
- Added campaign KPI summary table
- Added platform KPI summary table
- Added region KPI summary table
- Added daily KPI trend summary
- Added hourly KPI trend summary
- Added KPI validation checks
- Added KPI reconciliation checks
- Updated documentation

## 0.2.0 - Phase 2 Staging Layer

Added the Phase 2 staging and data quality layer.

- Added `sql/03_create_staging_tables.sql`
- Added `sql/04_data_quality_checks.sql`
- Added staging tables
- Added cleaning logic
- Added data quality flags
- Added campaign date validation
- Added referential integrity checks
- Added metric sanity checks
- Added `docs/phase_2_staging_layer.md`
- Updated README, run order, SQL documentation, validation documentation, architecture notes, interview explanation, data dictionary, and business rules
- Documented the rule that bad rows are flagged and not removed silently

## 0.1.0 - Phase 1 Foundation

Created the Phase 1 project foundation for the Real-Time Campaign Monitoring SQL Engine.

Files created:

- README.md
- project_overview.md
- data_dictionary.md
- business_rules.md
- run_order.md
- known_limitations.md
- future_enhancements.md
- CHANGELOG.md
- data/raw/campaigns.csv
- data/raw/ad_platforms.csv
- data/raw/campaign_daily_metrics.csv
- data/raw/campaign_hourly_metrics.csv
- data/raw/budget_allocations.csv
- data/raw/campaign_targets.csv
- data/raw/campaign_alert_rules.csv
- data/raw/calendar.csv
- data/raw/regions.csv
- data/sample_outputs/README.md
- database/README.md
- sql/01_create_raw_tables.sql
- sql/02_insert_sample_data.sql
- sql/README.md
- docs/architecture.md
- docs/phase_1_setup.md
- docs/interview_explanation.md
- investigations/README.md
- validation/expected_row_counts.sql
- validation/null_check_queries.sql
- validation/duplicate_check_queries.sql
- validation/README.md
