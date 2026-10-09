-- Every series at month grain. Daily series are rolled up (average, month-end close,
-- low, high, trading days); monthly series pass through with one observation.
with daily_rollup as (
    select
        series_id,
        {{ month_start('observed_on') }}   as month_start,
        avg(value)                         as value_avg,
        max_by(value, observed_on)         as value_close,
        min(value)                         as value_low,
        max(value)                         as value_high,
        count(*)                           as observations,
        max(observed_on)                   as last_observed_on
    from {{ ref('int_series__daily_long') }}
    group by 1, 2
),

monthly_native as (
    select 'sp500' as series_id, month_start, sp500_level as value from {{ ref('stg_datahub__sp500_monthly') }}
    union all
    select 'sp500_dividend', month_start, dividend_ttm from {{ ref('stg_datahub__sp500_monthly') }}
    union all
    select 'sp500_earnings', month_start, earnings_ttm from {{ ref('stg_datahub__sp500_monthly') }}
    union all
    select 'cape', month_start, cape from {{ ref('stg_datahub__sp500_monthly') }}
    union all
    select 'gold', month_start, gold_usd_oz from {{ ref('stg_datahub__gold_monthly') }}
    union all
    select 'ust10y', month_start, ust10y_pct from {{ ref('stg_datahub__ust10y_monthly') }}
    union all
    select 'cpi', month_start, cpi_index from {{ ref('stg_datahub__cpi_monthly') }}
)

select * from daily_rollup
union all
select
    series_id,
    month_start,
    value as value_avg,
    value as value_close,
    value as value_low,
    value as value_high,
    1 as observations,
    month_start as last_observed_on
from monthly_native
where value is not null
