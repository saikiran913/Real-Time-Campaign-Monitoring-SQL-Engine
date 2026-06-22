-- Phase 3: KPI calculation engine.
-- Source rule: KPI tables are built from Phase 2 staging tables only.
-- Data quality rule: staging rows are not removed silently; quality flags are
-- carried into KPI facts so questionable records remain visible.

DROP TABLE IF EXISTS hourly_kpi_trend_summary;
DROP TABLE IF EXISTS daily_kpi_trend_summary;
DROP TABLE IF EXISTS region_kpi_summary;
DROP TABLE IF EXISTS platform_kpi_summary;
DROP TABLE IF EXISTS campaign_kpi_summary;
DROP TABLE IF EXISTS fact_campaign_hourly_performance;
DROP TABLE IF EXISTS fact_campaign_daily_performance;

-- Daily campaign performance fact table.
CREATE TABLE fact_campaign_daily_performance AS
WITH base AS (
    SELECT
        d.metric_date,
        d.campaign_id,
        c.campaign_name,
        c.platform_id,
        p.platform_name,
        p.platform_category,
        c.region_id,
        r.country,
        r.region_name,
        r.currency,
        c.business_unit,
        c.campaign_type,
        c.campaign_objective,
        c.campaign_status,
        d.impressions,
        d.clicks,
        d.spend,
        d.conversions,
        d.revenue,
        ROUND(CASE WHEN d.impressions = 0 THEN 0 ELSE 1.0 * d.clicks / d.impressions END, 6) AS ctr,
        ROUND(CASE WHEN d.clicks = 0 THEN 0 ELSE 1.0 * d.spend / d.clicks END, 4) AS cpc,
        ROUND(CASE WHEN d.impressions = 0 THEN 0 ELSE 1000.0 * d.spend / d.impressions END, 4) AS cpm,
        ROUND(CASE WHEN d.clicks = 0 THEN 0 ELSE 1.0 * d.conversions / d.clicks END, 6) AS cvr,
        ROUND(CASE WHEN d.conversions = 0 THEN 0 ELSE 1.0 * d.spend / d.conversions END, 4) AS cpa,
        ROUND(CASE WHEN d.spend = 0 THEN 0 ELSE 1.0 * d.revenue / d.spend END, 4) AS roas,
        ROUND(CASE WHEN d.conversions = 0 THEN 0 ELSE 1.0 * d.revenue / d.conversions END, 4) AS aov,
        t.target_ctr,
        t.target_cpc,
        t.target_cpa,
        t.target_roas,
        t.target_cvr,
        d.metric_quality_flag,
        d.is_campaign_date_valid,
        d.is_known_campaign
    FROM stg_campaign_daily_metrics d
    LEFT JOIN stg_campaigns c
        ON d.campaign_id = c.campaign_id
    LEFT JOIN stg_ad_platforms p
        ON c.platform_id = p.platform_id
    LEFT JOIN stg_regions r
        ON c.region_id = r.region_id
    LEFT JOIN stg_campaign_targets t
        ON d.campaign_id = t.campaign_id
)
SELECT
    metric_date,
    campaign_id,
    campaign_name,
    platform_id,
    platform_name,
    platform_category,
    region_id,
    country,
    region_name,
    currency,
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
    target_ctr,
    target_cpc,
    target_cpa,
    target_roas,
    target_cvr,
    CASE
        WHEN target_ctr IS NULL OR target_ctr = 0 THEN 'No Target'
        WHEN ctr >= target_ctr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS ctr_target_status,
    CASE
        WHEN target_cpc IS NULL OR target_cpc = 0 THEN 'No Target'
        WHEN cpc <= target_cpc AND cpc > 0 THEN 'Meets Target'
        WHEN cpc > target_cpc THEN 'Above Target'
        ELSE 'No Target'
    END AS cpc_target_status,
    CASE
        WHEN target_cpa IS NULL OR target_cpa = 0 THEN 'No Target'
        WHEN cpa <= target_cpa AND cpa > 0 THEN 'Meets Target'
        WHEN cpa > target_cpa THEN 'Above Target'
        ELSE 'No Target'
    END AS cpa_target_status,
    CASE
        WHEN target_roas IS NULL OR target_roas = 0 THEN 'No Target'
        WHEN roas >= target_roas THEN 'Meets Target'
        ELSE 'Below Target'
    END AS roas_target_status,
    CASE
        WHEN target_cvr IS NULL OR target_cvr = 0 THEN 'No Target'
        WHEN cvr >= target_cvr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS cvr_target_status,
    metric_quality_flag,
    is_campaign_date_valid,
    is_known_campaign
