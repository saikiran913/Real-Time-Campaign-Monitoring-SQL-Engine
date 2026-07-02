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

# Phase 4 Budget Pacing And Monitoring Tables

Phase 4 tables are built from Phase 3 KPI tables and Phase 2 staging budget/campaign tables. They monitor spend pacing and performance trends. They do not create final alerts or campaign health scores.

## campaign_budget_pacing_daily

Grain: one row per campaign per metric date.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Daily metric date. |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name. |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| business_unit | TEXT | Campaign business unit. |
| campaign_type | TEXT | Campaign type. |
| campaign_objective | TEXT | Campaign objective. |
| campaign_status | TEXT | Campaign status. |
| start_date | TEXT | Campaign start date. |
| end_date | TEXT | Campaign end date. |
| total_budget | REAL | Total allocated campaign budget. |
| daily_budget | REAL | Expected daily budget. |
| budget_start_date | TEXT | Budget start date. |
| budget_end_date | TEXT | Budget end date. |
| campaign_duration_days | INTEGER | Campaign duration in days. |
| budget_duration_days | INTEGER | Budget duration in days. |
| campaign_day_number | INTEGER | Metric date position within campaign dates. |
| budget_day_number | INTEGER | Metric date position within budget dates. |
| total_impressions | INTEGER | Daily impressions from KPI fact. |
| total_clicks | INTEGER | Daily clicks from KPI fact. |
| daily_spend | REAL | Daily spend from KPI fact. |
| daily_conversions | INTEGER | Daily conversions from KPI fact. |
| daily_revenue | REAL | Daily revenue from KPI fact. |
| actual_spend_to_date | REAL | Cumulative campaign spend through metric date. |
| expected_spend_to_date | REAL | Expected spend through metric date. |
| remaining_budget | REAL | Budget remaining after actual spend to date. |
| spend_variance_amount | REAL | Actual spend to date minus expected spend to date. |
| spend_variance_percentage | REAL | Spend variance divided by expected spend to date. |
| pacing_ratio | REAL | Actual spend to date divided by expected spend to date. |
| projected_total_spend | REAL | Projected final spend based on current pacing. |
| projected_budget_variance | REAL | Projected total spend minus total budget. |
| budget_utilization_percentage | REAL | Actual spend to date divided by total budget. |
| budget_pacing_status | TEXT | Budget pacing category. |
| budget_risk_level | TEXT | Budget risk category. |

## campaign_budget_pacing_summary

Grain: one latest budget pacing row per campaign.

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest campaign metric date. |
| total_budget | REAL | Total allocated campaign budget. |
| daily_budget | REAL | Expected daily budget. |
| actual_spend_to_date | REAL | Cumulative spend through latest date. |
| expected_spend_to_date | REAL | Expected spend through latest date. |
| remaining_budget | REAL | Budget remaining after actual spend to date. |
| spend_variance_amount | REAL | Actual spend to date minus expected spend to date. |
| spend_variance_percentage | REAL | Spend variance divided by expected spend to date. |
| pacing_ratio | REAL | Actual spend to date divided by expected spend to date. |
| projected_total_spend | REAL | Projected final spend. |
| projected_budget_variance | REAL | Projected total spend minus total budget. |
| budget_utilization_percentage | REAL | Budget utilization percentage. |
| budget_pacing_status | TEXT | Budget pacing category. |
| budget_risk_level | TEXT | Budget risk category. |

## campaign_daily_performance_monitoring

Grain: one row per campaign per metric date.

