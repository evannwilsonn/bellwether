-- Current S&P 500 members, flagged for whether the valuation snapshot covers them.
select
    c.symbol,
    c.company_name,
    c.gics_sector,
    c.gics_sub_industry,
    c.headquarters,
    c.added_to_index_on,
    c.cik,
    c.founded_year,
    f.symbol is not null as has_valuation_snapshot
from {{ ref('stg_datahub__sp500_constituents') }} as c
left join {{ ref('stg_datahub__sp500_financials') }} as f using (symbol)
