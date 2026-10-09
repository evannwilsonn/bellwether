-- The source's "Sector" column holds the sub-industry, so it's renamed to say so.
-- Rows where every metric is blank (companies the snapshot never filled in) are dropped.
-- A blank P/E means negative or no earnings; it stays null rather than becoming zero.
select
    upper(trim("Symbol"))                  as symbol,
    trim("Name")                           as company_name,
    trim("Sector")                         as snapshot_sub_industry,
    {{ to_number('"Price"') }}             as price_usd,
    {{ to_number('"Price/Earnings"') }}    as pe_ratio,
    {{ to_number('"Dividend Yield"') }}    as dividend_yield,
    {{ to_number('"Earnings/Share"') }}    as eps_usd,
    {{ to_number('"52 Week Low"') }}       as low_52w_usd,
    {{ to_number('"52 Week High"') }}      as high_52w_usd,
    {{ to_number('"Market Cap"') }}        as market_cap_usd,
    {{ to_number('"EBITDA"', zero_is_null=true) }} as ebitda_usd,
    {{ to_number('"Price/Sales"') }}       as price_to_sales,
    {{ to_number('"Price/Book"') }}        as price_to_book,
    _source_file,
    _loaded_at
from {{ source('datahub', 'sp500_financials') }}
where coalesce("Market Cap", "Price", "Price/Earnings", "EBITDA") is not null
