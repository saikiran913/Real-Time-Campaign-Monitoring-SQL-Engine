-- Phase 4: Budget pacing and performance monitoring.
-- Main performance source: Phase 3 KPI tables.
-- Budget source: Phase 2 staging budget and campaign tables.
-- This phase does not create final anomaly alerts or campaign health scores.

DROP TABLE IF EXISTS campaign_monitoring_dashboard_summary;
DROP TABLE IF EXISTS campaign_performance_monitoring_summary;
DROP TABLE IF EXISTS campaign_daily_performance_monitoring;
DROP TABLE IF EXISTS campaign_budget_pacing_summary;
DROP TABLE IF EXISTS campaign_budget_pacing_daily;

-- Daily budget pacing by campaign and metric date.
CREATE TABLE campaign_budget_pacing_daily AS
WITH base AS (
    SELECT
        f.metric_date,
        f.campaign_id,
        f.campaign_name,
        f.platform_name,
        f.platform_category,
        f.country,
        f.region_name,
        f.business_unit,
        f.campaign_type,
        f.campaign_objective,
        f.campaign_status,
        c.start_date,
        c.end_date,
        b.total_budget,
        b.daily_budget,
        b.budget_start_date,
        b.budget_end_date,
        c.campaign_duration_days,
        CASE
            WHEN b.budget_start_date IS NULL OR b.budget_end_date IS NULL THEN 0
            WHEN date(b.budget_start_date) > date(b.budget_end_date) THEN 0
            ELSE CAST(julianday(b.budget_end_date) - julianday(b.budget_start_date) + 1 AS INTEGER)
        END AS budget_duration_days,
        CASE
            WHEN c.start_date IS NULL OR date(f.metric_date) < date(c.start_date) THEN 0
            ELSE CAST(julianday(f.metric_date) - julianday(c.start_date) + 1 AS INTEGER)
        END AS campaign_day_number,
        CASE
            WHEN b.budget_start_date IS NULL OR date(f.metric_date) < date(b.budget_start_date) THEN 0
            WHEN b.budget_end_date IS NOT NULL AND date(f.metric_date) > date(b.budget_end_date)
                THEN CAST(julianday(b.budget_end_date) - julianday(b.budget_start_date) + 1 AS INTEGER)
            ELSE CAST(julianday(f.metric_date) - julianday(b.budget_start_date) + 1 AS INTEGER)
        END AS budget_day_number,
        f.impressions AS total_impressions,
        f.clicks AS total_clicks,
        f.spend AS daily_spend,
        f.conversions AS daily_conversions,
        f.revenue AS daily_revenue
    FROM fact_campaign_daily_performance f
    LEFT JOIN stg_budget_allocations b
        ON f.campaign_id = b.campaign_id
    LEFT JOIN stg_campaigns c
        ON f.campaign_id = c.campaign_id
),
cumulative AS (
    SELECT
        *,
        ROUND(SUM(daily_spend) OVER (
            PARTITION BY campaign_id
            ORDER BY metric_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2) AS actual_spend_to_date
    FROM base
),
calculations AS (
    SELECT
        *,
        ROUND(COALESCE(daily_budget, 0) * budget_day_number, 2) AS expected_spend_to_date,
        ROUND(COALESCE(total_budget, 0) - actual_spend_to_date, 2) AS remaining_budget
    FROM cumulative
),
pacing AS (
    SELECT
        *,
        ROUND(actual_spend_to_date - expected_spend_to_date, 2) AS spend_variance_amount,
        ROUND(CASE WHEN expected_spend_to_date = 0 THEN 0 ELSE (actual_spend_to_date - expected_spend_to_date) / expected_spend_to_date END, 4) AS spend_variance_percentage,
        ROUND(CASE WHEN expected_spend_to_date = 0 THEN 0 ELSE actual_spend_to_date / expected_spend_to_date END, 4) AS pacing_ratio,
        ROUND(CASE WHEN budget_day_number = 0 THEN 0 ELSE actual_spend_to_date / budget_day_number * budget_duration_days END, 2) AS projected_total_spend,
        ROUND(CASE WHEN total_budget IS NULL OR total_budget = 0 THEN 0 ELSE actual_spend_to_date / total_budget END, 4) AS budget_utilization_percentage
    FROM calculations
),
status_calc AS (
    SELECT
        *,
        ROUND(projected_total_spend - COALESCE(total_budget, 0), 2) AS projected_budget_variance,
        CASE
            WHEN total_budget IS NULL OR total_budget = 0 THEN 'No Budget'
            WHEN actual_spend_to_date = 0 THEN 'No Spend Yet'
            WHEN pacing_ratio >= 1.30 THEN 'Critical Overspend'
            WHEN pacing_ratio >= 1.10 AND pacing_ratio < 1.30 THEN 'Overspending'
            WHEN pacing_ratio >= 0.90 AND pacing_ratio < 1.10 THEN 'On Track'
            WHEN pacing_ratio >= 0.60 AND pacing_ratio < 0.90 THEN 'Underspending'
            WHEN pacing_ratio < 0.60 THEN 'Critical Underspend'
            ELSE 'Unknown'
        END AS budget_pacing_status
    FROM pacing
)
SELECT
    metric_date,
    campaign_id,
    campaign_name,
    platform_name,
    platform_category,
    country,
    region_name,
    business_unit,
    campaign_type,
    campaign_objective,
    campaign_status,
    start_date,
    end_date,
    total_budget,
    daily_budget,
    budget_start_date,
    budget_end_date,
    campaign_duration_days,
    budget_duration_days,
    campaign_day_number,
    budget_day_number,
    total_impressions,
    total_clicks,
    daily_spend,
    daily_conversions,
    daily_revenue,
    actual_spend_to_date,
    expected_spend_to_date,
    remaining_budget,
    spend_variance_amount,
    spend_variance_percentage,
    pacing_ratio,
    projected_total_spend,
    projected_budget_variance,
    budget_utilization_percentage,
    budget_pacing_status,
    CASE
        WHEN budget_pacing_status IN ('Critical Overspend', 'Critical Underspend') THEN 'Critical'
        WHEN budget_pacing_status IN ('Overspending', 'Underspending') THEN 'High'
        WHEN budget_pacing_status = 'On Track' THEN 'Low'
        WHEN budget_pacing_status = 'No Spend Yet' THEN 'Medium'
        ELSE 'Unknown'
    END AS budget_risk_level
FROM status_calc;

-- Latest budget pacing row per campaign.
CREATE TABLE campaign_budget_pacing_summary AS
WITH latest AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY campaign_id ORDER BY metric_date DESC) AS row_number
    FROM campaign_budget_pacing_daily
)
SELECT
    campaign_id,
    campaign_name,
    platform_name,
    platform_category,
    country,
    region_name,
    business_unit,
    campaign_type,
    campaign_objective,
    campaign_status,
    metric_date AS latest_metric_date,
    total_budget,
    daily_budget,
    actual_spend_to_date,
    expected_spend_to_date,
    remaining_budget,
    spend_variance_amount,
    spend_variance_percentage,
    pacing_ratio,
    projected_total_spend,
    projected_budget_variance,
    budget_utilization_percentage,
    budget_pacing_status,
    budget_risk_level
