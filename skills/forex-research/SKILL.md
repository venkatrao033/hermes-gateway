---
name: forex-research
description: Free forex research - live rates, ranges, history analysis
version: 1.0.0
hermes:
  tags: [forex, finance, data]
---

# Forex Research Helper

Use when the user asks about currency pairs, exchange rates, forex prices, daily ranges, pip moves, or market analysis.

## Data sources (all free, no API key, verified 2026-11-27)

1. biquote.io - live OHLC bars, no key:
   `https://biquote.io/api/{SYMBOL}/ohlc?interval=1m&limit=200`
   SYMBOL like EURUSD, AUDUSD, GBPUSD (no slash). JSON `bars`, newest first: openTime (UTC), open, high, low, close, isOpen. Try intervals 1m, 5m, 15m, 1h, 4h, 1d; limit up to a few hundred.
2. Frankfurter v1 - daily ECB reference rates, no key:
   `https://api.frankfurter.dev/v1/latest?base=EUR&symbols=USD,INR`
   `/v1/2026-11-20` for a date, `/v1/2026-11-01..2026-11-26?base=EUR` for a range. One value per ECB day (~16:00 CET), no weekends, covers majors + INR.
3. ECB daily XML: `https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml`.
4. yfinance (installed in the Hermes venv, with pandas): daily/intraday history like `EURUSD=X`. Slower and heavier - only when 1-3 cannot answer.

## Rules
- Never invent a price. Always fetch live, and state the source plus the UTC timestamp of the newest bar used.
- Forex is closed roughly Fri 22:00 UTC to Sun 22:00 UTC - say so when bars are stale or `isOpen` is false.
- Compute with code (python3 + urllib, or pandas for history), never mental math. Pip = 0.0001 for most pairs, 0.01 for JPY pairs.
- This is research/education on request, not financial advice. Never claim live-account results; the user's trading is demo-only.
- Keep memory use low: prefer the small HTTP APIs over loading long history.

## Common workflows
- Current price: fetch 1m bars from biquote, report latest close, its UTC time, and change vs the previous day's close.
- Today's range: fetch 1m or 5m bars since 00:00 UTC, compute high, low, and the range in pips.
- Multi-day high/low: use 1h/4h/1d bars from biquote, or Frankfurter daily for ECB pairs.
- Indicator or backtest ideas: pandas + yfinance daily data; show the code and the computed result.
