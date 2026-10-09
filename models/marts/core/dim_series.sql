-- Series catalog plus coverage: when each series starts, ends and how much history it has.
with coverage as (
    select
        series_id,
        min(month_start)       as first_month,
        max(month_start)       as last_month,
        max(last_observed_on)  as last_observed_on,
        count(*)               as months_of_history
    from {{ ref('int_series__monthly_long') }}
    group by 1
)

select
    s.series_id,
    s.series_name,
    s.unit,
    s.native_frequency,
    s.publisher,
    s.category,
    s.max_staleness_days,
    c.first_month,
    c.last_month,
    c.last_observed_on,
    c.months_of_history
from {{ ref('series') }} as s
left join coverage as c using (series_id)
