select
    {{ parse_date('"DATE"') }}    as observed_on,
    {{ to_number('"OPEN"') }}     as vix_open,
    {{ to_number('"HIGH"') }}     as vix_high,
    {{ to_number('"LOW"') }}      as vix_low,
    {{ to_number('"CLOSE"') }}    as vix_close,
    _source_file,
    _loaded_at
from {{ source('datahub', 'cboe_vix_daily') }}
