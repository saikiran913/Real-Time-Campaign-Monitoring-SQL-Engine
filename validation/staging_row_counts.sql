-- Compare raw table row counts with staging table row counts.
-- Counts should match because Phase 2 flags bad rows instead of removing them silently.

SELECT 'campaigns' AS dataset, (SELECT COUNT(*) FROM raw_campaigns) AS raw_count, (SELECT COUNT(*) FROM stg_campaigns) AS staging_count;
SELECT 'ad_platforms' AS dataset, (SELECT COUNT(*) FROM raw_ad_platforms) AS raw_count, (SELECT COUNT(*) FROM stg_ad_platforms) AS staging_count;
SELECT 'regions' AS dataset, (SELECT COUNT(*) FROM raw_regions) AS raw_count, (SELECT COUNT(*) FROM stg_regions) AS staging_count;
SELECT 'calendar' AS dataset, (SELECT COUNT(*) FROM raw_calendar) AS raw_count, (SELECT COUNT(*) FROM stg_calendar) AS staging_count;
SELECT 'campaign_daily_metrics' AS dataset, (SELECT COUNT(*) FROM raw_campaign_daily_metrics) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_daily_metrics) AS staging_count;
SELECT 'campaign_hourly_metrics' AS dataset, (SELECT COUNT(*) FROM raw_campaign_hourly_metrics) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_hourly_metrics) AS staging_count;
SELECT 'budget_allocations' AS dataset, (SELECT COUNT(*) FROM raw_budget_allocations) AS raw_count, (SELECT COUNT(*) FROM stg_budget_allocations) AS staging_count;
SELECT 'campaign_targets' AS dataset, (SELECT COUNT(*) FROM raw_campaign_targets) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_targets) AS staging_count;
SELECT 'campaign_alert_rules' AS dataset, (SELECT COUNT(*) FROM raw_campaign_alert_rules) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_alert_rules) AS staging_count;
