-- Phase 6: Final project validation.
-- SELECT queries only. Run after sql/01 through sql/07 have completed.

-- 1. Table existence summary.
WITH expected_tables(table_name) AS (
    VALUES
        ('raw_campaigns'),
        ('raw_ad_platforms'),
        ('raw_regions'),
        ('raw_calendar'),
        ('raw_campaign_daily_metrics'),
        ('raw_campaign_hourly_metrics'),
        ('raw_budget_allocations'),
        ('raw_campaign_targets'),
        ('raw_campaign_alert_rules'),
        ('stg_campaigns'),
        ('stg_campaign_daily_metrics'),
        ('stg_campaign_hourly_metrics'),
        ('fact_campaign_daily_performance'),
        ('fact_campaign_hourly_performance'),
        ('campaign_kpi_summary'),
        ('platform_kpi_summary'),
        ('region_kpi_summary'),
        ('campaign_budget_pacing_summary'),
        ('campaign_performance_monitoring_summary'),
        ('campaign_monitoring_dashboard_summary'),
        ('campaign_anomaly_detection'),
        ('campaign_alert_summary'),
        ('campaign_health_score'),
        ('critical_campaign_summary'),
        ('campaign_alert_rule_mapping')
)
SELECT
    e.table_name,
    CASE WHEN s.name IS NULL THEN 'Missing' ELSE 'Exists' END AS table_status
FROM expected_tables e
LEFT JOIN sqlite_master s
    ON s.type = 'table'
   AND s.name = e.table_name
ORDER BY e.table_name;

-- 2. Row count summary.
SELECT 'raw_campaigns' AS table_name, COUNT(*) AS row_count FROM raw_campaigns;
SELECT 'stg_campaigns' AS table_name, COUNT(*) AS row_count FROM stg_campaigns;
SELECT 'fact_campaign_daily_performance' AS table_name, COUNT(*) AS row_count FROM fact_campaign_daily_performance;
SELECT 'fact_campaign_hourly_performance' AS table_name, COUNT(*) AS row_count FROM fact_campaign_hourly_performance;
SELECT 'campaign_kpi_summary' AS table_name, COUNT(*) AS row_count FROM campaign_kpi_summary;
SELECT 'campaign_budget_pacing_summary' AS table_name, COUNT(*) AS row_count FROM campaign_budget_pacing_summary;
SELECT 'campaign_performance_monitoring_summary' AS table_name, COUNT(*) AS row_count FROM campaign_performance_monitoring_summary;
SELECT 'campaign_monitoring_dashboard_summary' AS table_name, COUNT(*) AS row_count FROM campaign_monitoring_dashboard_summary;
SELECT 'campaign_anomaly_detection' AS table_name, COUNT(*) AS row_count FROM campaign_anomaly_detection;
SELECT 'campaign_alert_summary' AS table_name, COUNT(*) AS row_count FROM campaign_alert_summary;
SELECT 'campaign_health_score' AS table_name, COUNT(*) AS row_count FROM campaign_health_score;
SELECT 'critical_campaign_summary' AS table_name, COUNT(*) AS row_count FROM critical_campaign_summary;
SELECT 'campaign_alert_rule_mapping' AS table_name, COUNT(*) AS row_count FROM campaign_alert_rule_mapping;

-- 3. Final data flow checks.
SELECT 'raw daily to staging daily' AS check_name, (SELECT COUNT(*) FROM raw_campaign_daily_metrics) AS source_count, (SELECT COUNT(*) FROM stg_campaign_daily_metrics) AS target_count, (SELECT COUNT(*) FROM raw_campaign_daily_metrics) - (SELECT COUNT(*) FROM stg_campaign_daily_metrics) AS difference, CASE WHEN (SELECT COUNT(*) FROM raw_campaign_daily_metrics) = (SELECT COUNT(*) FROM stg_campaign_daily_metrics) THEN 'Pass' ELSE 'Fail' END AS status;
SELECT 'staging daily to daily fact' AS check_name, (SELECT COUNT(*) FROM stg_campaign_daily_metrics) AS source_count, (SELECT COUNT(*) FROM fact_campaign_daily_performance) AS target_count, (SELECT COUNT(*) FROM stg_campaign_daily_metrics) - (SELECT COUNT(*) FROM fact_campaign_daily_performance) AS difference, CASE WHEN (SELECT COUNT(*) FROM stg_campaign_daily_metrics) = (SELECT COUNT(*) FROM fact_campaign_daily_performance) THEN 'Pass' ELSE 'Fail' END AS status;
SELECT 'kpi summary to health score' AS check_name, (SELECT COUNT(*) FROM campaign_kpi_summary) AS source_count, (SELECT COUNT(*) FROM campaign_health_score) AS target_count, (SELECT COUNT(*) FROM campaign_kpi_summary) - (SELECT COUNT(*) FROM campaign_health_score) AS difference, CASE WHEN (SELECT COUNT(*) FROM campaign_kpi_summary) = (SELECT COUNT(*) FROM campaign_health_score) THEN 'Pass' ELSE 'Fail' END AS status;
SELECT 'kpi summary to alert summary' AS check_name, (SELECT COUNT(*) FROM campaign_kpi_summary) AS source_count, (SELECT COUNT(*) FROM campaign_alert_summary) AS target_count, (SELECT COUNT(*) FROM campaign_kpi_summary) - (SELECT COUNT(*) FROM campaign_alert_summary) AS difference, CASE WHEN (SELECT COUNT(*) FROM campaign_kpi_summary) = (SELECT COUNT(*) FROM campaign_alert_summary) THEN 'Pass' ELSE 'Fail' END AS status;

