-- Rows with a blank price (market holidays) are dropped here rather than carried as nulls.
select
    {{ parse_date('"Date"') }}  as observed_on,
    {{ to_number('"Price"') }}  as price_usd,
    _source_file,
    _loaded_at
from {{ source('datahub', 'eia_henry_hub_daily') }}
where {{ to_number('"Price"') }} is not null
