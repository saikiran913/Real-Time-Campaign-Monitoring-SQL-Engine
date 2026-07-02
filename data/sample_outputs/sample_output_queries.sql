-- Sample output queries for GitHub review and portfolio demos.
-- Run after the full SQL pipeline has completed through sql/07.

-- 1. Campaign KPI summary sample.
SELECT * FROM campaign_kpi_summary ORDER BY total_spend DESC LIMIT 10;

-- 2. Platform KPI summary sample.
SELECT * FROM platform_kpi_summary ORDER BY total_spend DESC;

-- 3. Region KPI summary sample.
SELECT * FROM region_kpi_summary ORDER BY total_spend DESC;

-- 4. Budget pacing summary sample.
SELECT * FROM campaign_budget_pacing_summary ORDER BY budget_utilization_percentage DESC LIMIT 10;

-- 5. Campaign monitoring dashboard sample.
SELECT * FROM campaign_monitoring_dashboard_summary ORDER BY total_spend DESC LIMIT 10;

-- 6. Alert summary sample.
SELECT * FROM campaign_alert_summary WHERE alert_required = 1 ORDER BY alert_severity, total_spend DESC;

-- 7. Campaign health score sample.
SELECT * FROM campaign_health_score ORDER BY final_health_score ASC, total_spend DESC LIMIT 10;

-- 8. Critical campaign summary sample.
SELECT * FROM critical_campaign_summary;

-- 9. Investigation scenario sample.
SELECT * FROM campaign_anomaly_detection
WHERE high_spend_zero_conversion_flag = 1
   OR budget_overspend_flag = 1
   OR roas_below_target_flag = 1
ORDER BY anomaly_count DESC, total_spend DESC;

-- 10. Executive-style final summary.
SELECT
    COUNT(*) AS campaign_count,
    SUM(CASE WHEN alert_required = 1 THEN 1 ELSE 0 END) AS campaigns_with_alerts,
    ROUND(AVG(final_health_score), 2) AS average_health_score,
    ROUND(SUM(total_spend), 2) AS total_spend,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(CASE WHEN SUM(total_spend) = 0 THEN 0 ELSE SUM(total_revenue) / SUM(total_spend) END, 4) AS overall_roas
FROM campaign_health_score;
