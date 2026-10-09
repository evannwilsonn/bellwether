-- The monthly "close" for a daily series must equal its last daily observation that month.
with last_daily as (
    select series_id, {{ month_start('observed_on') }} as month_start, max_by(value, observed_on) as last_value
    from {{ ref('fct_series_daily') }}
    group by 1, 2
)
select m.series_id, m.month_start, m.value_close, d.last_value
from {{ ref('fct_series_monthly') }} as m
join last_daily as d using (series_id, month_start)
where abs(m.value_close - d.last_value) > 1e-9
