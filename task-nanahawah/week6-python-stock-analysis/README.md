# Week 6 — Advanced Python for Data Analysis
**AnalystLab Africa Internship | Batch B (June–August 2026)**

## Project Overview
This project applies advanced Python techniques to analyze 5 years of historical stock market data for Apple Inc. (AAPL), covering data transformation, time-series analysis, and feature engineering.

## Dataset
- **Source:** Yahoo Finance (AAPL), retrieved via the `yfinance` Python library
- **Period:** July 12, 2021 – July 10, 2026 (5 years)
- **Size:** 1,255 trading days
- **Columns:** Date, Open, High, Low, Close, Volume

## Tools & Techniques
- **Python (Pandas, NumPy, Matplotlib)** in Google Colab
- Data cleaning and validation (missing values, duplicates, logical consistency checks)
- Data transformation: calculated columns (Daily Change, Daily % Change, Daily Range)
- Time-series analysis: 7-day & 30-day moving averages, monthly aggregation
- Feature engineering: monthly returns, 30-day rolling volatility, cumulative return
- Data visualization: 5 charts covering price trend, volume, moving averages, monthly returns, and volatility

## Key Findings
- **Total return (5 years):** +123.87% — a $1 investment on Day 1 would be worth $2.24 today
- **Best month:** July 2022 (+18.86%) | **Worst month:** December 2022 (-12.23%)
- **55.7%** of months were positive
- Identified an unusual sustained volatility period around mid-2025 (elevated for weeks, not just a single spike)
- Highest single-day trading volume: ~318.7M shares (Sep 20, 2024)

## Files in This Folder
- `AAPL_Stock_Analysis.ipynb` — full Python notebook (cleaning, analysis, visualizations)
- `AAPL_Insight_Summary.docx` — 1–2 page written summary of findings and recommendations

## Author
Nanahawah — Data Analytics Intern, AnalystLab Africa
