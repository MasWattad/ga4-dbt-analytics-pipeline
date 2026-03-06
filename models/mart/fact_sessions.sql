{{ config(materialized='table') }}

WITH events AS (
    SELECT
        user_id,
        session_id,
        event_ts,
        event_name,

        COALESCE(engagement_time_msec, 0) AS engagement_time_msec,

        transaction_id,
        COALESCE(revenue, 0) AS revenue,

        traffic_source,
        traffic_medium,
        device_category,
        country

    FROM {{ ref('stg_events') }}
    WHERE session_id IS NOT NULL
),

session_bounds AS (
    SELECT
        user_id,
        session_id,
        MIN(event_ts) AS session_start_ts,
        MAX(event_ts) AS session_end_ts,
        DATE(MIN(event_ts)) AS session_date
    FROM events
    GROUP BY 1,2
),

session_metrics AS (
    SELECT
        user_id,
        session_id,
        COUNT(*) AS events_count,
        SUM(engagement_time_msec) AS engagement_time_msec,
        MAX(CASE WHEN transaction_id IS NOT NULL THEN 1 ELSE 0 END) AS conversion_flag
    FROM events
    GROUP BY 1,2
),

session_revenue AS (
    -- dedupe by transaction_id within session
    SELECT
        user_id,
        session_id,
        SUM(txn_revenue) AS session_revenue
    FROM (
        SELECT
            user_id,
            session_id,
            transaction_id,
            MAX(revenue) AS txn_revenue
        FROM events
        WHERE transaction_id IS NOT NULL
        GROUP BY 1,2,3
    )
    GROUP BY 1,2
),

session_attrs AS (
    SELECT
        user_id,
        session_id,
        ARRAY_AGG(traffic_source IGNORE NULLS ORDER BY event_ts ASC LIMIT 1)[OFFSET(0)] AS traffic_source,
        ARRAY_AGG(traffic_medium IGNORE NULLS ORDER BY event_ts ASC LIMIT 1)[OFFSET(0)] AS traffic_medium,
        ARRAY_AGG(device_category IGNORE NULLS ORDER BY event_ts ASC LIMIT 1)[OFFSET(0)] AS device_category,
        ARRAY_AGG(country        IGNORE NULLS ORDER BY event_ts ASC LIMIT 1)[OFFSET(0)] AS country
    FROM events
    GROUP BY 1,2
)

SELECT
    b.user_id,
    b.session_id,
    b.session_date,

    b.session_start_ts,
    b.session_end_ts,
    TIMESTAMP_DIFF(b.session_end_ts, b.session_start_ts, SECOND) AS session_duration_seconds,

    m.events_count,
    m.engagement_time_msec,
    SAFE_DIVIDE(m.engagement_time_msec, 1000) AS engagement_time_seconds,

    COALESCE(r.session_revenue, 0) AS session_revenue,
    m.conversion_flag,

    a.traffic_source,
    a.traffic_medium,
    a.device_category,
    a.country

FROM session_bounds b
JOIN session_metrics m USING (user_id, session_id)
LEFT JOIN session_revenue r USING (user_id, session_id)
LEFT JOIN session_attrs a USING (user_id, session_id)