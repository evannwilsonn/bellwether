-- Every daily series in one long table: (series_id, observed_on, value).
-- Adding a new daily feed means adding one union branch and one seed row.
select 'vix' as series_id, observed_on, vix_close as value from {{ ref('stg_datahub__vix_daily') }}
union all
select 'wti', observed_on, price_usd from {{ ref('stg_datahub__wti_daily') }}
union all
select 'brent', observed_on, price_usd from {{ ref('stg_datahub__brent_daily') }}
union all
select 'henry_hub', observed_on, price_usd from {{ ref('stg_datahub__henry_hub_daily') }}
