{{ config(materialized='table') }}

SELECT DISTINCT
  device_category
FROM {{ ref('fact_sessions') }}
WHERE device_category IS NOT NULL