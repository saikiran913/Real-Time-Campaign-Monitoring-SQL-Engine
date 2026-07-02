# Final Project Walkthrough

## Complete Walkthrough

This project starts with synthetic campaign data and ends with campaign alerts, health scores, and investigation scenarios.

## Phase 1

Creates raw tables, synthetic CSV datasets, insert scripts, and starter validation.

## Phase 2

Creates staging tables with cleaning, standardization, and data quality flags. Bad rows are flagged rather than removed silently.

## Phase 3

Creates KPI facts and summaries for campaigns, platforms, regions, dates, and hours.

## Phase 4

Creates budget pacing and performance monitoring tables using cumulative spend, projected spend, previous-day comparisons, and 7-day averages.

## Phase 5

Creates anomaly flags, alert summaries, recommended actions, health scores, critical campaign summaries, and investigation scenarios.

## Phase 6

Adds final validation, sample output queries, documentation polish, and GitHub-ready project packaging.

## Folder Guide

- `data/raw/`: synthetic source CSV files.
- `sql/`: numbered SQL pipeline scripts.
- `validation/`: quality, reconciliation, and final validation checks.
- `investigations/`: business issue investigation queries.
- `docs/`: architecture, walkthroughs, and interview guidance.
- `data/sample_outputs/`: demo output queries.

## Recommended Review Order

Read the README, run the SQL scripts in order, run validation, review sample outputs, then run investigation scenarios.

## How To Explain The Project

Explain it as a SQL analytics engine that turns raw campaign data into clean staged data, KPIs, pacing insights, alerts, and health scores.