-- 4. Final metric reconciliation.
SELECT 'impressions' AS metric_name, SUM(s.impressions) AS staging_total, SUM(f.impressions) AS fact_total, SUM(s.impressions) - SUM(f.impressions) AS difference, CASE WHEN SUM(s.impressions) = SUM(f.impressions) THEN 'Pass' ELSE 'Fail' END AS status FROM stg_campaign_daily_metrics s JOIN fact_campaign_daily_performance f ON s.campaign_id = f.campaign_id AND s.metric_date = f.metric_date;
SELECT 'clicks' AS metric_name, SUM(s.clicks) AS staging_total, SUM(f.clicks) AS fact_total, SUM(s.clicks) - SUM(f.clicks) AS difference, CASE WHEN SUM(s.clicks) = SUM(f.clicks) THEN 'Pass' ELSE 'Fail' END AS status FROM stg_campaign_daily_metrics s JOIN fact_campaign_daily_performance f ON s.campaign_id = f.campaign_id AND s.metric_date = f.metric_date;
SELECT 'spend' AS metric_name, ROUND(SUM(s.spend), 2) AS staging_total, ROUND(SUM(f.spend), 2) AS fact_total, ROUND(SUM(s.spend) - SUM(f.spend), 2) AS difference, CASE WHEN ROUND(SUM(s.spend) - SUM(f.spend), 2) = 0 THEN 'Pass' ELSE 'Fail' END AS status FROM stg_campaign_daily_metrics s JOIN fact_campaign_daily_performance f ON s.campaign_id = f.campaign_id AND s.metric_date = f.metric_date;
SELECT 'conversions' AS metric_name, SUM(s.conversions) AS staging_total, SUM(f.conversions) AS fact_total, SUM(s.conversions) - SUM(f.conversions) AS difference, CASE WHEN SUM(s.conversions) = SUM(f.conversions) THEN 'Pass' ELSE 'Fail' END AS status FROM stg_campaign_daily_metrics s JOIN fact_campaign_daily_performance f ON s.campaign_id = f.campaign_id AND s.metric_date = f.metric_date;
SELECT 'revenue' AS metric_name, ROUND(SUM(s.revenue), 2) AS staging_total, ROUND(SUM(f.revenue), 2) AS fact_total, ROUND(SUM(s.revenue) - SUM(f.revenue), 2) AS difference, CASE WHEN ROUND(SUM(s.revenue) - SUM(f.revenue), 2) = 0 THEN 'Pass' ELSE 'Fail' END AS status FROM stg_campaign_daily_metrics s JOIN fact_campaign_daily_performance f ON s.campaign_id = f.campaign_id AND s.metric_date = f.metric_date;

-- 5. Final business output summary.
SELECT
    (SELECT COUNT(*) FROM campaign_kpi_summary) AS number_of_campaigns,
    (SELECT COUNT(*) FROM campaign_alert_summary WHERE alert_required = 1) AS campaigns_with_alerts,
    (SELECT COUNT(*) FROM campaign_health_score WHERE health_status = 'Critical') AS critical_campaigns,
    (SELECT COUNT(*) FROM campaign_health_score WHERE health_status = 'At Risk') AS at_risk_campaigns,
    ROUND((SELECT AVG(final_health_score) FROM campaign_health_score), 2) AS average_health_score,
    ROUND((SELECT SUM(total_spend) FROM campaign_kpi_summary), 2) AS total_spend,
    ROUND((SELECT SUM(total_revenue) FROM campaign_kpi_summary), 2) AS total_revenue,
    ROUND(CASE WHEN (SELECT SUM(total_spend) FROM campaign_kpi_summary) = 0 THEN 0 ELSE (SELECT SUM(total_revenue) FROM campaign_kpi_summary) / (SELECT SUM(total_spend) FROM campaign_kpi_summary) END, 4) AS overall_roas;

-- 6. Final distributions.
SELECT alert_severity, COUNT(*) AS campaign_count FROM campaign_alert_summary GROUP BY alert_severity ORDER BY campaign_count DESC;
SELECT health_status, COUNT(*) AS campaign_count FROM campaign_health_score GROUP BY health_status ORDER BY campaign_count DESC;
SELECT budget_pacing_status, COUNT(*) AS campaign_count FROM campaign_budget_pacing_summary GROUP BY budget_pacing_status ORDER BY campaign_count DESC;
SELECT overall_performance_watch_status, COUNT(*) AS campaign_count FROM campaign_performance_monitoring_summary GROUP BY overall_performance_watch_status ORDER BY campaign_count DESC;

-- 7. Final top issue summary.
SELECT *
FROM campaign_health_score
ORDER BY final_health_score ASC, anomaly_count DESC, total_spend DESC
LIMIT 10;
