select *
from {{ ref('fact_sessions') }}
where conversion_flag not in (0, 1)