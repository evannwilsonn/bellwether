-- Daily observations with the change from the prior trading day.
select
    series_id,
    observed_on,
    value,
    value - lag(value) over (partition by series_id order by observed_on) as change_1d
from {{ ref('int_series__daily_long') }}
