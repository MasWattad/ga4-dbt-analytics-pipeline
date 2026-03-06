<div align="center">

# GA4 Analytics Warehouse
### dbt · BigQuery · Apache Airflow · Power BI

*End-to-end analytics warehouse project built on top of Google Analytics event data using BigQuery, dbt, Apache Airflow, and Power BI.*

The project transforms raw event-level data into structured analytical models for session analysis, channel performance, funnel monitoring, and executive KPI reporting. The warehouse is organized around a session-level fact model, supporting dimensions, KPI aggregations, operational monitoring models, and documented lineage from source to dashboard.

</div>

---

## 🗂 Technology Stack

| Category | Tools |
|---|---|
| **Warehouse & Transformation** | Google BigQuery · dbt · SQL |
| **Pipeline Orchestration** | Apache Airflow |
| **Visualization** | Power BI |
| **Engineering Components** | Dimensional modeling · Automated data testing · Anomaly monitoring · Data lineage documentation · Dashboard exposure tracking |

---

## 📌 Project Overview

Google Analytics exports user activity as raw event-level data. Each record represents an individual interaction such as a page view, product interaction, cart action, or purchase event, along with device, traffic, and geographic attributes.

This raw structure is rich but too granular for direct business reporting. The project builds an analytics warehouse that converts event data into a structured analytical layer suitable for:

- session-level behavior analysis
- executive KPI reporting
- channel attribution analysis
- funnel monitoring
- operational data validation

The result is a warehouse that organizes raw telemetry into reusable analytical models and dashboard-ready KPI datasets.

---

## 🏗 System Architecture

```
GA4 Event Data in BigQuery
          ↓
      stg_events
          ↓
     fact_sessions
          ↓
dim_date / dim_device / dim_geo / dim_traffic
          ↓
kpi_daily_overview / kpi_channel_daily / kpi_funnel_daily
          ↓
ops_daily_health / anomaly_sessions_drop_last_day
          ↓
executive_kpi_dashboard
```

This structure separates the warehouse into clear layers.

| Layer | Purpose |
|---|---|
| Source / staging | Standardize and prepare raw event data |
| Fact | Model core session-level behavior |
| Dimensions | Add reusable descriptive context |
| KPI | Aggregate reporting metrics |
| Ops | Monitor warehouse health and anomalies |
| Exposure | Track dashboard dependency on warehouse models |

---

## 🧱 Data Warehouse Design

The warehouse is centered around session-level modeling.

Raw event records are first standardized, then consolidated into a core fact table representing session behavior. That fact model is enriched through dimensions and then aggregated into KPI datasets used by the reporting layer.

This design supports a clean separation between:

- low-level event preparation
- core warehouse modeling
- business-facing metric aggregation
- operational monitoring

---

## 🔩 Core Models

### `stg_events`

This model standardizes the event source and prepares it for downstream warehouse transformations.

Its role in the warehouse is to isolate source-level cleanup and normalization before analytical modeling begins.

### `fact_sessions`

This is the central fact model in the warehouse.

> **Grain:** one row per session

The model consolidates event-level records into a session-level analytical table and supports metrics such as:

- session timing
- event volume
- engagement behavior
- conversion behavior
- revenue behavior
- device context
- geography context
- traffic attribution context

This model forms the analytical backbone of the warehouse and is the main source for KPI aggregation.

---

## 📐 Dimension Models

| Model | Purpose |
|---|---|
| `dim_date` | Provides calendar context for time-based analysis |
| `dim_device` | Provides device segmentation for session and revenue analysis |
| `dim_geo` | Provides geographic context for regional analysis |
| `dim_traffic` | Provides traffic attribution context for source / channel analysis |

These dimensions separate reusable descriptive attributes from the core behavioral fact table and support more consistent reporting across KPI models.

---

## 📊 KPI Models

The warehouse includes dedicated KPI aggregation models.

| Model | Purpose |
|---|---|
| `kpi_daily_overview` | Aggregates daily executive-level metrics |
| `kpi_channel_daily` | Aggregates metrics by channel for marketing performance analysis |
| `kpi_funnel_daily` | Aggregates funnel-stage behavior for conversion analysis |

These KPI models provide reporting-ready outputs rather than requiring the dashboard to compute business logic directly from lower-level warehouse tables.

---

