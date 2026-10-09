-- Long-format monthly facts: one row per series per month.
select
    series_id,
    month_start,
    value_avg,
    value_close,
    value_low,
    value_high,
    observations,
    last_observed_on
from {{ ref('int_series__monthly_long') }}
