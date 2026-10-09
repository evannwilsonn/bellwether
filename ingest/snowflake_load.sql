-- Load the extracted files into Snowflake: the same raw landing zone the DuckDB loader builds.
-- 1) Run `python ingest/extract.py` locally.
-- 2) Run this file in SnowSQL from the project folder (the PUT commands need a client, not a worksheet):
--      snowsql -a <account> -u <user> -f ingest/snowflake_load.sql
-- Every column lands as VARCHAR, plus the same audit columns, and dbt does the typing.

create database if not exists bellwether;
use database bellwether;
create schema if not exists raw_datahub;
use schema raw_datahub;

create or replace file format csv_header type = csv parse_header = true field_optionally_enclosed_by = '"' empty_field_as_null = false;
create or replace stage datahub_stage file_format = csv_header;

put file://data/raw/*.csv @datahub_stage auto_compress = true overwrite = true;

-- One block per file. The macro-free pattern: infer the header, force every column to VARCHAR,
-- add audit columns, then COPY by column name.
execute immediate $$
declare
  tables array default array_construct('shiller_sp500_monthly','cboe_vix_daily','eia_wti_daily','eia_brent_daily',
    'eia_henry_hub_daily','gold_monthly','fed_ust10y_monthly','bls_cpi_monthly','sp500_constituents','sp500_financials');
  t varchar;
begin
  for i in 0 to array_size(tables) - 1 do
    t := tables[i];
    execute immediate 'create or replace table ' || t || ' using template (
        select array_agg(object_construct(''COLUMN_NAME'', column_name, ''TYPE'', ''VARCHAR'', ''NULLABLE'', true))
        from table(infer_schema(location => ''@datahub_stage/' || t || '.csv.gz'', file_format => ''csv_header'')))';
    execute immediate 'alter table ' || t || ' add column _source_file varchar, _source_url varchar, _loaded_at timestamp_ntz';
    execute immediate 'copy into ' || t || ' from @datahub_stage/' || t || '.csv.gz
        file_format = (format_name = ''csv_header'') match_by_column_name = case_sensitive
        include_metadata = (_source_file = metadata$filename, _loaded_at = metadata$start_scan_time)';
  end for;
  return 'loaded ' || array_size(tables) || ' tables';
end;
$$;

-- Extract manifest, used by the row-count reconciliation test.
create or replace stage manifest_stage file_format = (type = json strip_outer_array = true);
put file://data/raw/_manifest.json @manifest_stage auto_compress = false overwrite = true;
create or replace table "_EXTRACT_MANIFEST" as
select $1:"table"::varchar as "table", $1:"file"::varchar as "file", $1:"url"::varchar as "url",
       $1:"publisher"::varchar as "publisher", $1:"rows"::integer as "rows", $1:"sha256"::varchar as "sha256",
       $1:"fetched_at"::timestamp_ntz as "fetched_at"
from @manifest_stage/_manifest.json;
