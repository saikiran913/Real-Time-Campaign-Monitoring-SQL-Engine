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