FROM base;

-- Hourly campaign performance fact table.
CREATE TABLE fact_campaign_hourly_performance AS
WITH base AS (
    SELECT
        h.metric_datetime,
        h.metric_date,
        h.metric_hour,
        h.campaign_id,
        c.campaign_name,
        p.platform_name,
        p.platform_category,
        r.country,
        r.region_name,
        r.currency,
        c.business_unit,
        c.campaign_type,
        c.campaign_objective,
        c.campaign_status,
        h.impressions,
        h.clicks,
        h.spend,
        h.conversions,
        h.revenue,
        ROUND(CASE WHEN h.impressions = 0 THEN 0 ELSE 1.0 * h.clicks / h.impressions END, 6) AS ctr,
        ROUND(CASE WHEN h.clicks = 0 THEN 0 ELSE 1.0 * h.spend / h.clicks END, 4) AS cpc,
        ROUND(CASE WHEN h.impressions = 0 THEN 0 ELSE 1000.0 * h.spend / h.impressions END, 4) AS cpm,
        ROUND(CASE WHEN h.clicks = 0 THEN 0 ELSE 1.0 * h.conversions / h.clicks END, 6) AS cvr,
        ROUND(CASE WHEN h.conversions = 0 THEN 0 ELSE 1.0 * h.spend / h.conversions END, 4) AS cpa,
        ROUND(CASE WHEN h.spend = 0 THEN 0 ELSE 1.0 * h.revenue / h.spend END, 4) AS roas,
        ROUND(CASE WHEN h.conversions = 0 THEN 0 ELSE 1.0 * h.revenue / h.conversions END, 4) AS aov,
        t.target_ctr,
        t.target_cpc,
        t.target_cpa,
        t.target_roas,
        t.target_cvr,
        h.metric_quality_flag,
        h.hourly_quality_flag,
        h.is_campaign_date_valid,
        h.is_known_campaign
    FROM stg_campaign_hourly_metrics h
    LEFT JOIN stg_campaigns c
        ON h.campaign_id = c.campaign_id
    LEFT JOIN stg_ad_platforms p
        ON c.platform_id = p.platform_id
    LEFT JOIN stg_regions r
        ON c.region_id = r.region_id
    LEFT JOIN stg_campaign_targets t
        ON h.campaign_id = t.campaign_id
)
SELECT
    metric_datetime,
    metric_date,
    metric_hour,
    campaign_id,
    campaign_name,
    platform_name,
    platform_category,
    country,
    region_name,
    currency,
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
    CASE
        WHEN target_ctr IS NULL OR target_ctr = 0 THEN 'No Target'
        WHEN ctr >= target_ctr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS ctr_target_status,
    CASE
        WHEN target_cpc IS NULL OR target_cpc = 0 THEN 'No Target'
        WHEN cpc <= target_cpc AND cpc > 0 THEN 'Meets Target'
        WHEN cpc > target_cpc THEN 'Above Target'
        ELSE 'No Target'
    END AS cpc_target_status,
    CASE
        WHEN target_cpa IS NULL OR target_cpa = 0 THEN 'No Target'
        WHEN cpa <= target_cpa AND cpa > 0 THEN 'Meets Target'
        WHEN cpa > target_cpa THEN 'Above Target'
        ELSE 'No Target'
    END AS cpa_target_status,
    CASE
        WHEN target_roas IS NULL OR target_roas = 0 THEN 'No Target'
        WHEN roas >= target_roas THEN 'Meets Target'
        ELSE 'Below Target'
    END AS roas_target_status,
    CASE
        WHEN target_cvr IS NULL OR target_cvr = 0 THEN 'No Target'
        WHEN cvr >= target_cvr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS cvr_target_status,
    metric_quality_flag,
    hourly_quality_flag,
    is_campaign_date_valid,
    is_known_campaign
