# Final Validation Guide

## How To Run Final Validation

Run `sql/08_final_project_validation.sql` after SQL scripts `01` through `07`. Then run the validation files in the order listed in `run_order.md`.

## What Good Results Look Like

- Expected tables exist.
- Important output tables have rows.
- Row count comparisons return `Pass`.
- Metric reconciliations return `Pass`.
- Health scores stay between 0 and 100.
- Alert messages and recommended actions are populated.

## If A Query Returns Zero Rows

Zero rows can be good for checks that look for problems, such as null campaign IDs or invalid health scores. Read the query comment and column names before assuming it is an issue.

## If A Validation Check Returns Fail

Review the related upstream table, confirm the SQL scripts were run in order, and rerun the dependent script if needed.

## Manual Table Inspection

Open DB Browser for SQLite, browse each major table, and inspect row counts, sample records, status fields, and calculated metrics.
