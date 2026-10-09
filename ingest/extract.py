"""
Extract: pull public market and macro datasets into the raw landing folder.

Every source is a public-domain (ODC-PDDL) CSV published by the DataHub
"core datasets" project, which republishes official series from S&P / Robert
Shiller, CBOE, the U.S. EIA, the Federal Reserve, BLS and the World Gold Council.

Each run writes the files exactly as downloaded plus a manifest recording the
URL, byte size, row count, SHA-256 and fetch time, so every number in the
warehouse can be traced back to the file it came from.

    python ingest/extract.py            # download everything
    python ingest/extract.py --offline  # re-use files already on disk
"""
from __future__ import annotations

import argparse
import hashlib
import json
import time
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
BASE = "https://raw.githubusercontent.com/datasets"

# (table name in the raw schema, dataset repo, file in that repo, publisher of the underlying series)
SOURCES = [
    ("shiller_sp500_monthly", "s-and-p-500", "data/data.csv", "Robert Shiller / S&P"),
    ("cboe_vix_daily", "finance-vix", "data/vix-daily.csv", "CBOE"),
    ("eia_wti_daily", "oil-prices", "data/wti-daily.csv", "U.S. EIA"),
    ("eia_brent_daily", "oil-prices", "data/brent-daily.csv", "U.S. EIA"),
    ("eia_henry_hub_daily", "natural-gas", "data/daily.csv", "U.S. EIA"),
    ("gold_monthly", "gold-prices", "data/monthly.csv", "World Gold Council / Bundesbank"),
    ("fed_ust10y_monthly", "bond-yields-us-10y", "data/monthly.csv", "Federal Reserve"),
    ("bls_cpi_monthly", "cpi-us", "data/cpiai.csv", "U.S. BLS"),
    ("sp500_constituents", "s-and-p-500-companies", "data/constituents.csv", "Wikipedia / S&P"),
    ("sp500_financials", "s-and-p-500-companies-financials", "data/constituents-financials.csv", "Public filings snapshot"),
]


def fetch(url: str, attempts: int = 4) -> bytes:
    for i in range(attempts):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "market-pulse-extract/1.0"})
            with urllib.request.urlopen(req, timeout=60) as r:
                return r.read()
        except Exception as exc:  # network blips: back off and retry
            if i == attempts - 1:
                raise SystemExit(f"Failed to fetch {url}: {exc}")
            time.sleep(2 ** i)
    raise AssertionError("unreachable")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--offline", action="store_true", help="skip downloads, rebuild the manifest from disk")
    args = ap.parse_args()

    RAW.mkdir(parents=True, exist_ok=True)
    manifest = []
    for table, repo, path, publisher in SOURCES:
        url = f"{BASE}/{repo}/main/{path}"
        out = RAW / f"{table}.csv"
        if args.offline:
            if not out.exists():
                raise SystemExit(f"--offline but {out.name} is missing; run without --offline first")
            body = out.read_bytes()
        else:
            body = fetch(url)
            out.write_bytes(body)
        rows = body.count(b"\n") - 1 + (0 if body.endswith(b"\n") else 1)
        manifest.append({
            "table": table,
            "file": out.name,
            "url": url,
            "publisher": publisher,
            "bytes": len(body),
            "rows": rows,
            "sha256": hashlib.sha256(body).hexdigest(),
            "fetched_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        })
        print(f"  {table:<24} {rows:>8,} rows  {len(body) / 1024:>7.0f} KB")
    (RAW / "_manifest.json").write_text(json.dumps(manifest, indent=2))
    print(f"Wrote {len(manifest)} files + _manifest.json to {RAW.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