FROM latest
WHERE row_number = 1;

-- Daily performance monitoring with previous-day and 7-day comparisons.
CREATE TABLE campaign_daily_performance_monitoring AS
WITH windowed AS (
    SELECT
        f.*,
        LAG(impressions) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_impressions,
        LAG(clicks) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_clicks,
        LAG(spend) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_spend,
        LAG(conversions) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_conversions,
        LAG(revenue) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_revenue,
        LAG(ctr) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_ctr,
        LAG(cpc) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_cpc,
        LAG(cpa) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_cpa,
        LAG(roas) OVER (PARTITION BY campaign_id ORDER BY metric_date) AS previous_day_roas,
        AVG(impressions) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_impressions,
        AVG(clicks) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_clicks,
        AVG(spend) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_spend,
        AVG(conversions) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_conversions,
        AVG(revenue) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_revenue,
        AVG(ctr) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_ctr,
        AVG(cpc) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_cpc,
        AVG(cpa) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_cpa,
        AVG(roas) OVER (PARTITION BY campaign_id ORDER BY metric_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d_roas
    FROM fact_campaign_daily_performance f
),
changes AS (
    SELECT
        *,
        ROUND(CASE WHEN previous_day_impressions IS NULL OR previous_day_impressions = 0 THEN 0 ELSE (impressions - previous_day_impressions) * 1.0 / previous_day_impressions END, 4) AS impressions_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_clicks IS NULL OR previous_day_clicks = 0 THEN 0 ELSE (clicks - previous_day_clicks) * 1.0 / previous_day_clicks END, 4) AS clicks_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_spend IS NULL OR previous_day_spend = 0 THEN 0 ELSE (spend - previous_day_spend) * 1.0 / previous_day_spend END, 4) AS spend_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_conversions IS NULL OR previous_day_conversions = 0 THEN 0 ELSE (conversions - previous_day_conversions) * 1.0 / previous_day_conversions END, 4) AS conversions_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_revenue IS NULL OR previous_day_revenue = 0 THEN 0 ELSE (revenue - previous_day_revenue) * 1.0 / previous_day_revenue END, 4) AS revenue_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_ctr IS NULL OR previous_day_ctr = 0 THEN 0 ELSE (ctr - previous_day_ctr) * 1.0 / previous_day_ctr END, 4) AS ctr_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_cpc IS NULL OR previous_day_cpc = 0 THEN 0 ELSE (cpc - previous_day_cpc) * 1.0 / previous_day_cpc END, 4) AS cpc_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_cpa IS NULL OR previous_day_cpa = 0 THEN 0 ELSE (cpa - previous_day_cpa) * 1.0 / previous_day_cpa END, 4) AS cpa_day_over_day_change_pct,
        ROUND(CASE WHEN previous_day_roas IS NULL OR previous_day_roas = 0 THEN 0 ELSE (roas - previous_day_roas) * 1.0 / previous_day_roas END, 4) AS roas_day_over_day_change_pct,
        ROUND(CASE WHEN avg_7d_impressions IS NULL OR avg_7d_impressions = 0 THEN 0 ELSE (impressions - avg_7d_impressions) * 1.0 / avg_7d_impressions END, 4) AS impressions_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_clicks IS NULL OR avg_7d_clicks = 0 THEN 0 ELSE (clicks - avg_7d_clicks) * 1.0 / avg_7d_clicks END, 4) AS clicks_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_spend IS NULL OR avg_7d_spend = 0 THEN 0 ELSE (spend - avg_7d_spend) * 1.0 / avg_7d_spend END, 4) AS spend_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_conversions IS NULL OR avg_7d_conversions = 0 THEN 0 ELSE (conversions - avg_7d_conversions) * 1.0 / avg_7d_conversions END, 4) AS conversions_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_revenue IS NULL OR avg_7d_revenue = 0 THEN 0 ELSE (revenue - avg_7d_revenue) * 1.0 / avg_7d_revenue END, 4) AS revenue_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_ctr IS NULL OR avg_7d_ctr = 0 THEN 0 ELSE (ctr - avg_7d_ctr) * 1.0 / avg_7d_ctr END, 4) AS ctr_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_cpc IS NULL OR avg_7d_cpc = 0 THEN 0 ELSE (cpc - avg_7d_cpc) * 1.0 / avg_7d_cpc END, 4) AS cpc_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_cpa IS NULL OR avg_7d_cpa = 0 THEN 0 ELSE (cpa - avg_7d_cpa) * 1.0 / avg_7d_cpa END, 4) AS cpa_vs_7d_avg_pct,
        ROUND(CASE WHEN avg_7d_roas IS NULL OR avg_7d_roas = 0 THEN 0 ELSE (roas - avg_7d_roas) * 1.0 / avg_7d_roas END, 4) AS roas_vs_7d_avg_pct
    FROM windowed
),
statuses AS (
    SELECT
        *,
        CASE
            WHEN impressions_vs_7d_avg_pct <= -0.30 THEN 'Traffic Drop'
            WHEN impressions_vs_7d_avg_pct >= 0.30 THEN 'Traffic Spike'
            ELSE 'Stable Traffic'
        END AS traffic_trend_status,
        CASE
            WHEN conversions_vs_7d_avg_pct <= -0.30 THEN 'Conversion Drop'
            WHEN conversions_vs_7d_avg_pct >= 0.30 THEN 'Conversion Spike'
            ELSE 'Stable Conversions'
        END AS conversion_trend_status,
        CASE
            WHEN spend_vs_7d_avg_pct >= 0.30 THEN 'Spend Spike'
            WHEN spend_vs_7d_avg_pct <= -0.30 THEN 'Spend Drop'
            ELSE 'Stable Spend'
        END AS spend_trend_status,
        CASE
            WHEN roas_vs_7d_avg_pct <= -0.30 THEN 'ROAS Drop'
            WHEN roas_vs_7d_avg_pct >= 0.30 THEN 'ROAS Improvement'
            ELSE 'Stable ROAS'
        END AS roas_trend_status
    FROM changes
)
SELECT
    metric_date,
    campaign_id,
    campaign_name,
    platform_name,
    platform_category,
    country,
    region_name,
    business_unit,
    campaign_type,
    campaign_objective,
    campaign_status,
    impressions,
    clicks,
    spend,
    conversions,
    revenue,
    ctr,
    cpc,
    cpm,
    cvr,
    cpa,
    roas,
    aov,
    previous_day_impressions,
    previous_day_clicks,
    previous_day_spend,
    previous_day_conversions,
    previous_day_revenue,
    previous_day_ctr,
    previous_day_cpc,
    previous_day_cpa,
    previous_day_roas,
    impressions_day_over_day_change_pct,
    clicks_day_over_day_change_pct,
    spend_day_over_day_change_pct,
    conversions_day_over_day_change_pct,
    revenue_day_over_day_change_pct,
    ctr_day_over_day_change_pct,
    cpc_day_over_day_change_pct,
    cpa_day_over_day_change_pct,
    roas_day_over_day_change_pct,
    ROUND(avg_7d_impressions, 2) AS avg_7d_impressions,
    ROUND(avg_7d_clicks, 2) AS avg_7d_clicks,
    ROUND(avg_7d_spend, 2) AS avg_7d_spend,
    ROUND(avg_7d_conversions, 2) AS avg_7d_conversions,
    ROUND(avg_7d_revenue, 2) AS avg_7d_revenue,
    ROUND(avg_7d_ctr, 6) AS avg_7d_ctr,
    ROUND(avg_7d_cpc, 4) AS avg_7d_cpc,
    ROUND(avg_7d_cpa, 4) AS avg_7d_cpa,
    ROUND(avg_7d_roas, 4) AS avg_7d_roas,
    impressions_vs_7d_avg_pct,
    clicks_vs_7d_avg_pct,
    spend_vs_7d_avg_pct,
    conversions_vs_7d_avg_pct,
    revenue_vs_7d_avg_pct,
    ctr_vs_7d_avg_pct,
    cpc_vs_7d_avg_pct,
    cpa_vs_7d_avg_pct,
    roas_vs_7d_avg_pct,
    traffic_trend_status,
    conversion_trend_status,
    spend_trend_status,
    roas_trend_status,
    CASE
        WHEN spend_trend_status = 'Spend Spike' AND roas_trend_status = 'ROAS Drop' THEN 'Watch: Spend Spike + ROAS Drop'
        WHEN traffic_trend_status = 'Traffic Drop' THEN 'Watch: Traffic Drop'
        WHEN conversion_trend_status = 'Conversion Drop' THEN 'Watch: Conversion Drop'
        WHEN roas_trend_status = 'ROAS Improvement' OR conversion_trend_status = 'Conversion Spike' THEN 'Improving'
        ELSE 'Stable'
    END AS overall_performance_watch_status
