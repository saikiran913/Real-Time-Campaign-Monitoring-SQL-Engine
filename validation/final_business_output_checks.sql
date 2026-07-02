-- Final business output checks.
-- SELECT queries only.

SELECT * FROM campaign_kpi_summary ORDER BY total_spend DESC LIMIT 10;
SELECT * FROM campaign_kpi_summary ORDER BY total_revenue DESC LIMIT 10;
SELECT * FROM campaign_kpi_summary ORDER BY overall_roas DESC LIMIT 10;
SELECT * FROM campaign_health_score ORDER BY final_health_score ASC, total_spend DESC LIMIT 10;
SELECT * FROM campaign_alert_summary WHERE alert_required = 1 ORDER BY alert_severity, total_spend DESC;
SELECT * FROM critical_campaign_summary;

SELECT * FROM campaign_anomaly_detection
WHERE budget_overspend_flag = 1
ORDER BY actual_spend_to_date DESC;

SELECT * FROM campaign_anomaly_detection
WHERE high_spend_zero_conversion_flag = 1
ORDER BY total_spend DESC;

SELECT * FROM campaign_anomaly_detection
WHERE roas_below_target_flag = 1
ORDER BY overall_roas ASC;

SELECT platform_name, ROUND(AVG(final_health_score), 2) AS average_health_score
FROM campaign_health_score
GROUP BY platform_name
ORDER BY average_health_score ASC;

SELECT country, region_name, ROUND(AVG(final_health_score), 2) AS average_health_score
FROM campaign_health_score
GROUP BY country, region_name
ORDER BY average_health_score ASC;

SELECT platform_name, COUNT(*) AS alert_count
FROM campaign_alert_summary
WHERE alert_required = 1
GROUP BY platform_name
ORDER BY alert_count DESC;

SELECT country, region_name, COUNT(*) AS alert_count
FROM campaign_alert_summary
WHERE alert_required = 1
GROUP BY country, region_name
ORDER BY alert_count DESC;
