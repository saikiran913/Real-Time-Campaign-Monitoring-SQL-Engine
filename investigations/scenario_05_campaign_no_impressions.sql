-- Scenario 05: Active campaign with no impressions.

SELECT
    a.campaign_id,
    a.campaign_name,
    a.platform_name,
    a.country,
    a.campaign_status,
    a.total_impressions,
    a.total_spend,
    s.alert_message,
    h.final_health_score,
    h.health_status,
    h.recommended_action
FROM campaign_anomaly_detection a
LEFT JOIN campaign_alert_summary s
    ON a.campaign_id = s.campaign_id
LEFT JOIN campaign_health_score h
    ON a.campaign_id = h.campaign_id
WHERE a.no_impressions_active_campaign_flag = 1
   OR (a.campaign_status = 'Active' AND a.total_impressions = 0)
ORDER BY h.final_health_score ASC, a.total_spend DESC;
