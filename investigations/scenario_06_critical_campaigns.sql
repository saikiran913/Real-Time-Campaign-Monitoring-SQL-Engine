-- Scenario 06: Critical and at-risk campaigns.

SELECT *
FROM critical_campaign_summary
ORDER BY
    CASE WHEN health_status = 'Critical' THEN 1 ELSE 2 END,
    CASE WHEN alert_severity = 'Critical' THEN 1 ELSE 2 END,
    final_health_score ASC,
    total_spend DESC;
