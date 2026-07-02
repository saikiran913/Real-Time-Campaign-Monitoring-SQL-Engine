-- Phase 5: Anomaly detection, alert generation, and campaign health scoring.
-- Main source rule: use Phase 4 monitoring tables where possible.
-- Safety rule: do not modify or recreate raw, staging, KPI, or monitoring tables.

DROP TABLE IF EXISTS campaign_alert_rule_mapping;
DROP TABLE IF EXISTS critical_campaign_summary;
DROP TABLE IF EXISTS campaign_health_score;
DROP TABLE IF EXISTS campaign_alert_summary;
DROP TABLE IF EXISTS campaign_anomaly_detection;

-- Campaign-level anomaly detection.
CREATE TABLE campaign_anomaly_detection AS
WITH base AS (
    SELECT
        d.campaign_id,
        d.campaign_name,
        d.platform_name,
        d.platform_category,
        d.country,
        d.region_name,
        d.business_unit,
        d.campaign_type,
        d.campaign_objective,
        d.campaign_status,
        d.latest_metric_date,
        d.total_impressions,
        d.total_clicks,
        d.total_spend,
        d.total_conversions,
        d.total_revenue,
        d.overall_ctr,
        d.overall_cpc,
        d.overall_cpa,
        d.overall_roas,
        k.target_ctr,
        k.target_cpa,
        k.target_roas,
        d.total_budget,
        d.actual_spend_to_date,
        d.remaining_budget,
        d.budget_utilization_percentage,
        d.pacing_ratio,
        d.projected_total_spend,
        d.projected_budget_variance,
        d.budget_pacing_status,
        d.budget_risk_level,
        d.traffic_trend_status,
        d.conversion_trend_status,
        d.spend_trend_status,
        d.roas_trend_status,
        d.overall_performance_watch_status
    FROM campaign_monitoring_dashboard_summary d
    LEFT JOIN campaign_kpi_summary k
        ON d.campaign_id = k.campaign_id
),
flags AS (
    SELECT
        *,
        CASE WHEN total_spend > 100 AND total_conversions = 0 THEN 1 ELSE 0 END AS high_spend_zero_conversion_flag,
        CASE WHEN overall_roas < target_roas AND target_roas > 0 THEN 1 ELSE 0 END AS roas_below_target_flag,
        CASE WHEN overall_cpa > target_cpa AND target_cpa > 0 THEN 1 ELSE 0 END AS cpa_above_target_flag,
        CASE WHEN overall_ctr < target_ctr AND target_ctr > 0 THEN 1 ELSE 0 END AS ctr_below_target_flag,
        CASE WHEN budget_pacing_status IN ('Overspending', 'Critical Overspend') THEN 1 ELSE 0 END AS budget_overspend_flag,
        CASE WHEN budget_pacing_status IN ('Underspending', 'Critical Underspend') THEN 1 ELSE 0 END AS budget_underspend_flag,
        CASE WHEN spend_trend_status = 'Spend Spike' THEN 1 ELSE 0 END AS spend_spike_flag,
        CASE WHEN traffic_trend_status = 'Traffic Drop' THEN 1 ELSE 0 END AS traffic_drop_flag,
        CASE WHEN conversion_trend_status = 'Conversion Drop' THEN 1 ELSE 0 END AS conversion_drop_flag,
        CASE WHEN roas_trend_status = 'ROAS Drop' THEN 1 ELSE 0 END AS roas_drop_flag,
        CASE WHEN campaign_status = 'Active' AND total_impressions = 0 THEN 1 ELSE 0 END AS no_impressions_active_campaign_flag,
        CASE WHEN total_spend > total_revenue AND total_spend > 0 THEN 1 ELSE 0 END AS poor_efficiency_flag
    FROM base
),
counts AS (
    SELECT
        *,
        high_spend_zero_conversion_flag
        + roas_below_target_flag
        + cpa_above_target_flag
        + ctr_below_target_flag
        + budget_overspend_flag
        + budget_underspend_flag
        + spend_spike_flag
        + traffic_drop_flag
        + conversion_drop_flag
        + roas_drop_flag
        + no_impressions_active_campaign_flag
        + poor_efficiency_flag AS anomaly_count,
        high_spend_zero_conversion_flag
        + no_impressions_active_campaign_flag
        + CASE WHEN budget_overspend_flag = 1 AND budget_pacing_status = 'Critical Overspend' THEN 1 ELSE 0 END
        + CASE WHEN roas_below_target_flag = 1 AND overall_roas = 0 THEN 1 ELSE 0 END AS critical_anomaly_count,
        roas_below_target_flag
        + cpa_above_target_flag
        + budget_overspend_flag
        + roas_drop_flag
        + conversion_drop_flag AS high_anomaly_count,
        ctr_below_target_flag
        + budget_underspend_flag
        + spend_spike_flag
        + traffic_drop_flag
        + poor_efficiency_flag AS medium_anomaly_count,
        0 AS low_anomaly_count
    FROM flags
)
SELECT * FROM counts;

