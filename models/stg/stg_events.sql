with source_events as (

    select
        parse_date('%Y%m%d', event_date) as event_date,
        timestamp_micros(event_timestamp) as event_ts,
        user_pseudo_id as user_id,
        event_name,

        (
            select value.int_value
            from unnest(event_params)
            where key = 'ga_session_id'
        ) as session_id,

        (
            select value.string_value
            from unnest(event_params)
            where key = 'transaction_id'
        ) as transaction_id,

        (
            select value.int_value
            from unnest(event_params)
            where key = 'engagement_time_msec'
        ) as engagement_time_msec,

        (
            select value.string_value
            from unnest(event_params)
            where key = 'page_location'
        ) as page_location,

        geo.country as country,
        device.category as device_category,
        traffic_source.source as traffic_source,
        traffic_source.medium as traffic_medium,

        ecommerce.purchase_revenue as revenue

    from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

),

clean_events as (

    select
        event_date,
        event_ts,
        user_id,
        session_id,
        event_name,
        transaction_id,
        engagement_time_msec,
        page_location,
        country,
        device_category,
        traffic_source,
        traffic_medium,
        coalesce(revenue, 0) as revenue

    from source_events
    where session_id is not null

)

select *
from clean_events