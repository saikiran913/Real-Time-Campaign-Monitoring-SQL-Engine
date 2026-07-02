-- Scenario 02: ROAS drop or ROAS below target.

SELECT
    a.campaign_id,
    a.campaign_name,
    a.platform_name,
    a.country,
    a.overall_roas,
    a.target_roas,
    a.roas_trend_status,
    a.roas_drop_flag,
    a.roas_below_target_flag,
    h.final_health_score,
    h.health_status,
    h.recommended_action
FROM campaign_anomaly_detection a
LEFT JOIN campaign_health_score h
    ON a.campaign_id = h.campaign_id
WHERE a.roas_drop_flag = 1
   OR a.roas_below_target_flag = 1
ORDER BY h.final_health_score ASC, a.total_spend DESC;
