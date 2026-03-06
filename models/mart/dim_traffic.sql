{{ config(materialized='table') }}

SELECT DISTINCT
  traffic_source,
  traffic_medium
FROM {{ ref('fact_sessions') }}
WHERE traffic_source IS NOT NULL
   OR traffic_medium IS NOT NULL