-- Phase 5 alert validation checks.
-- SELECT queries only.

SELECT 'campaign_alert_summary' AS table_name, COUNT(*) AS row_count FROM campaign_alert_summary;

SELECT alert_required, COUNT(*) AS campaign_count
FROM campaign_alert_summary
GROUP BY alert_required;

SELECT alert_severity, COUNT(*) AS campaign_count
FROM campaign_alert_summary
GROUP BY alert_severity
ORDER BY campaign_count DESC;

SELECT primary_alert_category, COUNT(*) AS campaign_count
FROM campaign_alert_summary
GROUP BY primary_alert_category
ORDER BY campaign_count DESC;

SELECT * FROM campaign_alert_summary WHERE alert_required = 1;
SELECT * FROM campaign_alert_summary WHERE alert_severity = 'Critical';
SELECT * FROM campaign_alert_summary WHERE alert_severity = 'High';

SELECT * FROM campaign_alert_summary
WHERE alert_message IS NULL OR TRIM(alert_message) = '';

SELECT * FROM campaign_alert_summary
WHERE recommended_action IS NULL OR TRIM(recommended_action) = '';

SELECT rule_mapping_status, COUNT(*) AS mapping_count
FROM campaign_alert_rule_mapping
GROUP BY rule_mapping_status;
