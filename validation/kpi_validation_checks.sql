-- Phase 3 KPI validation checks.
-- SELECT queries only. These checks report possible issues and do not modify data.

SELECT 'fact_campaign_daily_performance' AS table_name, COUNT(*) AS row_count FROM fact_campaign_daily_performance;
SELECT 'fact_campaign_hourly_performance' AS table_name, COUNT(*) AS row_count FROM fact_campaign_hourly_performance;
SELECT 'campaign_kpi_summary' AS table_name, COUNT(*) AS row_count FROM campaign_kpi_summary;
SELECT 'platform_kpi_summary' AS table_name, COUNT(*) AS row_count FROM platform_kpi_summary;
SELECT 'region_kpi_summary' AS table_name, COUNT(*) AS row_count FROM region_kpi_summary;

-- KPI values less than 0.
SELECT * FROM fact_campaign_daily_performance
WHERE ctr < 0 OR cpc < 0 OR cpm < 0 OR cvr < 0 OR cpa < 0 OR roas < 0 OR aov < 0;

SELECT * FROM fact_campaign_hourly_performance
WHERE ctr < 0 OR cpc < 0 OR cpm < 0 OR cvr < 0 OR cpa < 0 OR roas < 0 OR aov < 0;

-- Rate sanity checks.
SELECT * FROM fact_campaign_daily_performance WHERE ctr > 1;
SELECT * FROM fact_campaign_hourly_performance WHERE ctr > 1;
SELECT * FROM fact_campaign_daily_performance WHERE cvr > 1;
SELECT * FROM fact_campaign_hourly_performance WHERE cvr > 1;

-- Divide-by-zero handling checks.
SELECT * FROM fact_campaign_daily_performance WHERE clicks = 0 AND cpc <> 0;
SELECT * FROM fact_campaign_hourly_performance WHERE clicks = 0 AND cpc <> 0;
SELECT * FROM fact_campaign_daily_performance WHERE conversions = 0 AND cpa <> 0;
SELECT * FROM fact_campaign_hourly_performance WHERE conversions = 0 AND cpa <> 0;
SELECT * FROM fact_campaign_daily_performance WHERE spend = 0 AND roas <> 0;
SELECT * FROM fact_campaign_hourly_performance WHERE spend = 0 AND roas <> 0;

-- Missing target values.
SELECT * FROM fact_campaign_daily_performance
WHERE target_ctr IS NULL OR target_ctr = 0
   OR target_cpc IS NULL OR target_cpc = 0
   OR target_cpa IS NULL OR target_cpa = 0
   OR target_roas IS NULL OR target_roas = 0
   OR target_cvr IS NULL OR target_cvr = 0;

SELECT * FROM campaign_kpi_summary
WHERE target_ctr IS NULL OR target_ctr = 0
   OR target_cpc IS NULL OR target_cpc = 0
   OR target_cpa IS NULL OR target_cpa = 0
   OR target_roas IS NULL OR target_roas = 0
   OR target_cvr IS NULL OR target_cvr = 0;

-- Carried-forward Phase 2 data quality checks.
SELECT * FROM fact_campaign_daily_performance WHERE is_known_campaign = 0;
SELECT * FROM fact_campaign_hourly_performance WHERE is_known_campaign = 0;
SELECT * FROM fact_campaign_daily_performance WHERE is_campaign_date_valid = 0;
SELECT * FROM fact_campaign_hourly_performance WHERE is_campaign_date_valid = 0;
