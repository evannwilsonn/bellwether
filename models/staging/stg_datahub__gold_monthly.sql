-- Dates arrive as YYYY-MM; anchor each to the first of the month.
select
    {{ parse_date('"Date"', 'ym') }}  as month_start,
    {{ to_number('"Price"') }}        as gold_usd_oz,
    _source_file,
    _loaded_at
from {{ source('datahub', 'gold_monthly') }}
