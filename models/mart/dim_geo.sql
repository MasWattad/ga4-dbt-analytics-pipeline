{{ config(materialized='table') }}

SELECT DISTINCT
  country
FROM {{ ref('fact_sessions') }}
WHERE country IS NOT NULL