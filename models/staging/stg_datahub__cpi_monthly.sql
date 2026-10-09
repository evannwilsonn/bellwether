select
    {{ parse_date('"Date"') }}       as month_start,
    {{ to_number('"Index"') }}       as cpi_index,
    {{ to_number('"Inflation"') }}   as cpi_mom_pct,
    _source_file,
    _loaded_at
from {{ source('datahub', 'bls_cpi_monthly') }}
