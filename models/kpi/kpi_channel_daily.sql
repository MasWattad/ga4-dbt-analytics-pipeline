{{ config(materialized='table') }}

with base as (
  select
    session_date as date_day,
    coalesce(traffic_source, '(direct)') as traffic_source,
    coalesce(traffic_medium, '(none)') as traffic_medium,

    count(*) as sessions,
    count(distinct user_id) as users,
    sum(coalesce(session_revenue, 0)) as revenue,
    sum(coalesce(conversion_flag, 0)) as converting_sessions

  from {{ ref('fact_sessions') }}
  group by 1,2,3
)

select
  date_day,
  traffic_source,
  traffic_medium,
  concat(traffic_source, ' / ', traffic_medium) as source_medium,

  case
    when lower(traffic_medium) in ('cpc','ppc','paidsearch','paid search') then 'Paid Search'
    when lower(traffic_medium) in ('display','cpm','banner') then 'Display'
    when lower(traffic_medium) in ('paid social','paidsocial','social_paid','paid-social') then 'Paid Social'
    when lower(traffic_medium) in ('social','social-network','social media','sm') then 'Organic Social'
    when lower(traffic_medium) in ('email','e-mail') then 'Email'
    when lower(traffic_medium) = 'affiliate' then 'Affiliate'
    when lower(traffic_medium) = 'referral' then 'Referral'
    when lower(traffic_medium) in ('organic','organic search') then 'Organic Search'
    when traffic_source = '(direct)' or traffic_medium = '(none)' then 'Direct'
    else 'Other'
  end as channel,

  sessions,
  users,
  revenue,
  converting_sessions,

  current_timestamp() as loaded_at

from base