FROM base;

-- Campaign-level KPI summary.
CREATE TABLE campaign_kpi_summary AS
WITH summary AS (
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
        MIN(metric_date) AS first_metric_date,
        MAX(metric_date) AS last_metric_date,
        COUNT(DISTINCT metric_date) AS active_metric_days,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        ROUND(SUM(spend), 2) AS total_spend,
        SUM(conversions) AS total_conversions,
        ROUND(SUM(revenue), 2) AS total_revenue,
        MAX(target_ctr) AS target_ctr,
        MAX(target_cpc) AS target_cpc,
        MAX(target_cpa) AS target_cpa,
        MAX(target_roas) AS target_roas,
        MAX(target_cvr) AS target_cvr
    FROM fact_campaign_daily_performance
    GROUP BY
        campaign_id,
        campaign_name,
        platform_name,
        platform_category,
        country,
        region_name,
        business_unit,
        campaign_type,
        campaign_objective,
        campaign_status
),
kpis AS (
    SELECT
        *,
        ROUND(CASE WHEN total_impressions = 0 THEN 0 ELSE 1.0 * total_clicks / total_impressions END, 6) AS overall_ctr,
        ROUND(CASE WHEN total_clicks = 0 THEN 0 ELSE 1.0 * total_spend / total_clicks END, 4) AS overall_cpc,
        ROUND(CASE WHEN total_impressions = 0 THEN 0 ELSE 1000.0 * total_spend / total_impressions END, 4) AS overall_cpm,
        ROUND(CASE WHEN total_clicks = 0 THEN 0 ELSE 1.0 * total_conversions / total_clicks END, 6) AS overall_cvr,
        ROUND(CASE WHEN total_conversions = 0 THEN 0 ELSE 1.0 * total_spend / total_conversions END, 4) AS overall_cpa,
        ROUND(CASE WHEN total_spend = 0 THEN 0 ELSE 1.0 * total_revenue / total_spend END, 4) AS overall_roas,
        ROUND(CASE WHEN total_conversions = 0 THEN 0 ELSE 1.0 * total_revenue / total_conversions END, 4) AS overall_aov
    FROM summary
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
    first_metric_date,
    last_metric_date,
    active_metric_days,
    total_impressions,
    total_clicks,
    total_spend,
    total_conversions,
    total_revenue,
    overall_ctr,
    overall_cpc,
    overall_cpm,
    overall_cvr,
    overall_cpa,
    overall_roas,
    overall_aov,
    target_ctr,
    target_cpc,
    target_cpa,
    target_roas,
    target_cvr,
    CASE
        WHEN target_ctr IS NULL OR target_ctr = 0 THEN 'No Target'
        WHEN overall_ctr >= target_ctr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS overall_ctr_target_status,
    CASE
        WHEN target_cpc IS NULL OR target_cpc = 0 THEN 'No Target'
        WHEN overall_cpc <= target_cpc AND overall_cpc > 0 THEN 'Meets Target'
        WHEN overall_cpc > target_cpc THEN 'Above Target'
        ELSE 'No Target'
    END AS overall_cpc_target_status,
    CASE
        WHEN target_cpa IS NULL OR target_cpa = 0 THEN 'No Target'
        WHEN overall_cpa <= target_cpa AND overall_cpa > 0 THEN 'Meets Target'
        WHEN overall_cpa > target_cpa THEN 'Above Target'
        ELSE 'No Target'
    END AS overall_cpa_target_status,
    CASE
        WHEN target_roas IS NULL OR target_roas = 0 THEN 'No Target'
        WHEN overall_roas >= target_roas THEN 'Meets Target'
        ELSE 'Below Target'
    END AS overall_roas_target_status,
    CASE
        WHEN target_cvr IS NULL OR target_cvr = 0 THEN 'No Target'
        WHEN overall_cvr >= target_cvr THEN 'Meets Target'
        ELSE 'Below Target'
    END AS overall_cvr_target_status
FROM kpis;

-- Platform-level KPI summary.
CREATE TABLE platform_kpi_summary AS
SELECT
    platform_name,
    platform_category,
    COUNT(DISTINCT campaign_id) AS campaign_count,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1.0 * SUM(clicks) / SUM(impressions) END, 6) AS overall_ctr,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(clicks) END, 4) AS overall_cpc,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1000.0 * SUM(spend) / SUM(impressions) END, 4) AS overall_cpm,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(conversions) / SUM(clicks) END, 6) AS overall_cvr,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(conversions) END, 4) AS overall_cpa,
    ROUND(CASE WHEN SUM(spend) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(spend) END, 4) AS overall_roas,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(conversions) END, 4) AS overall_aov
