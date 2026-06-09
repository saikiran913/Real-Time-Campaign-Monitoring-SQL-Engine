-- Referential integrity checks for Phase 2 staging data.
-- These SELECT queries report relationship issues and do not modify data.

SELECT c.*
FROM stg_campaigns c
LEFT JOIN stg_ad_platforms p
    ON c.platform_id = p.platform_id
WHERE p.platform_id IS NULL;

SELECT c.*
FROM stg_campaigns c
LEFT JOIN stg_regions r
    ON c.region_id = r.region_id
WHERE r.region_id IS NULL;

SELECT d.*
FROM stg_campaign_daily_metrics d
LEFT JOIN stg_campaigns c
    ON d.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL;

SELECT h.*
FROM stg_campaign_hourly_metrics h
LEFT JOIN stg_campaigns c
    ON h.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL;

SELECT b.*
FROM stg_budget_allocations b
LEFT JOIN stg_campaigns c
    ON b.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL;

SELECT t.*
FROM stg_campaign_targets t
LEFT JOIN stg_campaigns c
    ON t.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL;