-- Readable alert summary with severity and recommended actions.
CREATE TABLE campaign_alert_summary AS
WITH categorized AS (
    SELECT
        *,
        CASE
            WHEN high_spend_zero_conversion_flag = 1 THEN 'High Spend Zero Conversion'
            WHEN no_impressions_active_campaign_flag = 1 THEN 'No Impressions Active Campaign'
            WHEN budget_overspend_flag = 1 AND budget_pacing_status = 'Critical Overspend' THEN 'Critical Budget Overspend'
            WHEN roas_below_target_flag = 1 THEN 'ROAS Below Target'
            WHEN cpa_above_target_flag = 1 THEN 'CPA Above Target'
            WHEN conversion_drop_flag = 1 THEN 'Conversion Drop'
            WHEN roas_drop_flag = 1 THEN 'ROAS Drop'
            WHEN budget_overspend_flag = 1 THEN 'Budget Overspend'
            WHEN budget_underspend_flag = 1 THEN 'Budget Underspend'
            WHEN spend_spike_flag = 1 THEN 'Spend Spike'
            WHEN traffic_drop_flag = 1 THEN 'Traffic Drop'
            WHEN ctr_below_target_flag = 1 THEN 'CTR Below Target'
            WHEN poor_efficiency_flag = 1 THEN 'Poor Efficiency'
            ELSE 'No Alert'
        END AS primary_alert_category
    FROM campaign_anomaly_detection
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
    latest_metric_date,
    total_spend,
    total_conversions,
    total_revenue,
    overall_ctr,
    overall_cpa,
    overall_roas,
    budget_pacing_status,
    budget_risk_level,
    overall_performance_watch_status,
    anomaly_count,
    critical_anomaly_count,
    high_anomaly_count,
    medium_anomaly_count,
    low_anomaly_count,
    CASE WHEN anomaly_count > 0 THEN 1 ELSE 0 END AS alert_required,
    CASE
        WHEN critical_anomaly_count >= 1 THEN 'Critical'
        WHEN high_anomaly_count >= 2 THEN 'High'
        WHEN high_anomaly_count = 1 AND medium_anomaly_count >= 1 THEN 'High'
        WHEN high_anomaly_count = 1 THEN 'Medium'
        WHEN medium_anomaly_count >= 2 THEN 'Medium'
        WHEN medium_anomaly_count = 1 THEN 'Low'
        WHEN anomaly_count = 0 THEN 'No Alert'
        ELSE 'No Alert'
    END AS alert_severity,
    primary_alert_category,
    CASE primary_alert_category
        WHEN 'High Spend Zero Conversion' THEN 'Campaign has high spend but zero conversions.'
        WHEN 'No Impressions Active Campaign' THEN 'Active campaign has no impressions.'
        WHEN 'Critical Budget Overspend' THEN 'Campaign is critically overspending compared with expected budget pacing.'
        WHEN 'ROAS Below Target' THEN 'Campaign ROAS is below target.'
        WHEN 'CPA Above Target' THEN 'Campaign CPA is above target.'
        WHEN 'Conversion Drop' THEN 'Campaign conversions dropped compared with 7-day average.'
        WHEN 'ROAS Drop' THEN 'Campaign ROAS dropped compared with 7-day average.'
        WHEN 'Budget Overspend' THEN 'Campaign is overspending compared with expected budget pacing.'
        WHEN 'Budget Underspend' THEN 'Campaign is underspending compared with expected budget pacing.'
        WHEN 'Spend Spike' THEN 'Campaign spend increased sharply compared with 7-day average.'
        WHEN 'Traffic Drop' THEN 'Campaign traffic dropped compared with 7-day average.'
        WHEN 'CTR Below Target' THEN 'Campaign CTR is below target.'
        WHEN 'Poor Efficiency' THEN 'Campaign spend is higher than attributed revenue.'
        ELSE 'No major campaign alert detected.'
    END AS alert_message,
    CASE primary_alert_category
        WHEN 'High Spend Zero Conversion' THEN 'Review targeting, landing page, and conversion tracking immediately.'
        WHEN 'No Impressions Active Campaign' THEN 'Check campaign delivery, platform status, and budget settings.'
        WHEN 'Critical Budget Overspend' THEN 'Reduce spend or review budget allocation.'
        WHEN 'ROAS Below Target' THEN 'Review bid strategy, audience quality, and creative performance.'
        WHEN 'CPA Above Target' THEN 'Review conversion quality, bid strategy, and landing page performance.'
        WHEN 'Conversion Drop' THEN 'Review conversion tracking, landing page, and recent campaign changes.'
        WHEN 'ROAS Drop' THEN 'Review revenue attribution, bids, and audience quality.'
        WHEN 'Budget Overspend' THEN 'Review budget allocation and daily spend controls.'
        WHEN 'Budget Underspend' THEN 'Check delivery constraints, bids, audience size, and budget settings.'
        WHEN 'Spend Spike' THEN 'Review recent bid, budget, and audience changes.'
        WHEN 'Traffic Drop' THEN 'Check delivery, bids, creative approvals, and targeting.'
        WHEN 'CTR Below Target' THEN 'Review creative relevance, keywords, and audience targeting.'
        WHEN 'Poor Efficiency' THEN 'Review campaign economics before increasing spend.'
        ELSE 'No action required.'
    END AS recommended_action
FROM categorized;

-- Campaign health score from KPI, budget, trend, and anomaly signals.
CREATE TABLE campaign_health_score AS
WITH adjustments AS (
    SELECT
        a.campaign_id,
        a.campaign_name,
        a.platform_name,
        a.platform_category,
        a.country,
        a.region_name,
        a.business_unit,
        a.campaign_type,
        a.campaign_objective,
        a.campaign_status,
        a.latest_metric_date,
        a.total_spend,
        a.total_revenue,
        a.overall_ctr,
        a.overall_cpa,
        a.overall_roas,
        a.budget_pacing_status,
        a.budget_risk_level,
        a.overall_performance_watch_status,
        a.anomaly_count,
        s.alert_required,
        s.alert_severity,
        s.primary_alert_category,
        s.recommended_action,
        100 AS base_score,
        -1 * (
            CASE WHEN a.roas_below_target_flag = 1 THEN 20 ELSE 0 END
            + CASE WHEN a.cpa_above_target_flag = 1 THEN 15 ELSE 0 END
            + CASE WHEN a.ctr_below_target_flag = 1 THEN 10 ELSE 0 END
            + CASE WHEN a.poor_efficiency_flag = 1 THEN 15 ELSE 0 END
        ) AS kpi_score_adjustment,
        -1 * (
            CASE WHEN a.budget_pacing_status = 'Critical Overspend' THEN 20 ELSE 0 END
            + CASE WHEN a.budget_pacing_status = 'Overspending' THEN 15 ELSE 0 END
            + CASE WHEN a.budget_pacing_status = 'Critical Underspend' THEN 10 ELSE 0 END
            + CASE WHEN a.budget_pacing_status = 'Underspending' THEN 5 ELSE 0 END
        ) AS budget_score_adjustment,
        -1 * (
            CASE WHEN a.conversion_drop_flag = 1 THEN 15 ELSE 0 END
            + CASE WHEN a.roas_drop_flag = 1 THEN 15 ELSE 0 END
            + CASE WHEN a.traffic_drop_flag = 1 THEN 10 ELSE 0 END
            + CASE WHEN a.spend_spike_flag = 1 THEN 10 ELSE 0 END
        ) AS trend_score_adjustment,
        -1 * (
            CASE WHEN a.high_spend_zero_conversion_flag = 1 THEN 25 ELSE 0 END
            + CASE WHEN a.no_impressions_active_campaign_flag = 1 THEN 25 ELSE 0 END
            + (5 * a.anomaly_count)
        ) AS anomaly_score_adjustment
    FROM campaign_anomaly_detection a
    LEFT JOIN campaign_alert_summary s
        ON a.campaign_id = s.campaign_id
),
scored AS (
    SELECT
        *,
        base_score
        + kpi_score_adjustment
        + budget_score_adjustment
        + trend_score_adjustment
        + anomaly_score_adjustment AS raw_health_score
    FROM adjustments
),
capped AS (
    SELECT
        *,
        CASE
            WHEN raw_health_score < 0 THEN 0
            WHEN raw_health_score > 100 THEN 100
            ELSE raw_health_score
        END AS final_health_score
    FROM scored
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
    latest_metric_date,
    total_spend,
    total_revenue,
    overall_ctr,
    overall_cpa,
    overall_roas,
    budget_pacing_status,
    budget_risk_level,
    overall_performance_watch_status,
    anomaly_count,
    alert_required,
    alert_severity,
    primary_alert_category,
    base_score,
    kpi_score_adjustment,
    budget_score_adjustment,
    trend_score_adjustment,
    anomaly_score_adjustment,
    final_health_score,
    CASE
        WHEN final_health_score < 40 THEN 'Critical'
        WHEN final_health_score >= 40 AND final_health_score < 65 THEN 'At Risk'
        WHEN final_health_score >= 65 AND final_health_score < 80 THEN 'Watch'
        WHEN final_health_score >= 80 THEN 'Healthy'
    END AS health_status,
    primary_alert_category AS main_issue,
    recommended_action
FROM capped;

-- Campaigns that require immediate attention.
CREATE TABLE critical_campaign_summary AS
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
    latest_metric_date,
    total_spend,
    total_revenue,
    overall_roas,
    budget_pacing_status,
    overall_performance_watch_status,
    anomaly_count,
    alert_severity,
    primary_alert_category,
    final_health_score,
    health_status,
    main_issue,
    recommended_action
FROM campaign_health_score
WHERE health_status IN ('Critical', 'At Risk')
   OR alert_severity IN ('Critical', 'High')
ORDER BY
    CASE WHEN health_status = 'Critical' THEN 1 ELSE 2 END,
    CASE WHEN alert_severity = 'Critical' THEN 1 ELSE 2 END,
    final_health_score ASC,
    total_spend DESC;

-- Map generated alert categories to configured alert rules where possible.
CREATE TABLE campaign_alert_rule_mapping AS
WITH alert_rule_names AS (
    SELECT
        s.*,
        CASE
            WHEN s.primary_alert_category = 'High Spend Zero Conversion' THEN 'High Spend Zero Conversion'
            WHEN s.primary_alert_category = 'ROAS Below Target' THEN 'ROAS Below Target'
            WHEN s.primary_alert_category = 'CPA Above Target' THEN 'CPA Above Target'
            WHEN s.primary_alert_category = 'CTR Below Target' THEN 'CTR Below Target'
            WHEN s.primary_alert_category IN ('Critical Budget Overspend', 'Budget Overspend') THEN 'Budget Overspend'
            WHEN s.primary_alert_category = 'Spend Spike' THEN 'Spend Spike'
            WHEN s.primary_alert_category = 'Traffic Drop' THEN 'Impression Drop'
            WHEN s.primary_alert_category = 'No Impressions Active Campaign' THEN 'No Impressions Active Campaign'
            ELSE s.primary_alert_category
        END AS mapped_rule_name
    FROM campaign_alert_summary s
    WHERE s.alert_required = 1
)
SELECT
    a.campaign_id,
    a.campaign_name,
    a.primary_alert_category,
    a.alert_severity,
    r.rule_name AS configured_rule_name,
    r.metric_name AS configured_metric_name,
    r.condition_type AS configured_condition_type,
    r.threshold_value AS configured_threshold_value,
    r.severity AS configured_severity,
    r.rule_description,
    CASE
        WHEN r.rule_name IS NULL THEN 'No Matching Rule Found'
        ELSE 'Mapped to Configured Rule'
    END AS rule_mapping_status
FROM alert_rule_names a
LEFT JOIN stg_campaign_alert_rules r
    ON a.mapped_rule_name = r.rule_name;
