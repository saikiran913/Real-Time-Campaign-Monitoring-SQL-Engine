-- Phase 4 budget pacing validation checks.
-- SELECT queries only. These checks report possible issues and do not modify data.

SELECT 'campaign_budget_pacing_daily' AS table_name, COUNT(*) AS row_count FROM campaign_budget_pacing_daily;
SELECT 'campaign_budget_pacing_summary' AS table_name, COUNT(*) AS row_count FROM campaign_budget_pacing_summary;

-- Campaigns missing budget records.
SELECT k.campaign_id, k.campaign_name
FROM campaign_kpi_summary k
LEFT JOIN stg_budget_allocations b
    ON k.campaign_id = b.campaign_id
WHERE b.campaign_id IS NULL;

SELECT * FROM campaign_budget_pacing_daily WHERE total_budget < 0;
SELECT * FROM campaign_budget_pacing_daily WHERE daily_budget < 0;
SELECT * FROM campaign_budget_pacing_daily WHERE remaining_budget < 0;
SELECT * FROM campaign_budget_pacing_daily WHERE budget_utilization_percentage > 1;
SELECT * FROM campaign_budget_pacing_daily WHERE projected_total_spend < 0;
SELECT * FROM campaign_budget_pacing_daily WHERE pacing_ratio < 0;
SELECT * FROM campaign_budget_pacing_daily WHERE total_budget = 0;

SELECT budget_pacing_status, COUNT(*) AS row_count
FROM campaign_budget_pacing_daily
GROUP BY budget_pacing_status
ORDER BY row_count DESC;

SELECT budget_risk_level, COUNT(*) AS row_count
FROM campaign_budget_pacing_daily
GROUP BY budget_risk_level
ORDER BY row_count DESC;
