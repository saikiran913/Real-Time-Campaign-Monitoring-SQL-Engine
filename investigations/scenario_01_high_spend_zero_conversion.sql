-- Scenario 01: High spend with zero conversions.

SELECT
    a.campaign_id,
    a.campaign_name,
    a.platform_name,
    a.country,
    a.campaign_status,
    a.total_spend,
    a.total_conversions,
    a.total_revenue,
    h.final_health_score,
    s.alert_severity,
    s.alert_message,
    s.recommended_action
FROM campaign_anomaly_detection a
LEFT JOIN campaign_health_score h
    ON a.campaign_id = h.campaign_id
LEFT JOIN campaign_alert_summary s
    ON a.campaign_id = s.campaign_id
WHERE a.high_spend_zero_conversion_flag = 1
ORDER BY a.total_spend DESC;
