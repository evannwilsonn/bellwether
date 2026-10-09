"""
Load: copy the extracted files into the warehouse landing zone (schema raw_datahub).

Every column lands as text, exactly as published, plus three audit columns
(_source_file, _source_url, _loaded_at). Typing, null handling and renaming
happen in dbt staging, so the raw layer is always a faithful copy of the source.
The extract manifest is loaded too, as raw_datahub._extract_manifest.

    python ingest/load_raw.py
On Snowflake, the same files are staged and loaded with COPY INTO (ingest/snowflake_load.sql).
"""
from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB = ROOT / "warehouse" / "market_pulse.duckdb"
SCHEMA = "raw_datahub"


def main() -> None:
    manifest_path = RAW / "_manifest.json"
    if not manifest_path.exists():
        raise SystemExit("No extract found. Run ingest/extract.py first.")
    manifest = json.loads(manifest_path.read_text())

    DB.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DB))
    con.execute(f"create schema if not exists {SCHEMA}")
    loaded_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    print(f"Loading into {DB.relative_to(ROOT)}")
    for m in manifest:
        path = (RAW / m["file"]).as_posix()
        con.execute(f"""
            create or replace table {SCHEMA}.{m['table']} as
            select *, ? as _source_file, ? as _source_url, cast(? as timestamp) as _loaded_at
            from read_csv('{path}', header = true, all_varchar = true, quote = '"')
        """, [m["file"], m["url"], loaded_at])
        n = con.execute(f"select count(*) from {SCHEMA}.{m['table']}").fetchone()[0]
        if n != m["rows"]:
            raise SystemExit(f"{m['table']}: loaded {n} rows but the manifest says {m['rows']}")
        print(f"  {SCHEMA}.{m['table']:<24} {n:>8,} rows")

    con.execute(f"create or replace table {SCHEMA}._extract_manifest as select * from read_json_auto('{manifest_path.as_posix()}')")
    con.close()


if __name__ == "__main__":
    main()
