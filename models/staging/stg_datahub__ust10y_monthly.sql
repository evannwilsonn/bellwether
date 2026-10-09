select
    {{ parse_date('"Date"') }}  as month_start,
    {{ to_number('"Rate"') }}   as ust10y_pct,
    _source_file,
    _loaded_at
from {{ source('datahub', 'fed_ust10y_monthly') }}
