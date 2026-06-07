-- Null checks for important Phase 1 columns.
-- Any returned row with null_count greater than 0 should be reviewed.

SELECT 'raw_campaigns.campaign_id' AS check_name, COUNT(*) AS null_count FROM raw_campaigns WHERE campaign_id IS NULL;
SELECT 'raw_campaigns.platform_id' AS check_name, COUNT(*) AS null_count FROM raw_campaigns WHERE platform_id IS NULL;
SELECT 'raw_campaigns.region_id' AS check_name, COUNT(*) AS null_count FROM raw_campaigns WHERE region_id IS NULL;
SELECT 'raw_campaign_daily_metrics.metric_date' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE metric_date IS NULL;
SELECT 'raw_campaign_daily_metrics.campaign_id' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE campaign_id IS NULL;
SELECT 'raw_campaign_daily_metrics.impressions' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE impressions IS NULL;
SELECT 'raw_campaign_daily_metrics.clicks' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE clicks IS NULL;
SELECT 'raw_campaign_daily_metrics.spend' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE spend IS NULL;
SELECT 'raw_campaign_daily_metrics.conversions' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE conversions IS NULL;
SELECT 'raw_campaign_daily_metrics.revenue' AS check_name, COUNT(*) AS null_count FROM raw_campaign_daily_metrics WHERE revenue IS NULL;
SELECT 'raw_campaign_hourly_metrics.metric_date' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE metric_date IS NULL;
SELECT 'raw_campaign_hourly_metrics.impressions' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE impressions IS NULL;
SELECT 'raw_campaign_hourly_metrics.clicks' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE clicks IS NULL;
SELECT 'raw_campaign_hourly_metrics.spend' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE spend IS NULL;
SELECT 'raw_campaign_hourly_metrics.conversions' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE conversions IS NULL;
SELECT 'raw_campaign_hourly_metrics.revenue' AS check_name, COUNT(*) AS null_count FROM raw_campaign_hourly_metrics WHERE revenue IS NULL;
