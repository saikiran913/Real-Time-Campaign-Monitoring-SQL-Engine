-- Scenario 04: CTR below target or traffic drop.

SELECT
    a.campaign_id,
    a.campaign_name,
    a.platform_name,
    a.country,
    a.overall_ctr,
    a.target_ctr,
    a.total_impressions,
    a.total_clicks,
    a.traffic_trend_status,
    h.final_health_score,
    h.health_status,
    h.recommended_action
FROM campaign_anomaly_detection a
LEFT JOIN campaign_health_score h
    ON a.campaign_id = h.campaign_id
WHERE a.ctr_below_target_flag = 1
   OR a.traffic_trend_status = 'Traffic Drop'
ORDER BY h.final_health_score ASC, a.total_impressions DESC;
