-- Phase 5 health score validation checks.
-- SELECT queries only.

SELECT 'campaign_health_score' AS table_name, COUNT(*) AS row_count FROM campaign_health_score;

SELECT health_status, COUNT(*) AS campaign_count
FROM campaign_health_score
GROUP BY health_status
ORDER BY campaign_count DESC;

SELECT * FROM campaign_health_score WHERE final_health_score < 0;
SELECT * FROM campaign_health_score WHERE final_health_score > 100;
SELECT * FROM campaign_health_score WHERE final_health_score IS NULL;
SELECT * FROM campaign_health_score WHERE health_status = 'Critical';
SELECT * FROM campaign_health_score WHERE health_status = 'At Risk';

SELECT 'critical_campaign_summary' AS table_name, COUNT(*) AS row_count FROM critical_campaign_summary;

SELECT *
FROM campaign_health_score
ORDER BY final_health_score ASC, total_spend DESC
LIMIT 10;

SELECT platform_name, ROUND(AVG(final_health_score), 2) AS average_health_score
FROM campaign_health_score
GROUP BY platform_name
ORDER BY average_health_score ASC;

SELECT country, region_name, ROUND(AVG(final_health_score), 2) AS average_health_score
FROM campaign_health_score
GROUP BY country, region_name
ORDER BY average_health_score ASC;
