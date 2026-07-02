# Interview Explanation

## 30-Second Explanation

I built a SQL-first campaign monitoring engine in SQLite. It simulates campaign data, cleans it, calculates KPIs, monitors budget pacing, detects anomalies, generates alerts, and assigns campaign health scores.

## 2-Minute Explanation

The project starts with synthetic marketing campaign data and loads it into raw SQLite tables. I then created a staging layer with cleaning and quality flags, a KPI layer for metrics like CTR, CPC, CPA, ROAS, and AOV, and a monitoring layer for budget pacing and trend comparisons.

On top of that, I built SQL-based anomaly detection, alert severity, recommended actions, health scoring, and investigation scenarios. The project includes validation and reconciliation scripts so the pipeline can be reviewed end to end.

## Technical Explanation

The project demonstrates layered SQL modeling, window functions, CASE-based business rules, reconciliation checks, staged transformations, KPI calculations, alert rule mapping, and final validation. It uses SQLite-compatible SQL only.

## Business Explanation

The engine helps a marketing team identify overspend, underperformance, ROAS drops, conversion drops, delivery issues, and campaigns requiring immediate attention.

## Skills Demonstrated

- SQL data engineering
- Data modeling
- Data quality checks
- KPI design
- Window functions
- Budget pacing logic
- Alert generation
- Health score design
- Technical documentation

## Possible Interview Questions And Answers

**Why did you use SQLite?**  
To keep the project local, easy to run, and SQL-first for portfolio review.

**How do you avoid bad data disappearing?**  
The staging layer flags bad records instead of deleting them silently.

**How do you know the outputs are trustworthy?**  
The project includes validation, row count checks, metric reconciliation, and final pipeline checks.

**What would you add in production?**  
Real API ingestion, orchestration, a warehouse version, dashboards, alert notifications, and stronger testing.
