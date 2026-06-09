-- Phase 2: Create and populate staging tables.
-- Important rule: bad rows are not removed silently. Staging keeps raw rows and
-- adds quality flags so issues can be reviewed before later KPI logic is built.

DROP TABLE IF EXISTS stg_campaign_alert_rules;
DROP TABLE IF EXISTS stg_campaign_targets;
DROP TABLE IF EXISTS stg_budget_allocations;
DROP TABLE IF EXISTS stg_campaign_hourly_metrics;
DROP TABLE IF EXISTS stg_campaign_daily_metrics;
DROP TABLE IF EXISTS stg_campaigns;
DROP TABLE IF EXISTS stg_calendar;
DROP TABLE IF EXISTS stg_regions;
DROP TABLE IF EXISTS stg_ad_platforms;

CREATE TABLE stg_ad_platforms AS
SELECT
    platform_id,
    CASE
        WHEN UPPER(TRIM(platform_name)) = 'GOOGLE ADS' THEN 'Google Ads'
        WHEN UPPER(TRIM(platform_name)) = 'META ADS' THEN 'Meta Ads'
        WHEN UPPER(TRIM(platform_name)) = 'TIKTOK ADS' THEN 'TikTok Ads'
        WHEN UPPER(TRIM(platform_name)) = 'LINKEDIN ADS' THEN 'LinkedIn Ads'
        WHEN UPPER(TRIM(platform_name)) = 'DV360' THEN 'DV360'
        WHEN UPPER(TRIM(platform_name)) = 'YOUTUBE ADS' THEN 'YouTube Ads'
        WHEN UPPER(TRIM(platform_name)) = 'EMAIL CRM' THEN 'Email CRM'
        ELSE TRIM(platform_name)
    END AS platform_name,
    CASE
        WHEN UPPER(TRIM(platform_category)) = 'SEARCH' THEN 'Search'
        WHEN UPPER(TRIM(platform_category)) = 'SOCIAL' THEN 'Social'
        WHEN UPPER(TRIM(platform_category)) = 'VIDEO' THEN 'Video'
        WHEN UPPER(TRIM(platform_category)) = 'DISPLAY' THEN 'Display'
        WHEN UPPER(TRIM(platform_category)) = 'EMAIL' THEN 'Email'
        WHEN UPPER(TRIM(platform_category)) = 'PROGRAMMATIC' THEN 'Programmatic'
        ELSE TRIM(platform_category)
    END AS platform_category,
    CASE WHEN COALESCE(is_paid_platform, 0) = 1 THEN 1 ELSE 0 END AS is_paid_platform
FROM raw_ad_platforms;

CREATE TABLE stg_regions AS
SELECT
    region_id,
    TRIM(country) AS country,
    TRIM(region_name) AS region_name,
    UPPER(TRIM(currency)) AS currency
FROM raw_regions;

CREATE TABLE stg_calendar AS
SELECT
    TRIM(date) AS date,
    TRIM(day_name) AS day_name,
    week_number,
    month_number,
    TRIM(month_name) AS month_name,
    TRIM(quarter) AS quarter,
    year,
    CASE WHEN COALESCE(is_weekend, 0) = 1 THEN 1 ELSE 0 END AS is_weekend
FROM raw_calendar;

CREATE TABLE stg_campaigns AS
WITH latest_metric_date AS (
    SELECT MAX(metric_date) AS simulated_current_date
    FROM raw_campaign_daily_metrics
)
SELECT
    c.campaign_id,
    TRIM(c.campaign_name) AS campaign_name,
    c.platform_id,
    c.region_id,
    TRIM(c.business_unit) AS business_unit,
    TRIM(c.campaign_type) AS campaign_type,
    TRIM(c.campaign_objective) AS campaign_objective,
    TRIM(c.start_date) AS start_date,
    TRIM(c.end_date) AS end_date,
    CASE
        WHEN UPPER(TRIM(c.campaign_status)) = 'ACTIVE' THEN 'Active'
        WHEN UPPER(TRIM(c.campaign_status)) = 'PAUSED' THEN 'Paused'
        WHEN UPPER(TRIM(c.campaign_status)) = 'COMPLETED' THEN 'Completed'
        WHEN UPPER(TRIM(c.campaign_status)) = 'PLANNED' THEN 'Planned'
        ELSE 'Unknown'
    END AS campaign_status,
    TRIM(c.created_at) AS created_at,
    CASE
        WHEN c.start_date IS NULL OR TRIM(c.start_date) = '' THEN NULL
        WHEN c.end_date IS NULL OR TRIM(c.end_date) = '' THEN NULL
        WHEN date(c.start_date) > date(c.end_date) THEN NULL
        ELSE CAST(julianday(c.end_date) - julianday(c.start_date) + 1 AS INTEGER)
    END AS campaign_duration_days,
    CASE
        WHEN date(l.simulated_current_date) BETWEEN date(c.start_date) AND date(c.end_date)
             AND UPPER(TRIM(c.campaign_status)) = 'ACTIVE'
        THEN 1 ELSE 0
    END AS is_currently_active,
    CASE
        WHEN c.start_date IS NULL OR TRIM(c.start_date) = '' THEN 'Missing Start Date'
        WHEN c.end_date IS NULL OR TRIM(c.end_date) = '' THEN 'Missing End Date'
        WHEN date(c.start_date) > date(c.end_date) THEN 'Start Date After End Date'
        ELSE 'Valid Dates'
    END AS campaign_date_quality_flag
