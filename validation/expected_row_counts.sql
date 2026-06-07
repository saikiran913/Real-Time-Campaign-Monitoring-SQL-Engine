-- Expected row counts after running sql/01_create_raw_tables.sql and sql/02_insert_sample_data.sql.

-- Expected: 20 rows
SELECT 'raw_campaigns' AS table_name, COUNT(*) AS actual_row_count FROM raw_campaigns;

-- Expected: 7 rows
SELECT 'raw_ad_platforms' AS table_name, COUNT(*) AS actual_row_count FROM raw_ad_platforms;

-- Expected: 7 rows
SELECT 'raw_regions' AS table_name, COUNT(*) AS actual_row_count FROM raw_regions;

-- Expected: 91 rows
SELECT 'raw_calendar' AS table_name, COUNT(*) AS actual_row_count FROM raw_calendar;

-- Expected: 1365 rows
SELECT 'raw_campaign_daily_metrics' AS table_name, COUNT(*) AS actual_row_count FROM raw_campaign_daily_metrics;

-- Expected: 576 rows
SELECT 'raw_campaign_hourly_metrics' AS table_name, COUNT(*) AS actual_row_count FROM raw_campaign_hourly_metrics;

-- Expected: 20 rows
SELECT 'raw_budget_allocations' AS table_name, COUNT(*) AS actual_row_count FROM raw_budget_allocations;

-- Expected: 20 rows
SELECT 'raw_campaign_targets' AS table_name, COUNT(*) AS actual_row_count FROM raw_campaign_targets;

-- Expected: 8 rows
SELECT 'raw_campaign_alert_rules' AS table_name, COUNT(*) AS actual_row_count FROM raw_campaign_alert_rules;