| Column | Data Type | Description |
| --- | --- | --- |
| metric_date | TEXT | Daily metric date. |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name. |
| platform_name | TEXT | Platform name. |
| platform_category | TEXT | Platform category. |
| country | TEXT | Country value. |
| region_name | TEXT | Region name. |
| business_unit | TEXT | Campaign business unit. |
| campaign_type | TEXT | Campaign type. |
| campaign_objective | TEXT | Campaign objective. |
| campaign_status | TEXT | Campaign status. |
| impressions | INTEGER | Daily impressions. |
| clicks | INTEGER | Daily clicks. |
| spend | REAL | Daily spend. |
| conversions | INTEGER | Daily conversions. |
| revenue | REAL | Daily revenue. |
| ctr | REAL | Daily CTR. |
| cpc | REAL | Daily CPC. |
| cpm | REAL | Daily CPM. |
| cvr | REAL | Daily CVR. |
| cpa | REAL | Daily CPA. |
| roas | REAL | Daily ROAS. |
| aov | REAL | Daily AOV. |
| previous_day_impressions | INTEGER | Previous campaign metric row impressions. |
| previous_day_clicks | INTEGER | Previous campaign metric row clicks. |
| previous_day_spend | REAL | Previous campaign metric row spend. |
| previous_day_conversions | INTEGER | Previous campaign metric row conversions. |
| previous_day_revenue | REAL | Previous campaign metric row revenue. |
| previous_day_ctr | REAL | Previous campaign metric row CTR. |
| previous_day_cpc | REAL | Previous campaign metric row CPC. |
| previous_day_cpa | REAL | Previous campaign metric row CPA. |
| previous_day_roas | REAL | Previous campaign metric row ROAS. |
| impressions_day_over_day_change_pct | REAL | Impressions change versus previous row. |
| clicks_day_over_day_change_pct | REAL | Clicks change versus previous row. |
| spend_day_over_day_change_pct | REAL | Spend change versus previous row. |
| conversions_day_over_day_change_pct | REAL | Conversions change versus previous row. |
| revenue_day_over_day_change_pct | REAL | Revenue change versus previous row. |
| ctr_day_over_day_change_pct | REAL | CTR change versus previous row. |
| cpc_day_over_day_change_pct | REAL | CPC change versus previous row. |
| cpa_day_over_day_change_pct | REAL | CPA change versus previous row. |
| roas_day_over_day_change_pct | REAL | ROAS change versus previous row. |
| avg_7d_impressions | REAL | Previous seven-row average impressions. |
| avg_7d_clicks | REAL | Previous seven-row average clicks. |
| avg_7d_spend | REAL | Previous seven-row average spend. |
| avg_7d_conversions | REAL | Previous seven-row average conversions. |
| avg_7d_revenue | REAL | Previous seven-row average revenue. |
| avg_7d_ctr | REAL | Previous seven-row average CTR. |
| avg_7d_cpc | REAL | Previous seven-row average CPC. |
| avg_7d_cpa | REAL | Previous seven-row average CPA. |
| avg_7d_roas | REAL | Previous seven-row average ROAS. |
| impressions_vs_7d_avg_pct | REAL | Impressions change versus 7-day baseline. |
| clicks_vs_7d_avg_pct | REAL | Clicks change versus 7-day baseline. |
| spend_vs_7d_avg_pct | REAL | Spend change versus 7-day baseline. |
| conversions_vs_7d_avg_pct | REAL | Conversions change versus 7-day baseline. |
| revenue_vs_7d_avg_pct | REAL | Revenue change versus 7-day baseline. |
| ctr_vs_7d_avg_pct | REAL | CTR change versus 7-day baseline. |
| cpc_vs_7d_avg_pct | REAL | CPC change versus 7-day baseline. |
| cpa_vs_7d_avg_pct | REAL | CPA change versus 7-day baseline. |
| roas_vs_7d_avg_pct | REAL | ROAS change versus 7-day baseline. |
| traffic_trend_status | TEXT | Traffic trend label. |
| conversion_trend_status | TEXT | Conversion trend label. |
| spend_trend_status | TEXT | Spend trend label. |
| roas_trend_status | TEXT | ROAS trend label. |
| overall_performance_watch_status | TEXT | Combined watch status. |

## campaign_performance_monitoring_summary

