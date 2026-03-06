{{ config(materialized='table') }}

WITH dates AS (
  SELECT DISTINCT session_date AS date_day
  FROM {{ ref('fact_sessions') }}
)

SELECT
  date_day,
  EXTRACT(YEAR FROM date_day) AS year,
  EXTRACT(MONTH FROM date_day) AS month,
  EXTRACT(DAY FROM date_day) AS day,
  EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week
FROM dates