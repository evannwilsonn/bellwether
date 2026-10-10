# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Hiring managers first, arriving from Evan Wilson's resume or LinkedIn and giving the page about a minute; they need to see an end-to-end ELT pipeline on real public market and macro data that turns messy files into a tested model and a page that answers real questions. Data engineers second, who check the cleanup, tests, definitions and sources. Desktop and phone viewing are about equal. (Confirmed for the whole portfolio on 2026-10-09.)

## Product Purpose

Bellwether extracts public market and macro series (S&P 500 since 1871 via Shiller, VIX, WTI, Brent, Henry Hub gas, gold, 10-year Treasury, CPI, S&P 500 constituents and a valuation snapshot), loads them untouched, and transforms them with dbt into a star schema and two reporting marts. The page answers: how U.S. stocks are doing in real terms and how far from their high; what volatility regime we are in; the real 10-year yield and valuations against it (CAPE, excess CAPE yield); oil and gold in today's dollars against past peaks; which sectors carry the index and how they are valued. It also counts what the pipeline cleaned up (zero-padded Shiller months, stale fundamentals, mislabelled sector column, point-in-time mismatch, the real −$36.98 WTI print kept).

## Positioning

A market read built like an engineer's pipeline: every figure is a tested, sourced series, and the messiness of public data is shown, not hidden.

## Operating Context

Static page with inline data (dashboard/data.json), built from DuckDB or Snowflake; also published as a Claude artifact and as a product view inside Switchyard. Not investment advice.

## Capabilities and Constraints

- Data: 441 months (1990-01 to latest) with S&P level, 12-month nominal and real return, drawdown, dividend yield, CAPE, excess CAPE yield, CPI YoY, 10y, real 10y, VIX average and high, volatility regime, market phase, WTI/Brent/Henry Hub, gold, real oil and gold; 11 sectors (companies, market cap, weight, aggregate and median P/E, dividend yield, share without positive earnings); series catalog with coverage; sources with URL, rows, SHA-256; quality counts.
- CPI lags a month and CAPE stops in 2023, so latest real figures are null; the page must say so rather than invent them.
- Every number comes from data.json.

## Brand Commitments

Each portfolio project has its own visual world and its own new colour palette, distinct from Reprise (cool white, ink, blue ramp, amber), Cloverfield (control-room black, Caltrans orange, green/amber/red), Cloverleaf (concrete grey, plum, lime), Switchyard (cream, rust, umber), Curbside (newsprint broadsheet, ink, taxi yellow), Clip Curator (graphite, film black, hot pink), Throughline (kraft, thermal white, stamp teal), and the earlier IBM Plex blue look. Must not read as a generic fintech terminal or Curbside's broadsheet.

## Evidence on Hand

dashboard/data.json; README findings and test list. No users or testimonials.

## Product Principles

1. Lead with where the market stands now, in a sentence.
2. Real (inflation-adjusted) beside nominal wherever the data allows.
3. Show the cleanup: data quality is part of the story.
4. Every mark maps to real data; missing is shown as missing.

## Accessibility & Inclusion

WCAG AA contrast in light and dark; regimes and phases never carried by colour alone; works at phone width.
