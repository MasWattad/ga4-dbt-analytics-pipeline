{{ config(materialized='table') }}

with session_events as (
  select
    event_date as date_day,
    user_id,
    session_id,
    max(case when event_name = 'page_view' then 1 else 0 end) as did_page_view,
    max(case when event_name = 'add_to_cart' then 1 else 0 end) as did_add_to_cart,
    max(case when event_name = 'purchase' then 1 else 0 end) as did_purchase
  from {{ ref('stg_events') }}
  group by 1,2,3
),

daily as (
  select
    date_day,
    count(*) as sessions,
    sum(did_page_view) as sessions_with_page_view,
    sum(did_add_to_cart) as sessions_with_add_to_cart,
    sum(did_purchase) as sessions_with_purchase
  from session_events
  group by 1
)

select
  date_day,
  sessions,
  sessions_with_page_view,
  sessions_with_add_to_cart,
  sessions_with_purchase,

  safe_divide(sessions_with_add_to_cart, sessions_with_page_view) as add_to_cart_rate,
  safe_divide(sessions_with_purchase, sessions_with_add_to_cart) as purchase_rate,
  safe_divide(sessions_with_purchase, sessions) as overall_purchase_rate

from daily