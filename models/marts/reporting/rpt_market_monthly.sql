-- Monthly market and macro scorecard since {{ var('report_start') }}.
-- Returns, drawdowns and valuation are computed over the full history first,
-- then trimmed, so the first reported months still see a proper look-back.
with m as (
    select * from {{ ref('fct_markets_monthly') }}
),

latest_cpi as (
    select max_by(cpi_index, month_start) as cpi_now
    from m
    where cpi_index is not null
),

calc as (
    select
        m.month_start,
        m.sp500_level,
        m.sp500_level / lag(m.sp500_level, 1) over (order by m.month_start) - 1             as sp500_ret_1m,
        m.sp500_level / lag(m.sp500_level, 12) over (order by m.month_start) - 1            as sp500_ret_12m,
        (m.sp500_level / lag(m.sp500_level, 12) over (order by m.month_start))
            / (m.cpi_index / lag(m.cpi_index, 12) over (order by m.month_start)) - 1        as sp500_real_ret_12m,
        m.sp500_level / max(m.sp500_level) over (order by m.month_start rows between unbounded preceding and current row) - 1
                                                                     as sp500_drawdown,
        m.sp500_dividend_ttm / m.sp500_level                         as dividend_yield,
        m.cape,
        m.cpi_index,
        (m.cpi_index / lag(m.cpi_index, 12) over (order by m.month_start) - 1) * 100        as cpi_yoy_pct,
        m.ust10y_pct,
        m.vix_avg,
        m.vix_high,
        m.wti_avg,
        m.brent_avg,
        m.brent_avg - m.wti_avg                                      as brent_wti_spread,
        m.wti_avg * l.cpi_now / m.cpi_index                          as wti_avg_real,
        m.henry_hub_avg,
        m.gold_avg,
        m.gold_avg * l.cpi_now / m.cpi_index                         as gold_avg_real,
        m.sp500_level / m.gold_avg                                   as sp500_in_gold_oz
    from m
    cross join latest_cpi as l
)

select
    *,
    ust10y_pct - cpi_yoy_pct                                         as real_10y_pct,
    -- Shiller's excess CAPE yield: equity earnings yield over the real bond yield
    100.0 / cape - (ust10y_pct - cpi_yoy_pct)                        as excess_cape_yield_pct,
    case
        when vix_avg is null                                then null
        when vix_avg <  {{ var('vix_calm_below') }}         then 'Calm'
        when vix_avg <  {{ var('vix_elevated_at') }}        then 'Normal'
        when vix_avg <  {{ var('vix_stress_at') }}          then 'Elevated'
        else 'Stress'
    end                                                              as volatility_regime,
    case
        when sp500_drawdown <= -0.20 then 'Bear market'
        when sp500_drawdown <= -0.10 then 'Correction'
        when sp500_drawdown <= -0.05 then 'Pullback'
        else 'Near highs'
    end                                                              as market_phase
from calc
where month_start >= cast('{{ var("report_start") }}' as date)