FROM statuses;

-- Latest performance monitoring row per campaign.
CREATE TABLE campaign_performance_monitoring_summary AS
WITH latest AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY campaign_id ORDER BY metric_date DESC) AS row_number
    FROM campaign_daily_performance_monitoring
)
SELECT
    campaign_id,
    campaign_name,
    platform_name,
    platform_category,
    country,
    region_name,
    business_unit,
    campaign_type,
    campaign_objective,
    campaign_status,
    metric_date AS latest_metric_date,
    impressions,
    clicks,
    spend,
    conversions,
    revenue,
    ctr,
    cpc,
    cpa,
    roas,
    impressions_vs_7d_avg_pct,
    clicks_vs_7d_avg_pct,
    spend_vs_7d_avg_pct,
    conversions_vs_7d_avg_pct,
    revenue_vs_7d_avg_pct,
    ctr_vs_7d_avg_pct,
    cpa_vs_7d_avg_pct,
    roas_vs_7d_avg_pct,
    traffic_trend_status,
    conversion_trend_status,
    spend_trend_status,
    roas_trend_status,
    overall_performance_watch_status
FROM latest
WHERE row_number = 1;

-- Dashboard-ready summary combining KPI, budget pacing, and performance monitoring.
CREATE TABLE campaign_monitoring_dashboard_summary AS
SELECT
    k.campaign_id,
    k.campaign_name,
    k.platform_name,
    k.platform_category,
    k.country,
    k.region_name,
    k.business_unit,
    k.campaign_type,
    k.campaign_objective,
    k.campaign_status,
    k.total_impressions,
    k.total_clicks,
    k.total_spend,
    k.total_conversions,
    k.total_revenue,
    k.overall_ctr,
    k.overall_cpc,
    k.overall_cpa,
    k.overall_roas,
    b.total_budget,
    b.actual_spend_to_date,
    b.remaining_budget,
    b.budget_utilization_percentage,
    b.pacing_ratio,
    b.projected_total_spend,
    b.projected_budget_variance,
    b.budget_pacing_status,
    b.budget_risk_level,
    p.latest_metric_date,
    p.traffic_trend_status,
    p.conversion_trend_status,
    p.spend_trend_status,
    p.roas_trend_status,
    p.overall_performance_watch_status
FROM campaign_kpi_summary k
LEFT JOIN campaign_budget_pacing_summary b
    ON k.campaign_id = b.campaign_id
LEFT JOIN campaign_performance_monitoring_summary p
    ON k.campaign_id = p.campaign_id;
