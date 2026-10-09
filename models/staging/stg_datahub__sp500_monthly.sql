-- Shiller S&P 500 file: one row per month since 1871.
-- Unpublished months are padded with 0.0, so every fundamental is zero-to-null.
select
    {{ parse_date('"Date"') }}                                   as month_start,
    {{ to_number('"SP500"', zero_is_null=true) }}                as sp500_level,
    {{ to_number('"Dividend"', zero_is_null=true) }}             as dividend_ttm,
    {{ to_number('"Earnings"', zero_is_null=true) }}             as earnings_ttm,
    {{ to_number('"Consumer Price Index"', zero_is_null=true) }} as shiller_cpi,
    {{ to_number('"Long Interest Rate"', zero_is_null=true) }}   as long_rate_pct,
    {{ to_number('"PE10"', zero_is_null=true) }}                 as cape,
    _source_file,
    _loaded_at
from {{ source('datahub', 'shiller_sp500_monthly') }}
