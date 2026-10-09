select
    upper(trim("Symbol"))                       as symbol,
    trim("Security")                            as company_name,
    trim("GICS Sector")                         as gics_sector,
    trim("GICS Sub-Industry")                   as gics_sub_industry,
    trim("Headquarters Location")               as headquarters,
    {{ parse_date('"Date added"') }}            as added_to_index_on,
    lpad(trim("CIK"), 10, '0')                  as cik,
    -- "Founded" is sometimes "1902 (1857)"; keep the first year
    try_cast(left(trim("Founded"), 4) as integer) as founded_year,
    _source_file,
    _loaded_at
from {{ source('datahub', 'sp500_constituents') }}
