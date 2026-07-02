-- Phase 5 anomaly detection validation checks.
-- SELECT queries only.

SELECT 'campaign_anomaly_detection' AS table_name, COUNT(*) AS row_count FROM campaign_anomaly_detection;

SELECT anomaly_count, COUNT(*) AS campaign_count
FROM campaign_anomaly_detection
GROUP BY anomaly_count
ORDER BY anomaly_count DESC;

SELECT * FROM campaign_anomaly_detection WHERE anomaly_count > 0;

SELECT
    SUM(high_spend_zero_conversion_flag) AS high_spend_zero_conversion_count,
    SUM(roas_below_target_flag) AS roas_below_target_count,
    SUM(cpa_above_target_flag) AS cpa_above_target_count,
    SUM(ctr_below_target_flag) AS ctr_below_target_count,
    SUM(budget_overspend_flag) AS budget_overspend_count,
    SUM(budget_underspend_flag) AS budget_underspend_count,
    SUM(spend_spike_flag) AS spend_spike_count,
    SUM(traffic_drop_flag) AS traffic_drop_count,
    SUM(conversion_drop_flag) AS conversion_drop_count,
    SUM(roas_drop_flag) AS roas_drop_count,
    SUM(no_impressions_active_campaign_flag) AS no_impressions_active_campaign_count,
    SUM(poor_efficiency_flag) AS poor_efficiency_count
FROM campaign_anomaly_detection;

SELECT * FROM campaign_anomaly_detection WHERE critical_anomaly_count > 0;
SELECT * FROM campaign_anomaly_detection WHERE high_anomaly_count > 0;
SELECT * FROM campaign_anomaly_detection WHERE anomaly_count = 0;

SELECT *
FROM campaign_anomaly_detection
WHERE high_spend_zero_conversion_flag IS NULL
   OR roas_below_target_flag IS NULL
   OR cpa_above_target_flag IS NULL
   OR ctr_below_target_flag IS NULL
   OR budget_overspend_flag IS NULL
   OR budget_underspend_flag IS NULL
   OR spend_spike_flag IS NULL
   OR traffic_drop_flag IS NULL
   OR conversion_drop_flag IS NULL
   OR roas_drop_flag IS NULL
   OR no_impressions_active_campaign_flag IS NULL
   OR poor_efficiency_flag IS NULL;

SELECT *
FROM campaign_anomaly_detection
ORDER BY anomaly_count DESC, critical_anomaly_count DESC, total_spend DESC
LIMIT 10;
