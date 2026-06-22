# Data Dictionary

## campaigns

Campaign master data.

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Unique campaign identifier. |
| campaign_name | TEXT | Human-readable campaign name. |
| platform_id | INTEGER | Advertising platform identifier. |
| region_id | INTEGER | Campaign region identifier. |
| business_unit | TEXT | Business area that owns the campaign. |
| campaign_type | TEXT | Marketing channel or campaign type. |
| campaign_objective | TEXT | Primary campaign goal. |
| start_date | TEXT | Campaign start date. |
| end_date | TEXT | Campaign end date. |
| campaign_status | TEXT | Current campaign status. |
| created_at | TEXT | Date the campaign record was created. |

## ad_platforms

Platform lookup data.

| Column | Data Type | Description |
| --- | --- | --- |
| platform_id | INTEGER | Advertising platform identifier. |
| platform_name | TEXT | Advertising platform name. |
| platform_category | TEXT | Platform channel category. |
| is_paid_platform | INTEGER | 1 for paid platforms, 0 for unpaid owned channels. |

## regions

Region and currency lookup data.

| Column | Data Type | Description |
| --- | --- | --- |
| region_id | INTEGER | Campaign region identifier. |
| country | TEXT | Country code or country name. |
| region_name | TEXT | Full region name. |
| currency | TEXT | Campaign reporting currency. |

## calendar

Date lookup data.

| Column | Data Type | Description |
| --- | --- | --- |
| date | TEXT | Calendar date. |
| day_name | TEXT | Day of week. |
| week_number | INTEGER | Simplified week number for local simulation. |
| month_number | INTEGER | Month number. |
| month_name | TEXT | Month name. |
| quarter | TEXT | Calendar quarter. |
| year | INTEGER | Calendar year. |
| is_weekend | INTEGER | 1 if Saturday or Sunday, otherwise 0. |

## campaign_daily_metrics

Daily campaign metric facts.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Date of campaign metrics. |
| campaign_id | INTEGER | Unique campaign identifier. |
| impressions | INTEGER | Number of ad impressions. |
| clicks | INTEGER | Number of clicks. |
| spend | REAL | Campaign spend for the period. |
| conversions | INTEGER | Number of conversions. |
| revenue | REAL | Revenue attributed to the campaign period. |

## campaign_hourly_metrics

Hourly campaign metric facts.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_datetime | TEXT | Hourly metric timestamp. |
| metric_date | TEXT | Date of campaign metrics. |
| metric_hour | INTEGER | Hour of day from 0 to 23. |
| campaign_id | INTEGER | Unique campaign identifier. |
| impressions | INTEGER | Number of ad impressions. |
| clicks | INTEGER | Number of clicks. |
| spend | REAL | Campaign spend for the period. |
| conversions | INTEGER | Number of conversions. |
| revenue | REAL | Revenue attributed to the campaign period. |

## budget_allocations

Campaign budget settings.

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Unique campaign identifier. |
| total_budget | REAL | Total campaign budget. |
| daily_budget | REAL | Expected daily budget. |
| budget_start_date | TEXT | Budget start date. |
| budget_end_date | TEXT | Budget end date. |

## campaign_targets

Campaign KPI targets.

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Unique campaign identifier. |
| target_ctr | REAL | Target click-through rate. |
| target_cpc | REAL | Target cost per click. |
| target_cpa | REAL | Target cost per acquisition. |
| target_roas | REAL | Target return on ad spend. |
| target_cvr | REAL | Target conversion rate. |

## campaign_alert_rules

Alert rule definitions.

| Column | Data Type | Description |
| --- | --- | --- |
| rule_id | INTEGER | Unique alert rule identifier. |
| rule_name | TEXT | Alert rule name. |
| metric_name | TEXT | Metric evaluated by the alert rule. |
| condition_type | TEXT | Rule comparison type. |
| threshold_value | REAL | Threshold used by the rule. |
| severity | TEXT | Business severity of the alert. |
| rule_description | TEXT | Plain-language rule description. |

# Phase 2 Staging Tables

The staging tables keep the raw row grain, apply light cleaning, and add data quality fields. Bad rows are not removed silently; they remain available with flags.

## stg_ad_platforms

| Column | Data Type | Description |
| --- | --- | --- |
| platform_id | INTEGER | Advertising platform identifier. |
| platform_name | TEXT | Trimmed advertising platform name. |
| platform_category | TEXT | Trimmed platform channel category. |
| is_paid_platform | INTEGER | Standardized 1 or 0 paid platform flag. |

## stg_regions

