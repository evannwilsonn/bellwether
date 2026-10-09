-- Point-in-time valuation snapshot, one row per company in the snapshot.
-- Companies that have since left the index keep their row but get no GICS sector,
-- so sector rollups only count current members.
select
    f.symbol,
    coalesce(c.company_name, f.company_name)       as company_name,
    c.gics_sector,
    f.snapshot_sub_industry,
    c.symbol is not null                           as in_current_index,
    f.price_usd,
    f.market_cap_usd,
    f.pe_ratio,
    f.eps_usd,
    f.dividend_yield,
    f.ebitda_usd,
    f.price_to_sales,
    f.price_to_book,
    f.low_52w_usd,
    f.high_52w_usd,
    case when f.high_52w_usd > f.low_52w_usd
         then (f.price_usd - f.low_52w_usd) / (f.high_52w_usd - f.low_52w_usd) end as position_in_52w_range,
    f.pe_ratio is null                             as no_positive_earnings
from {{ ref('stg_datahub__sp500_financials') }} as f
left join {{ ref('stg_datahub__sp500_constituents') }} as c using (symbol)
