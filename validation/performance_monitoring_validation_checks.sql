-- Phase 4 performance monitoring validation checks.
-- SELECT queries only. These checks report possible issues and do not modify data.

SELECT 'campaign_daily_performance_monitoring' AS table_name, COUNT(*) AS row_count FROM campaign_daily_performance_monitoring;
SELECT 'campaign_performance_monitoring_summary' AS table_name, COUNT(*) AS row_count FROM campaign_performance_monitoring_summary;
SELECT 'campaign_monitoring_dashboard_summary' AS table_name, COUNT(*) AS row_count FROM campaign_monitoring_dashboard_summary;

-- Campaigns missing performance monitoring records.
SELECT k.campaign_id, k.campaign_name
FROM campaign_kpi_summary k
LEFT JOIN campaign_performance_monitoring_summary p
    ON k.campaign_id = p.campaign_id
WHERE p.campaign_id IS NULL;

-- Rows with NULL trend statuses.
SELECT *
FROM campaign_daily_performance_monitoring
WHERE traffic_trend_status IS NULL
   OR conversion_trend_status IS NULL
   OR spend_trend_status IS NULL
   OR roas_trend_status IS NULL
   OR overall_performance_watch_status IS NULL;

SELECT traffic_trend_status, COUNT(*) AS row_count
FROM campaign_daily_performance_monitoring
GROUP BY traffic_trend_status
ORDER BY row_count DESC;

SELECT conversion_trend_status, COUNT(*) AS row_count
FROM campaign_daily_performance_monitoring
GROUP BY conversion_trend_status
ORDER BY row_count DESC;

SELECT spend_trend_status, COUNT(*) AS row_count
FROM campaign_daily_performance_monitoring
GROUP BY spend_trend_status
ORDER BY row_count DESC;

SELECT roas_trend_status, COUNT(*) AS row_count
FROM campaign_daily_performance_monitoring
GROUP BY roas_trend_status
ORDER BY row_count DESC;

SELECT overall_performance_watch_status, COUNT(*) AS row_count
FROM campaign_daily_performance_monitoring
GROUP BY overall_performance_watch_status
ORDER BY row_count DESC;

SELECT *
FROM campaign_monitoring_dashboard_summary
ORDER BY total_spend DESC;
