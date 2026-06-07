-- Duplicate checks for raw identifier and metric grain columns.
-- These queries should return zero rows when the loaded data is unique at the expected grain.

SELECT campaign_id, COUNT(*) AS duplicate_count FROM raw_campaigns GROUP BY campaign_id HAVING COUNT(*) > 1;
SELECT platform_id, COUNT(*) AS duplicate_count FROM raw_ad_platforms GROUP BY platform_id HAVING COUNT(*) > 1;
SELECT region_id, COUNT(*) AS duplicate_count FROM raw_regions GROUP BY region_id HAVING COUNT(*) > 1;
SELECT campaign_id, metric_date, COUNT(*) AS duplicate_count FROM raw_campaign_daily_metrics GROUP BY campaign_id, metric_date HAVING COUNT(*) > 1;
SELECT campaign_id, metric_date, metric_hour, COUNT(*) AS duplicate_count FROM raw_campaign_hourly_metrics GROUP BY campaign_id, metric_date, metric_hour HAVING COUNT(*) > 1;