Grain: one latest performance monitoring row per campaign.

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest campaign metric date. |
| impressions | INTEGER | Latest impressions. |
| clicks | INTEGER | Latest clicks. |
| spend | REAL | Latest spend. |
| conversions | INTEGER | Latest conversions. |
| revenue | REAL | Latest revenue. |
| ctr | REAL | Latest CTR. |
| cpc | REAL | Latest CPC. |
| cpa | REAL | Latest CPA. |
| roas | REAL | Latest ROAS. |
| impressions_vs_7d_avg_pct | REAL | Latest impressions change versus 7-day baseline. |
| clicks_vs_7d_avg_pct | REAL | Latest clicks change versus 7-day baseline. |
| spend_vs_7d_avg_pct | REAL | Latest spend change versus 7-day baseline. |
| conversions_vs_7d_avg_pct | REAL | Latest conversions change versus 7-day baseline. |
| revenue_vs_7d_avg_pct | REAL | Latest revenue change versus 7-day baseline. |
| ctr_vs_7d_avg_pct | REAL | Latest CTR change versus 7-day baseline. |
| cpa_vs_7d_avg_pct | REAL | Latest CPA change versus 7-day baseline. |
| roas_vs_7d_avg_pct | REAL | Latest ROAS change versus 7-day baseline. |
| traffic_trend_status | TEXT | Latest traffic trend label. |
| conversion_trend_status | TEXT | Latest conversion trend label. |
| spend_trend_status | TEXT | Latest spend trend label. |
| roas_trend_status | TEXT | Latest ROAS trend label. |
| overall_performance_watch_status | TEXT | Latest combined watch status. |

## campaign_monitoring_dashboard_summary

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
| campaign_status | TEXT | Campaign status. |
| total_impressions | INTEGER | Campaign total impressions. |
| total_clicks | INTEGER | Campaign total clicks. |
| total_spend | REAL | Campaign total spend. |
| total_conversions | INTEGER | Campaign total conversions. |
| total_revenue | REAL | Campaign total revenue. |
| overall_ctr | REAL | Campaign overall CTR. |
| overall_cpc | REAL | Campaign overall CPC. |
| overall_cpa | REAL | Campaign overall CPA. |
| overall_roas | REAL | Campaign overall ROAS. |
| total_budget | REAL | Total allocated budget. |
| actual_spend_to_date | REAL | Actual spend through latest date. |
| remaining_budget | REAL | Remaining budget. |
| budget_utilization_percentage | REAL | Budget utilization percentage. |
| pacing_ratio | REAL | Budget pacing ratio. |
| projected_total_spend | REAL | Projected total spend. |
| projected_budget_variance | REAL | Projected total spend minus total budget. |
| budget_pacing_status | TEXT | Budget pacing category. |
| budget_risk_level | TEXT | Budget risk category. |
| latest_metric_date | TEXT | Latest monitoring metric date. |
| traffic_trend_status | TEXT | Latest traffic trend label. |
| conversion_trend_status | TEXT | Latest conversion trend label. |
| spend_trend_status | TEXT | Latest spend trend label. |
| roas_trend_status | TEXT | Latest ROAS trend label. |
| overall_performance_watch_status | TEXT | Latest combined watch status. |

# Phase 5 Anomaly Detection, Alerts, And Health Score Tables

Phase 5 tables use Phase 4 monitoring outputs as the main source. They flag anomalies, generate alert messages, calculate health scores, identify critical campaigns, and map generated alert categories to configured alert rules.

