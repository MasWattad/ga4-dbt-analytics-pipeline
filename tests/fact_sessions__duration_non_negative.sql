select *
from {{ ref('fact_sessions') }}
where session_duration_seconds < 0