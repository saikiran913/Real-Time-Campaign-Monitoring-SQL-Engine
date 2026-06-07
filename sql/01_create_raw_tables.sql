-- Phase 1: Create raw SQLite tables for the Real-Time Campaign Monitoring SQL Engine.
-- Run this file before 02_insert_sample_data.sql.

DROP TABLE IF EXISTS raw_campaign_alert_rules;
DROP TABLE IF EXISTS raw_campaign_targets;
DROP TABLE IF EXISTS raw_budget_allocations;
DROP TABLE IF EXISTS raw_campaign_hourly_metrics;
DROP TABLE IF EXISTS raw_campaign_daily_metrics;
DROP TABLE IF EXISTS raw_calendar;
DROP TABLE IF EXISTS raw_regions;
DROP TABLE IF EXISTS raw_ad_platforms;
DROP TABLE IF EXISTS raw_campaigns;

-- Master campaign list. One row represents one marketing campaign.
CREATE TABLE raw_campaigns (
    campaign_id INTEGER,
    campaign_name TEXT,
    platform_id INTEGER,
    region_id INTEGER,
    business_unit TEXT,
    campaign_type TEXT,
    campaign_objective TEXT,
    start_date TEXT,
    end_date TEXT,
    campaign_status TEXT,
    created_at TEXT
);

-- Advertising platforms and their channel categories.
CREATE TABLE raw_ad_platforms (
    platform_id INTEGER,
    platform_name TEXT,
    platform_category TEXT,
    is_paid_platform INTEGER
);

-- Country and currency lookup table for campaign regions.
CREATE TABLE raw_regions (
    region_id INTEGER,
    country TEXT,
    region_name TEXT,
    currency TEXT
);

-- Calendar dimension used for date-based validation and future reporting.
CREATE TABLE raw_calendar (
    date TEXT,
    day_name TEXT,
    week_number INTEGER,
    month_number INTEGER,
    month_name TEXT,
    quarter TEXT,
    year INTEGER,
    is_weekend INTEGER
);

-- Daily campaign performance metrics loaded from synthetic CSV data.
CREATE TABLE raw_campaign_daily_metrics (
    metric_date TEXT,
    campaign_id INTEGER,
    impressions INTEGER,
    clicks INTEGER,
    spend REAL,
    conversions INTEGER,
    revenue REAL
);

-- Hourly campaign performance metrics for near-real-time monitoring simulation.
CREATE TABLE raw_campaign_hourly_metrics (
    metric_datetime TEXT,
    metric_date TEXT,
    metric_hour INTEGER,
    campaign_id INTEGER,
    impressions INTEGER,
    clicks INTEGER,
    spend REAL,
    conversions INTEGER,
    revenue REAL
);

-- Budget allocations for each campaign.
CREATE TABLE raw_budget_allocations (
    campaign_id INTEGER,
    total_budget REAL,
    daily_budget REAL,
    budget_start_date TEXT,
    budget_end_date TEXT
);

-- Campaign performance targets used by future KPI and alert logic.
CREATE TABLE raw_campaign_targets (
    campaign_id INTEGER,
    target_ctr REAL,
    target_cpc REAL,
    target_cpa REAL,
    target_roas REAL,
    target_cvr REAL
);

-- Alert rule definitions for future monitoring logic.
CREATE TABLE raw_campaign_alert_rules (
    rule_id INTEGER,
    rule_name TEXT,
    metric_name TEXT,
    condition_type TEXT,
    threshold_value REAL,
    severity TEXT,
    rule_description TEXT
);
