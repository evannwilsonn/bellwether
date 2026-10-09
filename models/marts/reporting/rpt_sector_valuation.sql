-- Sector valuation from the company snapshot, current index members only.
-- Aggregate P/E is cap-weighted the way index providers do it (total cap over total
-- earnings), so a few tiny-earnings companies can't blow up the average.
select
    gics_sector,
    count(*)                                                       as companies,
    sum(market_cap_usd)                                            as market_cap_usd,
    sum(market_cap_usd) / sum(sum(market_cap_usd)) over ()         as index_weight,
    sum(case when pe_ratio > 0 then market_cap_usd end)
        / nullif(sum(case when pe_ratio > 0 then market_cap_usd / pe_ratio end), 0)
                                                                   as aggregate_pe,
    median(pe_ratio)                                               as median_pe,
    sum(market_cap_usd * coalesce(dividend_yield, 0)) / sum(market_cap_usd)
                                                                   as cap_weighted_dividend_yield,
    median(price_to_book)                                          as median_price_to_book,
    avg(case when no_positive_earnings then 1.0 else 0.0 end)      as share_without_positive_earnings,
    avg(position_in_52w_range)                                     as avg_position_in_52w_range
from {{ ref('fct_company_valuation') }}
where in_current_index
group by gics_sector
