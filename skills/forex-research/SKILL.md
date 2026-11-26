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

## Strategy search mode ("find a strategy for me")

When the user asks to find or search for a trading strategy, run a real research loop, not one idea:

1. Search many directions: trend (MA crosses, Donchian/breakout), mean-reversion (RSI or Bollinger fades), momentum, session/time-of-day patterns, volatility regimes, multi-timeframe filters. Vary pairs (EURUSD, GBPUSD, AUDUSD, NZDUSD, USDJPY, USDCAD) and timeframes (15m, 1h, 4h, 1d).
2. Data: yfinance daily/hourly, or biquote bars. Every result must name pair, timeframe, exact date range, and source.
3. Costs always on: subtract spread + slippage per trade BEFORE judging (default 1.0 pip spread + 0.5 pip slippage on majors, wider on crosses). A strategy that only wins before costs is a loser.
4. Split the data: screen variants on the first 70%, then run ONE untouched final test on the last 30%. Report both. If the untouched test disagrees, it failed - say so.
5. Count trials honestly: report how many variants were tested. Many trials produce lucky winners, so a candidate is only interesting if the untouched test agrees.
6. Say "no edge found" when there is none. Never dress up a loser. Known dead end: a 101-variant MA-cross-family search on EURUSD already found no real edge (best +0.035R per trade, error range includes zero) - do not rerun that family; try genuinely different directions.
7. Keep it light on this small server: small batches, a few variants per run, daily/hourly bars. Run long searches as several small runs, not one giant one.
8. Output per candidate, in plain language: the rules (entry, exit, stops), pair + timeframe + period, number of trades, win rate, average R per trade WITH costs, max drawdown, and the untouched-test result. End with a one-paragraph honest summary.
