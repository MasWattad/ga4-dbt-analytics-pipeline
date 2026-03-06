with last_day as (
  select max(session_date) as d
  from {{ ref('fact_sessions') }}
),
daily as (
  select session_date, count(*) as sessions
  from {{ ref('fact_sessions') }}
  group by 1
),
baseline as (
  select avg(sessions) as avg_7d
  from daily
  join last_day on true
  where session_date between date_sub(last_day.d, interval 7 day) and date_sub(last_day.d, interval 1 day)
),
latest as (
  select sessions as latest_sessions
  from daily
  join last_day on daily.session_date = last_day.d
)
select *
from baseline, latest
where avg_7d is not null
  and latest_sessions < avg_7d * 0.20