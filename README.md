GA4 ANALYTICS WAREHOUSE WITH DBT, AIRFLOW, BIGQUERY, AND POWER BI

End-to-end analytics warehouse project built on top of Google Analytics event data using BigQuery, dbt, Apache Airflow, and Power BI.

The project transforms raw event-level data into structured analytical models for session analysis, channel performance, funnel monitoring, and executive KPI reporting. The warehouse is organized around a session-level fact model, supporting dimensions, KPI aggregations, operational monitoring models, and documented lineage from source to dashboard.

TECHNOLOGY STACK

WAREHOUSE AND TRANSFORMATION

Google BigQuery
dbt
SQL

PIPELINE ORCHESTRATION

Apache Airflow

VISUALIZATION

Power BI

ENGINEERING COMPONENTS

Dimensional modeling
Automated data testing
Anomaly monitoring
Data lineage documentation
Dashboard exposure tracking

PROJECT OVERVIEW

Google Analytics exports user activity as raw event-level data. Each record represents an individual interaction such as a page view, product interaction, cart action, or purchase event, along with device, traffic, and geographic attributes.

This raw structure is rich but too granular for direct business reporting. The project builds an analytics warehouse that converts event data into a structured analytical layer suitable for:

Session-level behavior analysis
Executive KPI reporting
Channel attribution analysis
Funnel monitoring
Operational data validation

The result is a warehouse that organizes raw telemetry into reusable analytical models and dashboard-ready KPI datasets.

SYSTEM ARCHITECTURE

GA4 EVENT DATA IN BIGQUERY
↓
STG_EVENTS
↓
FACT_SESSIONS
↓
DIM_DATE / DIM_DEVICE / DIM_GEO / DIM_TRAFFIC
↓
KPI_DAILY_OVERVIEW / KPI_CHANNEL_DAILY / KPI_FUNNEL_DAILY
↓
OPS_DAILY_HEALTH / ANOMALY_SESSIONS_DROP_LAST_DAY
↓
EXECUTIVE_KPI_DASHBOARD

This structure separates the warehouse into clear layers.

SOURCE / STAGING
Standardize and prepare raw event data

FACT
Model core session-level behavior

DIMENSIONS
Add reusable descriptive context

KPI
Aggregate reporting metrics

OPS
Monitor warehouse health and anomalies

EXPOSURE
Track dashboard dependency on warehouse models

DATA WAREHOUSE DESIGN

The warehouse is centered around session-level modeling.

Raw event records are first standardized, then consolidated into a core fact table representing session behavior. That fact model is enriched through dimensions and then aggregated into KPI datasets used by the reporting layer.

This design supports a clean separation between:

Low-level event preparation
Core warehouse modeling
Business-facing metric aggregation
Operational monitoring

CORE MODELS

STG_EVENTS

This model standardizes the event source and prepares it for downstream warehouse transformations.

Its role in the warehouse is to isolate source-level cleanup and normalization before analytical modeling begins.

FACT_SESSIONS

This is the central fact model in the warehouse.

GRAIN: ONE ROW PER SESSION

The model consolidates event-level records into a session-level analytical table and supports metrics such as:

Session timing
Event volume
Engagement behavior
Conversion behavior
Revenue behavior
Device context
Geography context
Traffic attribution context

This model forms the analytical backbone of the warehouse and is the main source for KPI aggregation.

DIMENSION MODELS

DIM_DATE
Provides calendar context for time-based analysis.

DIM_DEVICE
Provides device segmentation for session and revenue analysis.

DIM_GEO
Provides geographic context for regional analysis.

DIM_TRAFFIC
Provides traffic attribution context for source / channel analysis.

These dimensions separate reusable descriptive attributes from the core behavioral fact table and support more consistent reporting across KPI models.

KPI MODELS

The warehouse includes dedicated KPI aggregation models.

KPI_DAILY_OVERVIEW
Aggregates daily executive-level metrics.

