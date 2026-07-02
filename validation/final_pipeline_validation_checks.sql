-- Final pipeline validation checks.
-- SELECT queries only.

WITH expected_tables(table_name) AS (
    VALUES
        ('raw_campaigns'),
        ('stg_campaigns'),
        ('fact_campaign_daily_performance'),
        ('campaign_kpi_summary'),
        ('campaign_budget_pacing_summary'),
        ('campaign_monitoring_dashboard_summary'),
        ('campaign_anomaly_detection'),
        ('campaign_alert_summary'),
        ('campaign_health_score'),
        ('critical_campaign_summary'),
        ('campaign_alert_rule_mapping')
)
SELECT
    e.table_name AS expected_table,
    CASE WHEN s.name IS NULL THEN 'Missing' ELSE 'Exists' END AS status
FROM expected_tables e
LEFT JOIN sqlite_master s
    ON s.type = 'table'
   AND s.name = e.table_name
ORDER BY e.table_name;

SELECT 'campaign_kpi_summary' AS table_name, COUNT(*) AS row_count FROM campaign_kpi_summary;
SELECT 'campaign_monitoring_dashboard_summary' AS table_name, COUNT(*) AS row_count FROM campaign_monitoring_dashboard_summary;
SELECT 'campaign_anomaly_detection' AS table_name, COUNT(*) AS row_count FROM campaign_anomaly_detection;
SELECT 'campaign_alert_summary' AS table_name, COUNT(*) AS row_count FROM campaign_alert_summary;
SELECT 'campaign_health_score' AS table_name, COUNT(*) AS row_count FROM campaign_health_score;

SELECT * FROM campaign_anomaly_detection WHERE campaign_id IS NULL;
SELECT * FROM campaign_alert_summary WHERE campaign_id IS NULL;
SELECT * FROM campaign_health_score WHERE campaign_id IS NULL;

SELECT * FROM campaign_health_score WHERE final_health_score < 0 OR final_health_score > 100;
SELECT * FROM campaign_alert_summary WHERE alert_message IS NULL OR TRIM(alert_message) = '';
SELECT * FROM campaign_health_score WHERE recommended_action IS NULL OR TRIM(recommended_action) = '';

SELECT
    'critical count within health score count' AS check_name,
    (SELECT COUNT(*) FROM critical_campaign_summary) AS critical_count,
    (SELECT COUNT(*) FROM campaign_health_score) AS health_score_count,
    CASE WHEN (SELECT COUNT(*) FROM critical_campaign_summary) <= (SELECT COUNT(*) FROM campaign_health_score) THEN 'Pass' ELSE 'Fail' END AS status;

SELECT 'campaign_alert_rule_mapping' AS table_name, COUNT(*) AS row_count FROM campaign_alert_rule_mapping;

SELECT
    'dashboard one row per campaign where possible' AS check_name,
    COUNT(*) AS dashboard_rows,
    COUNT(DISTINCT campaign_id) AS distinct_campaigns,
    CASE WHEN COUNT(*) = COUNT(DISTINCT campaign_id) THEN 'Pass' ELSE 'Fail' END AS status
FROM campaign_monitoring_dashboard_summary;
