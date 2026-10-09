{#-
  Cross-database helpers so every model runs unchanged on DuckDB (local)
  and Snowflake (production). Each one dispatches on the adapter.
-#}

{# Parse text dates: 'iso' (2026-09-30) or 'ym' (2026-09, the first of the month) #}
{% macro parse_date(column, fmt='iso') -%}{{ return(adapter.dispatch('parse_date')(column, fmt)) }}{%- endmacro %}

{% macro duckdb__parse_date(column, fmt) -%}
    {%- if fmt == 'ym' -%}cast(try_strptime(trim({{ column }}) || '-01', '%Y-%m-%d') as date)
    {%- else -%}cast(try_strptime(trim({{ column }}), '%Y-%m-%d') as date){%- endif -%}
{%- endmacro %}

{% macro snowflake__parse_date(column, fmt) -%}
    {%- if fmt == 'ym' -%}try_to_date(trim({{ column }}) || '-01', 'YYYY-MM-DD')
    {%- else -%}try_to_date(trim({{ column }}), 'YYYY-MM-DD'){%- endif -%}
{%- endmacro %}

{#
  Text to number. Blank strings become null. When zero_is_null is true, a literal 0
  is treated as "not published yet" (the Shiller file pads unreleased months with 0.0).
#}
{% macro to_number(column, zero_is_null=false) -%}{{ return(adapter.dispatch('to_number')(column, zero_is_null)) }}{%- endmacro %}

{% macro duckdb__to_number(column, zero_is_null) -%}
    {%- if zero_is_null -%}nullif(try_cast(nullif(trim({{ column }}), '') as double), 0)
    {%- else -%}try_cast(nullif(trim({{ column }}), '') as double){%- endif -%}
{%- endmacro %}

{% macro snowflake__to_number(column, zero_is_null) -%}
    {%- if zero_is_null -%}nullif(try_to_double(nullif(trim({{ column }}), '')), 0)
    {%- else -%}try_to_double(nullif(trim({{ column }}), '')){%- endif -%}
{%- endmacro %}

{# First day of the month for a date #}
{% macro month_start(column) -%}cast(date_trunc('month', {{ column }}) as date){%- endmacro %}
