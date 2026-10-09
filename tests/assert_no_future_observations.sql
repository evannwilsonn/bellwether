-- No observation may be dated after the load timestamp.
select series_id, observed_on
from {{ ref('fct_series_daily') }}
where observed_on > cast(current_timestamp as date)
