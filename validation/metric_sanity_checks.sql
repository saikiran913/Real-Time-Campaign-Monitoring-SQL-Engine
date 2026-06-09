-- Metric sanity checks for Phase 2.
-- Run after sql/03_create_staging_tables.sql.

SELECT * FROM raw_campaign_daily_metrics WHERE impressions < 0;
SELECT * FROM raw_campaign_daily_metrics WHERE clicks < 0;
SELECT * FROM raw_campaign_daily_metrics WHERE spend < 0;
SELECT * FROM raw_campaign_daily_metrics WHERE conversions < 0;
SELECT * FROM raw_campaign_daily_metrics WHERE revenue < 0;

SELECT * FROM raw_campaign_hourly_metrics WHERE impressions < 0;
SELECT * FROM raw_campaign_hourly_metrics WHERE clicks < 0;
SELECT * FROM raw_campaign_hourly_metrics WHERE spend < 0;
SELECT * FROM raw_campaign_hourly_metrics WHERE conversions < 0;
SELECT * FROM raw_campaign_hourly_metrics WHERE revenue < 0;

SELECT * FROM stg_campaign_daily_metrics WHERE clicks > impressions;
SELECT * FROM stg_campaign_hourly_metrics WHERE clicks > impressions;

SELECT * FROM stg_campaign_daily_metrics WHERE conversions > clicks;
SELECT * FROM stg_campaign_hourly_metrics WHERE conversions > clicks;

SELECT * FROM stg_campaign_daily_metrics WHERE spend > 0 AND impressions = 0;
SELECT * FROM stg_campaign_hourly_metrics WHERE spend > 0 AND impressions = 0;

SELECT * FROM stg_campaign_daily_metrics WHERE spend > 0 AND clicks = 0;
SELECT * FROM stg_campaign_hourly_metrics WHERE spend > 0 AND clicks = 0;

SELECT * FROM stg_campaign_daily_metrics WHERE revenue > 0 AND conversions = 0;
SELECT * FROM stg_campaign_hourly_metrics WHERE revenue > 0 AND conversions = 0;
