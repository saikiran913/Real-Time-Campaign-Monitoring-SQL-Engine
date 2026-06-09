-- Phase 2 data quality checks.
-- SELECT queries only. These checks report issues; they do not modify data.

-- Raw vs staging row counts. Counts should match because staging does not remove rows silently.
SELECT 'campaigns' AS dataset, (SELECT COUNT(*) FROM raw_campaigns) AS raw_count, (SELECT COUNT(*) FROM stg_campaigns) AS staging_count;
SELECT 'ad_platforms' AS dataset, (SELECT COUNT(*) FROM raw_ad_platforms) AS raw_count, (SELECT COUNT(*) FROM stg_ad_platforms) AS staging_count;
SELECT 'regions' AS dataset, (SELECT COUNT(*) FROM raw_regions) AS raw_count, (SELECT COUNT(*) FROM stg_regions) AS staging_count;
SELECT 'calendar' AS dataset, (SELECT COUNT(*) FROM raw_calendar) AS raw_count, (SELECT COUNT(*) FROM stg_calendar) AS staging_count;
SELECT 'campaign_daily_metrics' AS dataset, (SELECT COUNT(*) FROM raw_campaign_daily_metrics) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_daily_metrics) AS staging_count;
SELECT 'campaign_hourly_metrics' AS dataset, (SELECT COUNT(*) FROM raw_campaign_hourly_metrics) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_hourly_metrics) AS staging_count;
SELECT 'budget_allocations' AS dataset, (SELECT COUNT(*) FROM raw_budget_allocations) AS raw_count, (SELECT COUNT(*) FROM stg_budget_allocations) AS staging_count;
SELECT 'campaign_targets' AS dataset, (SELECT COUNT(*) FROM raw_campaign_targets) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_targets) AS staging_count;
SELECT 'campaign_alert_rules' AS dataset, (SELECT COUNT(*) FROM raw_campaign_alert_rules) AS raw_count, (SELECT COUNT(*) FROM stg_campaign_alert_rules) AS staging_count;

-- Unknown campaign IDs.
SELECT * FROM stg_campaign_daily_metrics WHERE is_known_campaign = 0;
SELECT * FROM stg_campaign_hourly_metrics WHERE is_known_campaign = 0;

-- Invalid campaign metric dates.
SELECT * FROM stg_campaign_daily_metrics WHERE is_campaign_date_valid = 0;
SELECT * FROM stg_campaign_hourly_metrics WHERE is_campaign_date_valid = 0;

-- Negative metrics found in raw tables.
SELECT * FROM raw_campaign_daily_metrics
WHERE impressions < 0 OR clicks < 0 OR spend < 0 OR conversions < 0 OR revenue < 0;
SELECT * FROM raw_campaign_hourly_metrics
WHERE impressions < 0 OR clicks < 0 OR spend < 0 OR conversions < 0 OR revenue < 0;

-- Metric relationship checks.
SELECT * FROM stg_campaign_daily_metrics WHERE clicks > impressions;
SELECT * FROM stg_campaign_daily_metrics WHERE conversions > clicks;
SELECT * FROM stg_campaign_hourly_metrics WHERE clicks > impressions;
SELECT * FROM stg_campaign_hourly_metrics WHERE conversions > clicks;

-- Campaign, budget, hourly, and alert rule quality checks.
SELECT * FROM stg_campaigns WHERE campaign_date_quality_flag <> 'Valid Dates';
SELECT * FROM stg_budget_allocations WHERE budget_quality_flag <> 'Valid Budget';
SELECT * FROM stg_campaign_hourly_metrics WHERE hourly_quality_flag <> 'Valid Hour';
SELECT * FROM stg_campaign_alert_rules WHERE alert_rule_quality_flag <> 'Valid Rule';

-- Duplicate daily and hourly metric grains.
SELECT campaign_id, metric_date, COUNT(*) AS duplicate_count
FROM stg_campaign_daily_metrics
GROUP BY campaign_id, metric_date
HAVING COUNT(*) > 1;

SELECT campaign_id, metric_date, metric_hour, COUNT(*) AS duplicate_count
FROM stg_campaign_hourly_metrics
GROUP BY campaign_id, metric_date, metric_hour
HAVING COUNT(*) > 1;
