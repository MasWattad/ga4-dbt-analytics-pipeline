select *
from {{ ref('fact_sessions') }}
where session_revenue < 0