## 🔍 Operational Monitoring Models

The project includes dedicated operational models.

| Model | Purpose |
|---|---|
| `ops_daily_health` | Supports warehouse health monitoring |
| `anomaly_sessions_drop_last_day` | Detects unusual session drops |

These models extend the warehouse beyond transformation and reporting by adding monitoring logic directly to the analytical environment.

---

## ✅ Data Quality and Validation

The project includes **57 dbt tests**.

These tests validate the reliability of the warehouse models through checks such as:

- structural integrity
- key validity
- relationship consistency
- analytical rule enforcement

The test layer helps ensure that modeled outputs remain trustworthy as transformations evolve.

---

## 🔗 Data Lineage and Documentation

dbt documentation is generated for the project, including model lineage from source through analytical outputs.

The lineage graph shows the full dependency flow across:

- source event preparation
- session fact modeling
- dimensional enrichment
- KPI aggregation
- operational models
- dashboard exposure

This makes it possible to trace how business-facing metrics are derived from the underlying warehouse models.

<div align="center">

![dbt Lineage Graph](images/dbt_lineage.png)
*dbt Lineage Graph — full dependency flow from source to dashboard*

</div>

---

## ⚙️ Pipeline Orchestration

The transformation workflow is orchestrated with Apache Airflow.

The Airflow DAG coordinates warehouse execution and shows successful pipeline completion across the transformation process.

This establishes a clear separation between:

- transformation logic in dbt
- execution scheduling and pipeline control in Airflow

<div align="center">

![Airflow DAG](images/airflow_dag.png)
*Airflow DAG — successful pipeline completion across the transformation process*

</div>

---

## 📡 Dashboard Exposure

The project includes a dbt exposure:

**`executive_kpi_dashboard`**

This connects the modeled warehouse outputs to the reporting layer and documents the dependency between transformation models and dashboard consumption.

---

## 📈 Power BI Dashboard

The warehouse feeds a multi-page Power BI dashboard built on top of the modeled KPI layer.

### Executive Overview

This page presents high-level business metrics such as revenue, sessions, users, conversion performance, and related trend views.

<div align="center">

![Executive Overview Dashboard](images/dashboard_exec.png)
*Executive Overview — revenue, sessions, users, and conversion performance*

</div>

### Channel Performance

This page focuses on traffic and channel analysis, supporting comparison of channel contribution and performance.

<div align="center">

![Channel Performance Dashboard](images/dashboard_channels.png)
*Channel Performance — traffic and channel contribution analysis*

</div>

### Funnel Analysis

This page focuses on conversion funnel behavior, helping identify stage-level progression and drop-off patterns.

<div align="center">

![Funnel Analysis Dashboard](images/dashboard_funnel.png)
*Funnel Analysis — stage-level progression and drop-off patterns*

</div>

---

## 💡 Warehouse Modeling Approach

This project applies core data warehousing principles.

**Session-level fact modeling**
Raw event data is too granular for most KPI reporting. Modeling behavior at the session level creates a more stable and more useful analytical grain.

**Dimensional enrichment**
Date, device, geography, and traffic are modeled separately so that reporting can reuse a consistent analytical context across different KPI outputs.

**KPI aggregation in the warehouse**
Metrics are aggregated into dedicated models before reaching the BI layer, keeping business logic in the warehouse rather than spreading it across dashboard visuals.

**Operational visibility**
The project includes health and anomaly models so that warehouse quality is monitored alongside metric production.

**Lineage-aware analytics**
dbt documentation makes dependencies visible from source to dashboard, improving transparency and maintainability.

---

## 🎯 What the Project Demonstrates

This repository demonstrates practical implementation of:

- analytics warehouse design
- event-to-session modeling
- fact and dimension modeling
- KPI data mart construction
- automated testing with dbt
- documented lineage and exposure tracking
- pipeline orchestration with Airflow
- BI delivery through Power BI

---

## 📝 Summary

This project implements an analytics warehouse that transforms raw GA4 event data in BigQuery into structured, tested, and documented analytical models.

The warehouse is built around a session-level fact table, supporting dimensions, KPI aggregations, operational monitoring models, and dashboard exposure. Combined with dbt lineage, automated testing, Airflow orchestration, and Power BI reporting, the project represents a complete end-to-end analytics workflow from raw event telemetry to business-facing insights.
