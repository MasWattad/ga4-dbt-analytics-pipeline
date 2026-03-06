{{ config(materialized='table') }}

select
  session_date as date_day,

  device_category as device,
  country as country,

  coalesce(traffic_source, '(direct)') as traffic_source,
  coalesce(traffic_medium, '(none)') as traffic_medium,
  concat(
    coalesce(traffic_source, '(direct)'),
    ' / ',
    coalesce(traffic_medium, '(none)')
  ) as source_medium,

  case
    when lower(coalesce(traffic_medium, '(none)')) in ('cpc','ppc','paidsearch','paid search') then 'Paid Search'
    when lower(coalesce(traffic_medium, '(none)')) in ('display','cpm','banner') then 'Display'
    when lower(coalesce(traffic_medium, '(none)')) in ('paid social','paidsocial','social_paid','paid-social') then 'Paid Social'
    when lower(coalesce(traffic_medium, '(none)')) in ('social','social-network','social media','sm') then 'Organic Social'
    when lower(coalesce(traffic_medium, '(none)')) in ('email','e-mail') then 'Email'
    when lower(coalesce(traffic_medium, '(none)')) = 'affiliate' then 'Affiliate'
    when lower(coalesce(traffic_medium, '(none)')) = 'referral' then 'Referral'
    when lower(coalesce(traffic_medium, '(none)')) in ('organic','organic search') then 'Organic Search'
    when coalesce(traffic_source, '(direct)') = '(direct)' or coalesce(traffic_medium, '(none)') = '(none)' then 'Direct'
    else 'Other'
  end as channel,

  count(*) as sessions,
  count(distinct user_id) as users,
  sum(coalesce(session_revenue, 0)) as revenue,
  sum(coalesce(conversion_flag, 0)) as converting_sessions,

  current_timestamp() as loaded_at

from {{ ref('fact_sessions') }}
group by 1,2,3,4,5,6,7