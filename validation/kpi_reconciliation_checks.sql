-- Phase 3 KPI reconciliation checks.
-- Each query returns source total, target total, difference, and pass/fail status.

SELECT
    'daily impressions: staging vs fact' AS check_name,
    (SELECT SUM(impressions) FROM stg_campaign_daily_metrics) AS source_total,
    (SELECT SUM(impressions) FROM fact_campaign_daily_performance) AS target_total,
    (SELECT SUM(impressions) FROM stg_campaign_daily_metrics) - (SELECT SUM(impressions) FROM fact_campaign_daily_performance) AS difference,
    CASE
        WHEN (SELECT SUM(impressions) FROM stg_campaign_daily_metrics) = (SELECT SUM(impressions) FROM fact_campaign_daily_performance) THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'daily clicks: staging vs fact' AS check_name,
    (SELECT SUM(clicks) FROM stg_campaign_daily_metrics) AS source_total,
    (SELECT SUM(clicks) FROM fact_campaign_daily_performance) AS target_total,
    (SELECT SUM(clicks) FROM stg_campaign_daily_metrics) - (SELECT SUM(clicks) FROM fact_campaign_daily_performance) AS difference,
    CASE
        WHEN (SELECT SUM(clicks) FROM stg_campaign_daily_metrics) = (SELECT SUM(clicks) FROM fact_campaign_daily_performance) THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'daily spend: staging vs fact' AS check_name,
    ROUND((SELECT SUM(spend) FROM stg_campaign_daily_metrics), 2) AS source_total,
    ROUND((SELECT SUM(spend) FROM fact_campaign_daily_performance), 2) AS target_total,
    ROUND((SELECT SUM(spend) FROM stg_campaign_daily_metrics) - (SELECT SUM(spend) FROM fact_campaign_daily_performance), 2) AS difference,
    CASE
        WHEN ROUND((SELECT SUM(spend) FROM stg_campaign_daily_metrics) - (SELECT SUM(spend) FROM fact_campaign_daily_performance), 2) = 0 THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'daily conversions: staging vs fact' AS check_name,
    (SELECT SUM(conversions) FROM stg_campaign_daily_metrics) AS source_total,
    (SELECT SUM(conversions) FROM fact_campaign_daily_performance) AS target_total,
    (SELECT SUM(conversions) FROM stg_campaign_daily_metrics) - (SELECT SUM(conversions) FROM fact_campaign_daily_performance) AS difference,
    CASE
        WHEN (SELECT SUM(conversions) FROM stg_campaign_daily_metrics) = (SELECT SUM(conversions) FROM fact_campaign_daily_performance) THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'daily revenue: staging vs fact' AS check_name,
    ROUND((SELECT SUM(revenue) FROM stg_campaign_daily_metrics), 2) AS source_total,
    ROUND((SELECT SUM(revenue) FROM fact_campaign_daily_performance), 2) AS target_total,
    ROUND((SELECT SUM(revenue) FROM stg_campaign_daily_metrics) - (SELECT SUM(revenue) FROM fact_campaign_daily_performance), 2) AS difference,
    CASE
        WHEN ROUND((SELECT SUM(revenue) FROM stg_campaign_daily_metrics) - (SELECT SUM(revenue) FROM fact_campaign_daily_performance), 2) = 0 THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'spend: fact vs campaign summary' AS check_name,
    ROUND((SELECT SUM(spend) FROM fact_campaign_daily_performance), 2) AS source_total,
    ROUND((SELECT SUM(total_spend) FROM campaign_kpi_summary), 2) AS target_total,
    ROUND((SELECT SUM(spend) FROM fact_campaign_daily_performance) - (SELECT SUM(total_spend) FROM campaign_kpi_summary), 2) AS difference,
    CASE
        WHEN ROUND((SELECT SUM(spend) FROM fact_campaign_daily_performance) - (SELECT SUM(total_spend) FROM campaign_kpi_summary), 2) = 0 THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'revenue: fact vs campaign summary' AS check_name,
    ROUND((SELECT SUM(revenue) FROM fact_campaign_daily_performance), 2) AS source_total,
    ROUND((SELECT SUM(total_revenue) FROM campaign_kpi_summary), 2) AS target_total,
    ROUND((SELECT SUM(revenue) FROM fact_campaign_daily_performance) - (SELECT SUM(total_revenue) FROM campaign_kpi_summary), 2) AS difference,
    CASE
        WHEN ROUND((SELECT SUM(revenue) FROM fact_campaign_daily_performance) - (SELECT SUM(total_revenue) FROM campaign_kpi_summary), 2) = 0 THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'impressions: fact vs platform summary' AS check_name,
    (SELECT SUM(impressions) FROM fact_campaign_daily_performance) AS source_total,
    (SELECT SUM(total_impressions) FROM platform_kpi_summary) AS target_total,
    (SELECT SUM(impressions) FROM fact_campaign_daily_performance) - (SELECT SUM(total_impressions) FROM platform_kpi_summary) AS difference,
    CASE
        WHEN (SELECT SUM(impressions) FROM fact_campaign_daily_performance) = (SELECT SUM(total_impressions) FROM platform_kpi_summary) THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;

SELECT
    'impressions: fact vs region summary' AS check_name,
    (SELECT SUM(impressions) FROM fact_campaign_daily_performance) AS source_total,
    (SELECT SUM(total_impressions) FROM region_kpi_summary) AS target_total,
    (SELECT SUM(impressions) FROM fact_campaign_daily_performance) - (SELECT SUM(total_impressions) FROM region_kpi_summary) AS difference,
    CASE
        WHEN (SELECT SUM(impressions) FROM fact_campaign_daily_performance) = (SELECT SUM(total_impressions) FROM region_kpi_summary) THEN 'Pass'
        ELSE 'Fail'
    END AS reconciliation_status;