FROM fact_campaign_daily_performance
GROUP BY platform_name, platform_category;

-- Region-level KPI summary.
CREATE TABLE region_kpi_summary AS
SELECT
    country,
    region_name,
    currency,
    COUNT(DISTINCT campaign_id) AS campaign_count,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1.0 * SUM(clicks) / SUM(impressions) END, 6) AS overall_ctr,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(clicks) END, 4) AS overall_cpc,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1000.0 * SUM(spend) / SUM(impressions) END, 4) AS overall_cpm,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(conversions) / SUM(clicks) END, 6) AS overall_cvr,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(conversions) END, 4) AS overall_cpa,
    ROUND(CASE WHEN SUM(spend) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(spend) END, 4) AS overall_roas,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(conversions) END, 4) AS overall_aov
FROM fact_campaign_daily_performance
GROUP BY country, region_name, currency;

-- Daily KPI trend summary.
CREATE TABLE daily_kpi_trend_summary AS
SELECT
    metric_date,
    COUNT(DISTINCT campaign_id) AS campaign_count,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1.0 * SUM(clicks) / SUM(impressions) END, 6) AS daily_ctr,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(clicks) END, 4) AS daily_cpc,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1000.0 * SUM(spend) / SUM(impressions) END, 4) AS daily_cpm,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(conversions) / SUM(clicks) END, 6) AS daily_cvr,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(conversions) END, 4) AS daily_cpa,
    ROUND(CASE WHEN SUM(spend) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(spend) END, 4) AS daily_roas,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(conversions) END, 4) AS daily_aov
FROM fact_campaign_daily_performance
GROUP BY metric_date;

-- Hourly KPI trend summary.
CREATE TABLE hourly_kpi_trend_summary AS
SELECT
    metric_date,
    metric_hour,
    COUNT(DISTINCT campaign_id) AS campaign_count,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1.0 * SUM(clicks) / SUM(impressions) END, 6) AS hourly_ctr,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(clicks) END, 4) AS hourly_cpc,
    ROUND(CASE WHEN SUM(impressions) = 0 THEN 0 ELSE 1000.0 * SUM(spend) / SUM(impressions) END, 4) AS hourly_cpm,
    ROUND(CASE WHEN SUM(clicks) = 0 THEN 0 ELSE 1.0 * SUM(conversions) / SUM(clicks) END, 6) AS hourly_cvr,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(spend) / SUM(conversions) END, 4) AS hourly_cpa,
    ROUND(CASE WHEN SUM(spend) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(spend) END, 4) AS hourly_roas,
    ROUND(CASE WHEN SUM(conversions) = 0 THEN 0 ELSE 1.0 * SUM(revenue) / SUM(conversions) END, 4) AS hourly_aov
FROM fact_campaign_hourly_performance
GROUP BY metric_date, metric_hour;