## campaign_anomaly_detection

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest monitoring metric date. |
| total_impressions | INTEGER | Campaign total impressions. |
| total_clicks | INTEGER | Campaign total clicks. |
| total_spend | REAL | Campaign total spend. |
| total_conversions | INTEGER | Campaign total conversions. |
| total_revenue | REAL | Campaign total revenue. |
| overall_ctr | REAL | Campaign overall CTR. |
| overall_cpc | REAL | Campaign overall CPC. |
| overall_cpa | REAL | Campaign overall CPA. |
| overall_roas | REAL | Campaign overall ROAS. |
| target_ctr | REAL | Campaign target CTR used for anomaly logic. |
| target_cpa | REAL | Campaign target CPA used for anomaly logic. |
| target_roas | REAL | Campaign target ROAS used for anomaly logic. |
| total_budget | REAL | Total allocated campaign budget. |
| actual_spend_to_date | REAL | Actual spend through latest date. |
| remaining_budget | REAL | Remaining budget. |
| budget_utilization_percentage | REAL | Budget utilization percentage. |
| pacing_ratio | REAL | Budget pacing ratio. |
| projected_total_spend | REAL | Projected total spend. |
| projected_budget_variance | REAL | Projected total spend minus total budget. |
| budget_pacing_status | TEXT | Budget pacing status from Phase 4. |
| budget_risk_level | TEXT | Budget risk level from Phase 4. |
| traffic_trend_status | TEXT | Traffic trend status from Phase 4. |
| conversion_trend_status | TEXT | Conversion trend status from Phase 4. |
| spend_trend_status | TEXT | Spend trend status from Phase 4. |
| roas_trend_status | TEXT | ROAS trend status from Phase 4. |
| overall_performance_watch_status | TEXT | Overall performance watch status from Phase 4. |
| high_spend_zero_conversion_flag | INTEGER | 1 when spend is high and conversions are zero. |
| roas_below_target_flag | INTEGER | 1 when ROAS is below target. |
| cpa_above_target_flag | INTEGER | 1 when CPA is above target. |
| ctr_below_target_flag | INTEGER | 1 when CTR is below target. |
| budget_overspend_flag | INTEGER | 1 when budget pacing indicates overspend. |
| budget_underspend_flag | INTEGER | 1 when budget pacing indicates underspend. |
| spend_spike_flag | INTEGER | 1 when spend trend indicates a spike. |
| traffic_drop_flag | INTEGER | 1 when traffic trend indicates a drop. |
| conversion_drop_flag | INTEGER | 1 when conversion trend indicates a drop. |
| roas_drop_flag | INTEGER | 1 when ROAS trend indicates a drop. |
| no_impressions_active_campaign_flag | INTEGER | 1 when an active campaign has zero impressions. |
| poor_efficiency_flag | INTEGER | 1 when spend is greater than revenue. |
| anomaly_count | INTEGER | Total anomaly flags for the campaign. |
| critical_anomaly_count | INTEGER | Count of critical anomaly signals. |
| high_anomaly_count | INTEGER | Count of high anomaly signals. |
| medium_anomaly_count | INTEGER | Count of medium anomaly signals. |
| low_anomaly_count | INTEGER | Reserved count for future low anomaly signals. |

## campaign_alert_summary

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest monitoring metric date. |
| total_spend | REAL | Campaign total spend. |
| total_conversions | INTEGER | Campaign total conversions. |
| total_revenue | REAL | Campaign total revenue. |
| overall_ctr | REAL | Campaign overall CTR. |
| overall_cpa | REAL | Campaign overall CPA. |
| overall_roas | REAL | Campaign overall ROAS. |
| budget_pacing_status | TEXT | Budget pacing status. |
| budget_risk_level | TEXT | Budget risk level. |
| overall_performance_watch_status | TEXT | Overall performance watch status. |
| anomaly_count | INTEGER | Total anomaly count. |
| critical_anomaly_count | INTEGER | Critical anomaly count. |
| high_anomaly_count | INTEGER | High anomaly count. |
| medium_anomaly_count | INTEGER | Medium anomaly count. |
| low_anomaly_count | INTEGER | Low anomaly count. |
| alert_required | INTEGER | 1 when an alert is required. |
| alert_severity | TEXT | Alert severity classification. |
| primary_alert_category | TEXT | Highest-priority alert category. |
| alert_message | TEXT | Business-readable alert message. |
| recommended_action | TEXT | Business-readable recommended action. |

