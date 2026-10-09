-- Row counts in the raw layer must match what the extractor recorded when it downloaded each file.
{% set tables = ['shiller_sp500_monthly','cboe_vix_daily','eia_wti_daily','eia_brent_daily','eia_henry_hub_daily',
                 'gold_monthly','fed_ust10y_monthly','bls_cpi_monthly','sp500_constituents','sp500_financials'] %}
with loaded as (
    {%- for t in tables %}
    select '{{ t }}' as tbl, count(*) as n from {{ source('datahub', t) }}{% if not loop.last %} union all{% endif %}
    {%- endfor %}
)
select l.tbl, l.n, m."rows" as manifest_rows
from loaded as l
join {{ source('datahub', '_extract_manifest') }} as m on m."table" = l.tbl
where l.n <> m."rows"