| Column | Data Type | Description |
| --- | --- | --- |
| region_id | INTEGER | Campaign region identifier. |
| country | TEXT | Trimmed country value. |
| region_name | TEXT | Trimmed region name. |
| currency | TEXT | Uppercase reporting currency. |

## stg_calendar

| Column | Data Type | Description |
| --- | --- | --- |
| date | TEXT | Cleaned calendar date. |
| day_name | TEXT | Day of week. |
| week_number | INTEGER | Simplified week number for local simulation. |
| month_number | INTEGER | Month number. |
| month_name | TEXT | Month name. |
| quarter | TEXT | Calendar quarter. |
| year | INTEGER | Calendar year. |
| is_weekend | INTEGER | Standardized 1 or 0 weekend flag. |

## stg_campaigns

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Unique campaign identifier. |
| campaign_name | TEXT | Trimmed campaign name. |
| platform_id | INTEGER | Advertising platform identifier. |
| region_id | INTEGER | Campaign region identifier. |
| business_unit | TEXT | Trimmed business area. |
| campaign_type | TEXT | Trimmed campaign type. |
| campaign_objective | TEXT | Trimmed campaign objective. |
| start_date | TEXT | Campaign start date. |
| end_date | TEXT | Campaign end date. |
| campaign_status | TEXT | Standardized campaign status. |
| created_at | TEXT | Date the campaign record was created. |
| campaign_duration_days | INTEGER | Derived inclusive number of days between start and end date. |
| is_currently_active | INTEGER | 1 when the simulated current date is within the campaign date range and status is Active. |
| campaign_date_quality_flag | TEXT | Campaign date quality result. |

## stg_campaign_daily_metrics

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Daily metric date. |
| campaign_id | INTEGER | Campaign identifier. |
| impressions | INTEGER | Cleaned impressions value. |
| clicks | INTEGER | Cleaned clicks value. |
| spend | REAL | Cleaned spend value. |
| conversions | INTEGER | Cleaned conversions value. |
| revenue | REAL | Cleaned revenue value. |
| metric_quality_flag | TEXT | Metric row quality result. |
| is_campaign_date_valid | INTEGER | 1 when metric date is within campaign start and end dates. |
| is_known_campaign | INTEGER | 1 when campaign ID exists in `stg_campaigns`. |

## stg_campaign_hourly_metrics

| Column | Data Type | Description |
| --- | --- | --- |
| metric_datetime | TEXT | Hourly metric timestamp. |
| metric_date | TEXT | Hourly metric date. |
| metric_hour | INTEGER | Hour of day from 0 to 23. |
| campaign_id | INTEGER | Campaign identifier. |
| impressions | INTEGER | Cleaned impressions value. |
| clicks | INTEGER | Cleaned clicks value. |
| spend | REAL | Cleaned spend value. |
| conversions | INTEGER | Cleaned conversions value. |
| revenue | REAL | Cleaned revenue value. |
| metric_quality_flag | TEXT | Metric row quality result. |
| is_campaign_date_valid | INTEGER | 1 when metric date is within campaign start and end dates. |
| is_known_campaign | INTEGER | 1 when campaign ID exists in `stg_campaigns`. |
| hourly_quality_flag | TEXT | Valid Hour or Invalid Hour. |

## stg_budget_allocations

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Campaign identifier. |
| total_budget | REAL | Cleaned total campaign budget. |
| daily_budget | REAL | Cleaned expected daily budget. |
| budget_start_date | TEXT | Budget start date. |
| budget_end_date | TEXT | Budget end date. |
| budget_quality_flag | TEXT | Budget quality result. |

## stg_campaign_targets

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Campaign identifier. |
| target_ctr | REAL | Cleaned target click-through rate. |
| target_cpc | REAL | Cleaned target cost per click. |
| target_cpa | REAL | Cleaned target cost per acquisition. |
| target_roas | REAL | Cleaned target return on ad spend. |
| target_cvr | REAL | Cleaned target conversion rate. |
| target_quality_flag | TEXT | Target quality result. |

## stg_campaign_alert_rules

| Column | Data Type | Description |
| --- | --- | --- |
| rule_id | INTEGER | Alert rule identifier. |
| rule_name | TEXT | Trimmed alert rule name. |
| metric_name | TEXT | Trimmed metric evaluated by the rule. |
| condition_type | TEXT | Trimmed rule comparison type. |
| threshold_value | REAL | Threshold used by the rule. |
| severity | TEXT | Standardized severity. |
| rule_description | TEXT | Trimmed plain-language rule description. |
| alert_rule_quality_flag | TEXT | Alert rule quality result. |

# Phase 3 KPI Tables

Phase 3 KPI tables are built from Phase 2 staging tables only. They calculate performance KPIs, compare campaign results against targets, and aggregate performance across useful reporting grains.