## campaign_health_score

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest monitoring metric date. |
| total_spend | REAL | Campaign total spend. |
| total_revenue | REAL | Campaign total revenue. |
| overall_ctr | REAL | Campaign overall CTR. |
| overall_cpa | REAL | Campaign overall CPA. |
| overall_roas | REAL | Campaign overall ROAS. |
| budget_pacing_status | TEXT | Budget pacing status. |
| budget_risk_level | TEXT | Budget risk level. |
| overall_performance_watch_status | TEXT | Overall performance watch status. |
| anomaly_count | INTEGER | Total anomaly count. |
| alert_required | INTEGER | 1 when an alert is required. |
| alert_severity | TEXT | Alert severity classification. |
| primary_alert_category | TEXT | Highest-priority alert category. |
| base_score | INTEGER | Starting score before deductions. |
| kpi_score_adjustment | INTEGER | KPI-related score adjustment. |
| budget_score_adjustment | INTEGER | Budget-related score adjustment. |
| trend_score_adjustment | INTEGER | Trend-related score adjustment. |
| anomaly_score_adjustment | INTEGER | Anomaly-related score adjustment. |
| final_health_score | INTEGER | Capped 0 to 100 campaign health score. |
| health_status | TEXT | Critical, At Risk, Watch, or Healthy. |
| main_issue | TEXT | Main issue copied from primary alert category. |
| recommended_action | TEXT | Recommended action from alert summary. |

## critical_campaign_summary

Grain: one row per campaign that requires attention.

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
| campaign_status | TEXT | Campaign status. |
| latest_metric_date | TEXT | Latest monitoring metric date. |
| total_spend | REAL | Campaign total spend. |
| total_revenue | REAL | Campaign total revenue. |
| overall_roas | REAL | Campaign overall ROAS. |
| budget_pacing_status | TEXT | Budget pacing status. |
| overall_performance_watch_status | TEXT | Overall performance watch status. |
| anomaly_count | INTEGER | Total anomaly count. |
| alert_severity | TEXT | Alert severity classification. |
| primary_alert_category | TEXT | Highest-priority alert category. |
| final_health_score | INTEGER | Campaign health score. |
| health_status | TEXT | Campaign health status. |
| main_issue | TEXT | Main issue to investigate. |
| recommended_action | TEXT | Recommended action. |

## campaign_alert_rule_mapping

Grain: one row per campaign alert where possible.

| Column | Data Type | Description |
| --- | --- | --- |
| campaign_id | INTEGER | Campaign identifier. |
| campaign_name | TEXT | Campaign name. |
| primary_alert_category | TEXT | Generated primary alert category. |
| alert_severity | TEXT | Generated alert severity. |
| configured_rule_name | TEXT | Matching configured rule name when available. |
| configured_metric_name | TEXT | Configured metric name. |
| configured_condition_type | TEXT | Configured condition type. |
| configured_threshold_value | REAL | Configured threshold value. |
| configured_severity | TEXT | Configured severity. |
| rule_description | TEXT | Configured rule description. |
| rule_mapping_status | TEXT | Mapping status for the generated alert. |

# Phase 6 Final Validation Outputs

Phase 6 does not create new business tables. It adds SELECT-only final validation and sample output queries.

## Final Validation Query Outputs

| Output | Description |
| --- | --- |
| Table existence summary | Confirms major raw, staging, KPI, monitoring, alert, and health score tables exist. |
| Row count summary | Shows final row counts for important tables. |
| Data flow checks | Compares row counts between raw, staging, KPI, alert, and health score outputs. |
| Metric reconciliation | Reconciles impressions, clicks, spend, conversions, and revenue between staging and KPI fact tables. |
| Business output summary | Summarizes campaigns, alerts, health status, spend, revenue, and ROAS. |
| Severity distributions | Shows counts by alert severity, health status, budget pacing status, and performance watch status. |
