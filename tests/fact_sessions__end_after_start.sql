select *
from {{ ref('fact_sessions') }}
where session_end_ts < session_start_ts