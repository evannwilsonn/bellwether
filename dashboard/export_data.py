"""
Export the reporting marts the dashboard reads into dashboard/data.json.

Run after `dbt build`:  python dashboard/export_data.py
"""
from __future__ import annotations

import json
from datetime import date, datetime
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "warehouse" / "market_pulse.duckdb"
OUT = ROOT / "dashboard" / "data.json"

MONTH_COLS = [
    "month_start", "sp500_level", "sp500_ret_12m", "sp500_real_ret_12m", "sp500_drawdown", "dividend_yield",
    "cape", "excess_cape_yield_pct", "cpi_yoy_pct", "ust10y_pct", "real_10y_pct", "vix_avg", "vix_high",
    "volatility_regime", "market_phase", "wti_avg", "wti_avg_real", "brent_avg", "henry_hub_avg",
    "gold_avg", "gold_avg_real",
]
SECTOR_COLS = [
    "gics_sector", "companies", "market_cap_usd", "index_weight", "aggregate_pe", "median_pe",
    "cap_weighted_dividend_yield", "share_without_positive_earnings",
]


def clean(v):
    if isinstance(v, (date, datetime)):
        return v.isoformat()[:10]
    if isinstance(v, float):
        return round(v, 6)
    return v


def main() -> None:
    con = duckdb.connect(str(DB), read_only=True)
    q = lambda sql: con.execute(sql).fetchall()
    months = q(f"select {', '.join(MONTH_COLS)} from reporting.rpt_market_monthly order by month_start")
    sectors = q(f"select {', '.join(SECTOR_COLS)} from reporting.rpt_sector_valuation order by market_cap_usd desc")
    series = q("select series_id, series_name, unit, publisher, first_month, last_observed_on, months_of_history from core.dim_series order by category, series_id")
    sources = q('select "table", publisher, "rows", url, sha256 from raw_datahub._extract_manifest order by "table"')
    quality = {
        "shiller_zero_padded_values": q("""select count(*) from raw_datahub.shiller_sp500_monthly
            where '0.0' in ("Dividend", "Earnings", "Consumer Price Index", "Long Interest Rate", "PE10")""")[0][0],
        "blank_price_rows_dropped": q("select count(*) from raw_datahub.eia_henry_hub_daily where nullif(trim(\"Price\"), '') is null")[0][0],
        "empty_snapshot_rows_dropped": q("select (select count(*) from raw_datahub.sp500_financials) - (select count(*) from staging.stg_datahub__sp500_financials)")[0][0],
        "snapshot_companies_left_index": q("select count(*) from core.fct_company_valuation where not in_current_index")[0][0],
        "current_members_without_snapshot": q("select count(*) from core.dim_companies where not has_valuation_snapshot")[0][0],
        "negative_wti_days_kept": q("select count(*) from staging.stg_datahub__wti_daily where price_usd < 0")[0][0],
        "cape_last_published": str(q("select max(month_start) from staging.stg_datahub__sp500_monthly where cape is not null")[0][0]),
        "daily_rows": q("select count(*) from core.fct_series_daily")[0][0],
        "monthly_rows": q("select count(*) from core.fct_series_monthly")[0][0],
    }
    payload = {
        "generated": date.today().isoformat(),
        "month_columns": MONTH_COLS,
        "months": [[clean(v) for v in r] for r in months],
        "sector_columns": SECTOR_COLS,
        "sectors": [[clean(v) for v in r] for r in sectors],
        "series": [[clean(v) for v in r] for r in series],
        "sources": [list(r) for r in sources],
        "quality": quality,
    }
    OUT.write_text(json.dumps(payload, separators=(",", ":")))
    print(f"Wrote {OUT.relative_to(ROOT)} ({OUT.stat().st_size / 1024:.0f} KB, {len(months)} months, {len(sectors)} sectors)")


if __name__ == "__main__":
    main()
