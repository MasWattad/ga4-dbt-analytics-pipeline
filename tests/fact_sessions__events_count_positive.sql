select *
from {{ ref('fact_sessions') }}
where events_count <= 0