FROM raw_campaigns c
CROSS JOIN latest_metric_date l;

CREATE TABLE stg_campaign_daily_metrics AS
SELECT
    TRIM(d.metric_date) AS metric_date,
    d.campaign_id,
    CASE WHEN COALESCE(d.impressions, 0) < 0 THEN 0 ELSE COALESCE(d.impressions, 0) END AS impressions,
    CASE WHEN COALESCE(d.clicks, 0) < 0 THEN 0 ELSE COALESCE(d.clicks, 0) END AS clicks,
    CASE WHEN COALESCE(d.spend, 0) < 0 THEN 0 ELSE COALESCE(d.spend, 0) END AS spend,
    CASE WHEN COALESCE(d.conversions, 0) < 0 THEN 0 ELSE COALESCE(d.conversions, 0) END AS conversions,
    CASE WHEN COALESCE(d.revenue, 0) < 0 THEN 0 ELSE COALESCE(d.revenue, 0) END AS revenue,
    CASE
        WHEN d.campaign_id IS NULL THEN 'Missing Campaign ID'
        WHEN COALESCE(d.impressions, 0) < 0
          OR COALESCE(d.clicks, 0) < 0
          OR COALESCE(d.spend, 0) < 0
          OR COALESCE(d.conversions, 0) < 0
          OR COALESCE(d.revenue, 0) < 0 THEN 'Negative Metric Found'
        WHEN COALESCE(d.clicks, 0) > COALESCE(d.impressions, 0) THEN 'Clicks Greater Than Impressions'
        WHEN COALESCE(d.conversions, 0) > COALESCE(d.clicks, 0) THEN 'Conversions Greater Than Clicks'
        ELSE 'Valid Metric Row'
    END AS metric_quality_flag,
    CASE
        WHEN c.campaign_id IS NOT NULL
             AND date(d.metric_date) BETWEEN date(c.start_date) AND date(c.end_date)
        THEN 1 ELSE 0
    END AS is_campaign_date_valid,
    CASE WHEN c.campaign_id IS NOT NULL THEN 1 ELSE 0 END AS is_known_campaign
FROM raw_campaign_daily_metrics d
LEFT JOIN stg_campaigns c
    ON d.campaign_id = c.campaign_id;

CREATE TABLE stg_campaign_hourly_metrics AS
SELECT
    TRIM(h.metric_datetime) AS metric_datetime,
    TRIM(h.metric_date) AS metric_date,
    h.metric_hour,
    h.campaign_id,
    CASE WHEN COALESCE(h.impressions, 0) < 0 THEN 0 ELSE COALESCE(h.impressions, 0) END AS impressions,
    CASE WHEN COALESCE(h.clicks, 0) < 0 THEN 0 ELSE COALESCE(h.clicks, 0) END AS clicks,
    CASE WHEN COALESCE(h.spend, 0) < 0 THEN 0 ELSE COALESCE(h.spend, 0) END AS spend,
    CASE WHEN COALESCE(h.conversions, 0) < 0 THEN 0 ELSE COALESCE(h.conversions, 0) END AS conversions,
    CASE WHEN COALESCE(h.revenue, 0) < 0 THEN 0 ELSE COALESCE(h.revenue, 0) END AS revenue,
    CASE
        WHEN h.campaign_id IS NULL THEN 'Missing Campaign ID'
        WHEN COALESCE(h.impressions, 0) < 0
          OR COALESCE(h.clicks, 0) < 0
          OR COALESCE(h.spend, 0) < 0
          OR COALESCE(h.conversions, 0) < 0
          OR COALESCE(h.revenue, 0) < 0 THEN 'Negative Metric Found'
        WHEN COALESCE(h.clicks, 0) > COALESCE(h.impressions, 0) THEN 'Clicks Greater Than Impressions'
        WHEN COALESCE(h.conversions, 0) > COALESCE(h.clicks, 0) THEN 'Conversions Greater Than Clicks'
        ELSE 'Valid Metric Row'
    END AS metric_quality_flag,
    CASE
        WHEN c.campaign_id IS NOT NULL
             AND date(h.metric_date) BETWEEN date(c.start_date) AND date(c.end_date)
        THEN 1 ELSE 0
    END AS is_campaign_date_valid,
    CASE WHEN c.campaign_id IS NOT NULL THEN 1 ELSE 0 END AS is_known_campaign,
    CASE WHEN h.metric_hour BETWEEN 0 AND 23 THEN 'Valid Hour' ELSE 'Invalid Hour' END AS hourly_quality_flag
