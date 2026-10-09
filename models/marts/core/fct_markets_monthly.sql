-- Wide monthly table: one row per month, one column per series.
-- Daily series use the monthly average, matching how Shiller reports the S&P 500.
{%- set cols = {
    'sp500': 'sp500_level', 'sp500_dividend': 'sp500_dividend_ttm', 'sp500_earnings': 'sp500_earnings_ttm',
    'cape': 'cape', 'vix': 'vix_avg', 'wti': 'wti_avg', 'brent': 'brent_avg', 'henry_hub': 'henry_hub_avg',
    'gold': 'gold_avg', 'ust10y': 'ust10y_pct', 'cpi': 'cpi_index'
} %}
select
    month_start,
    {%- for sid, col in cols.items() %}
    max(case when series_id = '{{ sid }}' then value_avg end) as {{ col }},
    {%- endfor %}
    max(case when series_id = 'vix' then value_high end)  as vix_high,
    max(case when series_id = 'wti' then value_close end) as wti_close
from {{ ref('fct_series_monthly') }}
group by month_start
having max(case when series_id = 'sp500' then 1 end) = 1
