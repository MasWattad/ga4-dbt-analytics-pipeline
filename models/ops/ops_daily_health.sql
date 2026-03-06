{{ config(materialized='table') }}

with last_day as (
  select max(session_date) as d
  from {{ ref('fact_sessions') }}
),
stats as (
  select
    session_date as date_day,
    count(*) as sessions,
    sum(session_revenue) as revenue,
    sum(conversion_flag) as converting_sessions
  from {{ ref('fact_sessions') }}
  group by 1
)

select
  current_timestamp() as recorded_at,
  (select d from last_day) as latest_data_day,
  (select sessions from stats where date_day = (select d from last_day)) as latest_day_sessions,
  (select revenue from stats where date_day = (select d from last_day)) as latest_day_revenue,
  (select converting_sessions from stats where date_day = (select d from last_day)) as latest_day_converting_sessions