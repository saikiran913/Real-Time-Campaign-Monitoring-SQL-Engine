-- Scenario 03: Budget overspend.

SELECT
    a.campaign_id,
    a.campaign_name,
    a.platform_name,
    a.country,
    a.total_budget,
    a.actual_spend_to_date,
    a.projected_total_spend,
    a.budget_utilization_percentage,
    a.pacing_ratio,
    a.budget_pacing_status,
    h.final_health_score,
    h.health_status,
    h.recommended_action
FROM campaign_anomaly_detection a
LEFT JOIN campaign_health_score h
    ON a.campaign_id = h.campaign_id
WHERE a.budget_overspend_flag = 1
   OR a.budget_pacing_status IN ('Overspending', 'Critical Overspend')
ORDER BY a.pacing_ratio DESC, a.actual_spend_to_date DESC;