KPI_CHANNEL_DAILY
Aggregates metrics by channel for marketing performance analysis.

KPI_FUNNEL_DAILY
Aggregates funnel-stage behavior for conversion analysis.

These KPI models provide reporting-ready outputs rather than requiring the dashboard to compute business logic directly from lower-level warehouse tables.

OPERATIONAL MONITORING MODELS

OPS_DAILY_HEALTH
Supports warehouse health monitoring.

ANOMALY_SESSIONS_DROP_LAST_DAY
Detects unusual session drops.

These models extend the warehouse beyond transformation and reporting by adding monitoring logic directly to the analytical environment.

DATA QUALITY AND VALIDATION

The project includes 57 dbt tests.

These tests validate the reliability of the warehouse models through checks such as:

Structural integrity
Key validity
Relationship consistency
Analytical rule enforcement

The test layer helps ensure that modeled outputs remain trustworthy as transformations evolve.

DATA LINEAGE AND DOCUMENTATION

dbt documentation is generated for the project, including model lineage from source through analytical outputs.

The lineage graph shows the full dependency flow across:

Source event preparation
Session fact modeling
Dimensional enrichment
KPI aggregation
Operational models
Dashboard exposure

This makes it possible to trace how business-facing metrics are derived from the underlying warehouse models.

INSERT IMAGE HERE

dbt_lineage.png

PIPELINE ORCHESTRATION

The transformation workflow is orchestrated with Apache Airflow.

The Airflow DAG coordinates warehouse execution and shows successful pipeline completion across the transformation process.

This establishes a clear separation between:

Transformation logic in dbt
Execution scheduling and pipeline control in Airflow

INSERT IMAGE HERE

airflow_dag.png

POWER BI DASHBOARD

The warehouse feeds a multi-page Power BI dashboard built on top of the modeled KPI layer.

EXECUTIVE OVERVIEW

This page presents high-level business metrics such as revenue, sessions, users, conversion performance, and related trend views.

INSERT IMAGE HERE

dashboard_exec.png

CHANNEL PERFORMANCE

This page focuses on traffic and channel analysis, supporting comparison of channel contribution and performance.

INSERT IMAGE HERE

dashboard_channels.png

FUNNEL ANALYSIS

This page focuses on conversion funnel behavior, helping identify stage-level progression and drop-off patterns.

INSERT IMAGE HERE

dashboard_funnel.png

WAREHOUSE MODELING APPROACH

This project applies core data warehousing principles.

SESSION-LEVEL FACT MODELING

Raw event data is too granular for most KPI reporting. Modeling behavior at the session level creates a more stable and more useful analytical grain.

DIMENSIONAL ENRICHMENT

Date, device, geography, and traffic are modeled separately so that reporting can reuse a consistent analytical context across different KPI outputs.

KPI AGGREGATION IN THE WAREHOUSE

Metrics are aggregated into dedicated models before reaching the BI layer, keeping business logic in the warehouse rather than spreading it across dashboard visuals.

OPERATIONAL VISIBILITY

The project includes health and anomaly models so that warehouse quality is monitored alongside metric production.

LINEAGE-AWARE ANALYTICS

dbt documentation makes dependencies visible from source to dashboard, improving transparency and maintainability.

WHAT THE PROJECT DEMONSTRATES

This repository demonstrates practical implementation of:

Analytics warehouse design
Event-to-session modeling
Fact and dimension modeling
KPI data mart construction
Automated testing with dbt
Documented lineage and exposure tracking
Pipeline orchestration with Airflow
BI delivery through Power BI

SUMMARY

This project implements an analytics warehouse that transforms raw GA4 event data in BigQuery into structured, tested, and documented analytical models.

The warehouse is built around a session-level fact table, supporting dimensions, KPI aggregations, operational monitoring models, and dashboard exposure. Combined with dbt lineage, automated testing, Airflow orchestration, and Power BI reporting, the project represents a complete end-to-end analytics workflow from raw event telemetry to business-facing insights.