## fact_campaign_daily_performance

Grain: one row per `campaign_id` per `metric_date`.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Daily metric date. |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name from staging. |
| platform_id | INTEGER | Platform identifier. |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| region_id | INTEGER | Region identifier. |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| currency | TEXT | Reporting currency. |
| business_unit | TEXT | Campaign business unit. |
| campaign_type | TEXT | Campaign type. |
| campaign_objective | TEXT | Campaign objective. |
| campaign_status | TEXT | Standardized campaign status. |
| impressions | INTEGER | Daily impressions. |
| clicks | INTEGER | Daily clicks. |
| spend | REAL | Daily spend. |
| conversions | INTEGER | Daily conversions. |
| revenue | REAL | Daily revenue. |
| ctr | REAL | Click-through rate, calculated as clicks divided by impressions. |
| cpc | REAL | Cost per click, calculated as spend divided by clicks. |
| cpm | REAL | Cost per thousand impressions. |
| cvr | REAL | Conversion rate, calculated as conversions divided by clicks. |
| cpa | REAL | Cost per acquisition, calculated as spend divided by conversions. |
| roas | REAL | Return on ad spend, calculated as revenue divided by spend. |
| aov | REAL | Average order value, calculated as revenue divided by conversions. |
| target_ctr | REAL | Campaign target CTR. |
| target_cpc | REAL | Campaign target CPC. |
| target_cpa | REAL | Campaign target CPA. |
| target_roas | REAL | Campaign target ROAS. |
| target_cvr | REAL | Campaign target CVR. |
| ctr_target_status | TEXT | CTR target comparison result. |
| cpc_target_status | TEXT | CPC target comparison result. |
| cpa_target_status | TEXT | CPA target comparison result. |
| roas_target_status | TEXT | ROAS target comparison result. |
| cvr_target_status | TEXT | CVR target comparison result. |
| metric_quality_flag | TEXT | Carried-forward Phase 2 metric quality flag. |
| is_campaign_date_valid | INTEGER | Carried-forward campaign date validation flag. |
| is_known_campaign | INTEGER | Carried-forward known campaign flag. |

## fact_campaign_hourly_performance

Grain: one row per `campaign_id` per `metric_date` per `metric_hour`.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_datetime | TEXT | Hourly metric timestamp. |
| metric_date | TEXT | Hourly metric date. |
| metric_hour | INTEGER | Hour of day from 0 to 23. |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name from staging. |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| currency | TEXT | Reporting currency. |
| business_unit | TEXT | Campaign business unit. |
| campaign_type | TEXT | Campaign type. |
| campaign_objective | TEXT | Campaign objective. |
| campaign_status | TEXT | Standardized campaign status. |
| impressions | INTEGER | Hourly impressions. |
| clicks | INTEGER | Hourly clicks. |
| spend | REAL | Hourly spend. |
| conversions | INTEGER | Hourly conversions. |
| revenue | REAL | Hourly revenue. |
| ctr | REAL | Hourly click-through rate. |
| cpc | REAL | Hourly cost per click. |
| cpm | REAL | Hourly cost per thousand impressions. |
| cvr | REAL | Hourly conversion rate. |
| cpa | REAL | Hourly cost per acquisition. |
| roas | REAL | Hourly return on ad spend. |
| aov | REAL | Hourly average order value. |
| ctr_target_status | TEXT | CTR target comparison result. |
| cpc_target_status | TEXT | CPC target comparison result. |
| cpa_target_status | TEXT | CPA target comparison result. |
| roas_target_status | TEXT | ROAS target comparison result. |
| cvr_target_status | TEXT | CVR target comparison result. |
| metric_quality_flag | TEXT | Carried-forward Phase 2 metric quality flag. |
| hourly_quality_flag | TEXT | Carried-forward Phase 2 hourly quality flag. |
| is_campaign_date_valid | INTEGER | Carried-forward campaign date validation flag. |
| is_known_campaign | INTEGER | Carried-forward known campaign flag. |

## campaign_kpi_summary

