-- Each series' newest observation must be within its allowed staleness window,
-- measured against the newest observation of any series (so the test is stable over time).
-- Severity is warn: a stale public feed should be visible in every build, but shouldn't
-- stop the marts from refreshing. (Today this flags the Shiller earnings and dividend
-- columns, which the public file hasn't updated since mid-2023.)
{{ config(severity='warn') }}
with newest as (select max(last_observed_on) as as_of from {{ ref('dim_series') }})
select s.series_id, s.last_observed_on, n.as_of, s.max_staleness_days
from {{ ref('dim_series') }} as s
cross join newest as n
where s.last_observed_on < n.as_of - s.max_staleness_days
