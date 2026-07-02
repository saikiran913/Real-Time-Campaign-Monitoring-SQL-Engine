# Project Story For Interviews

## Why This Project Was Built

This project was built to show how SQL can power a practical campaign monitoring workflow without relying on Python, cloud tools, or dashboards.

## Business Problem

Marketing teams need to know when campaigns overspend, underperform, lose traffic, stop converting, or require immediate review.

## Technical Approach

The project uses a layered SQLite design: raw data, staging, KPIs, monitoring, alerts, health scores, investigations, and final validation.

## How The Phases Connect

Each phase builds on the previous one. Raw data is cleaned in staging, staging feeds KPIs, KPIs feed monitoring, monitoring feeds alerts, and alerts feed health scores and investigations.

## Challenges Simulated

- High spend with zero conversions.
- ROAS and conversion drops.
- Budget pacing issues.
- Traffic and CTR problems.
- Campaign delivery issues.

## What The Final Outputs Show

The final outputs show campaign performance, budget pacing, alert severity, recommended actions, health status, and priority campaigns for review.

## Production Extensions

In production, this could be extended with real API ingestion, scheduled orchestration, a warehouse version, dashboards, and notification workflows.