Grain: one row per campaign.

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name. |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| business_unit | TEXT | Campaign business unit. |
| campaign_type | TEXT | Campaign type. |
| campaign_objective | TEXT | Campaign objective. |
| campaign_status | TEXT | Standardized campaign status. |
| first_metric_date | TEXT | First metric date for the campaign. |
| last_metric_date | TEXT | Last metric date for the campaign. |
| active_metric_days | INTEGER | Count of metric dates for the campaign. |
| total_impressions | INTEGER | Total impressions. |
| total_clicks | INTEGER | Total clicks. |
| total_spend | REAL | Total spend. |
| total_conversions | INTEGER | Total conversions. |
| total_revenue | REAL | Total revenue. |
| overall_ctr | REAL | Campaign-level CTR. |
| overall_cpc | REAL | Campaign-level CPC. |
| overall_cpm | REAL | Campaign-level CPM. |
| overall_cvr | REAL | Campaign-level CVR. |
| overall_cpa | REAL | Campaign-level CPA. |
| overall_roas | REAL | Campaign-level ROAS. |
| overall_aov | REAL | Campaign-level AOV. |
| target_ctr | REAL | Campaign target CTR. |
| target_cpc | REAL | Campaign target CPC. |
| target_cpa | REAL | Campaign target CPA. |
| target_roas | REAL | Campaign target ROAS. |
| target_cvr | REAL | Campaign target CVR. |
| overall_ctr_target_status | TEXT | Campaign-level CTR target comparison. |
| overall_cpc_target_status | TEXT | Campaign-level CPC target comparison. |
| overall_cpa_target_status | TEXT | Campaign-level CPA target comparison. |
| overall_roas_target_status | TEXT | Campaign-level ROAS target comparison. |
| overall_cvr_target_status | TEXT | Campaign-level CVR target comparison. |

## platform_kpi_summary

Grain: one row per platform name and platform category.

| Column | Data Type | Description |
| --- | --- | --- |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| campaign_count | INTEGER | Count of campaigns on the platform. |
| total_impressions | INTEGER | Total impressions. |
| total_clicks | INTEGER | Total clicks. |
| total_spend | REAL | Total spend. |
| total_conversions | INTEGER | Total conversions. |
| total_revenue | REAL | Total revenue. |
| overall_ctr | REAL | Platform-level CTR. |
| overall_cpc | REAL | Platform-level CPC. |
| overall_cpm | REAL | Platform-level CPM. |
| overall_cvr | REAL | Platform-level CVR. |
| overall_cpa | REAL | Platform-level CPA. |
| overall_roas | REAL | Platform-level ROAS. |
| overall_aov | REAL | Platform-level AOV. |

## region_kpi_summary

Grain: one row per country, region, and currency.

| Column | Data Type | Description |
| --- | --- | --- |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| currency | TEXT | Reporting currency. |
| campaign_count | INTEGER | Count of campaigns in the region. |
| total_impressions | INTEGER | Total impressions. |
| total_clicks | INTEGER | Total clicks. |
| total_spend | REAL | Total spend. |
| total_conversions | INTEGER | Total conversions. |
| total_revenue | REAL | Total revenue. |
| overall_ctr | REAL | Region-level CTR. |
| overall_cpc | REAL | Region-level CPC. |
| overall_cpm | REAL | Region-level CPM. |
| overall_cvr | REAL | Region-level CVR. |
| overall_cpa | REAL | Region-level CPA. |
| overall_roas | REAL | Region-level ROAS. |
| overall_aov | REAL | Region-level AOV. |

## daily_kpi_trend_summary

Grain: one row per metric date.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Metric date. |
| campaign_count | INTEGER | Count of campaigns with metrics on the date. |
| total_impressions | INTEGER | Total impressions. |
| total_clicks | INTEGER | Total clicks. |
| total_spend | REAL | Total spend. |
| total_conversions | INTEGER | Total conversions. |
| total_revenue | REAL | Total revenue. |
| daily_ctr | REAL | Daily CTR. |
| daily_cpc | REAL | Daily CPC. |
| daily_cpm | REAL | Daily CPM. |
| daily_cvr | REAL | Daily CVR. |
| daily_cpa | REAL | Daily CPA. |
| daily_roas | REAL | Daily ROAS. |
| daily_aov | REAL | Daily AOV. |

## hourly_kpi_trend_summary

Grain: one row per metric date and metric hour.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Metric date. |
| metric_hour | INTEGER | Hour of day. |
| campaign_count | INTEGER | Count of campaigns with metrics in the hour. |
| total_impressions | INTEGER | Total impressions. |
| total_clicks | INTEGER | Total clicks. |
| total_spend | REAL | Total spend. |
| total_conversions | INTEGER | Total conversions. |
| total_revenue | REAL | Total revenue. |
| hourly_ctr | REAL | Hourly CTR. |
| hourly_cpc | REAL | Hourly CPC. |
| hourly_cpm | REAL | Hourly CPM. |
| hourly_cvr | REAL | Hourly CVR. |
| hourly_cpa | REAL | Hourly CPA. |
| hourly_roas | REAL | Hourly ROAS. |
| hourly_aov | REAL | Hourly AOV. |