FROM raw_campaign_hourly_metrics h
LEFT JOIN stg_campaigns c
    ON h.campaign_id = c.campaign_id;

CREATE TABLE stg_budget_allocations AS
SELECT
    campaign_id,
    COALESCE(total_budget, 0) AS total_budget,
    COALESCE(daily_budget, 0) AS daily_budget,
    TRIM(budget_start_date) AS budget_start_date,
    TRIM(budget_end_date) AS budget_end_date,
    CASE
        WHEN total_budget IS NULL OR daily_budget IS NULL THEN 'Missing Budget'
        WHEN COALESCE(total_budget, 0) < 0 OR COALESCE(daily_budget, 0) < 0 THEN 'Negative Budget'
        WHEN COALESCE(daily_budget, 0) > COALESCE(total_budget, 0) THEN 'Daily Budget Greater Than Total Budget'
        WHEN date(budget_start_date) > date(budget_end_date) THEN 'Budget Start After End Date'
        ELSE 'Valid Budget'
    END AS budget_quality_flag
FROM raw_budget_allocations;

CREATE TABLE stg_campaign_targets AS
SELECT
    campaign_id,
    COALESCE(target_ctr, 0) AS target_ctr,
    COALESCE(target_cpc, 0) AS target_cpc,
    COALESCE(target_cpa, 0) AS target_cpa,
    COALESCE(target_roas, 0) AS target_roas,
    COALESCE(target_cvr, 0) AS target_cvr,
    CASE
        WHEN target_ctr IS NULL OR target_cpc IS NULL OR target_cpa IS NULL
          OR target_roas IS NULL OR target_cvr IS NULL THEN 'Missing Target'
        WHEN COALESCE(target_ctr, 0) < 0 OR COALESCE(target_cpc, 0) < 0
          OR COALESCE(target_cpa, 0) < 0 OR COALESCE(target_roas, 0) < 0
          OR COALESCE(target_cvr, 0) < 0 THEN 'Invalid Negative Target'
        WHEN COALESCE(target_ctr, 0) > 1 OR COALESCE(target_cvr, 0) > 1
          OR COALESCE(target_roas, 0) > 20 THEN 'Suspiciously High Target'
        ELSE 'Valid Target'
    END AS target_quality_flag
FROM raw_campaign_targets;

CREATE TABLE stg_campaign_alert_rules AS
SELECT
    rule_id,
    TRIM(rule_name) AS rule_name,
    TRIM(metric_name) AS metric_name,
    TRIM(condition_type) AS condition_type,
    threshold_value,
    CASE
        WHEN UPPER(TRIM(severity)) = 'LOW' THEN 'Low'
        WHEN UPPER(TRIM(severity)) = 'MEDIUM' THEN 'Medium'
        WHEN UPPER(TRIM(severity)) = 'HIGH' THEN 'High'
        WHEN UPPER(TRIM(severity)) = 'CRITICAL' THEN 'Critical'
        ELSE 'Unknown'
    END AS severity,
    TRIM(rule_description) AS rule_description,
    CASE
        WHEN rule_name IS NULL OR TRIM(rule_name) = '' THEN 'Missing Rule Name'
        WHEN metric_name IS NULL OR TRIM(metric_name) = '' THEN 'Missing Metric Name'
        WHEN threshold_value IS NULL THEN 'Missing Threshold'
        WHEN UPPER(TRIM(severity)) NOT IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') THEN 'Invalid Severity'
        ELSE 'Valid Rule'
    END AS alert_rule_quality_flag
FROM raw_campaign_alert_rules;
