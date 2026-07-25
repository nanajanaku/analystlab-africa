# GDP Growth & Economic Performance: A Comparative Analysis for Banking Sector Decision-Making

**AnalystLab Africa — Batch B Internship (June–August 2026)**
**Week 8 Capstone Project**

## 📌 Project Overview

This is the final capstone project of my AnalystLab Africa Batch B internship, building on the SQL, Power BI, and Python skills developed across Weeks 3–7 of this repository (sales & Chinook SQL analysis, COVID-19 dashboard, Telco churn case study, Python stock analysis, and the weather ETL pipeline).

This capstone project analyzes World Bank World Development Indicators (WDI) data to evaluate Nigeria's economic growth and stability profile against nine peer economies — South Africa, Egypt, Kenya, Ghana, India, Indonesia, Brazil, the United States, and China. The analysis is framed around the questions a banking sector stakeholder would ask when assessing market opportunity, lending risk, and investment strategy in Nigeria.

The project covers the complete data analytics workflow: extracting and cleaning a 400,000+ row global dataset in SQL Server, reshaping it into an analysis-ready format, and building a 3-page interactive Power BI dashboard with KPI cards, trend analysis, and banking-relevant insights.

## 🎯 Objective

To apply the complete data analytics workflow to real-world macroeconomic data and communicate findings through professional documentation, visualization, and presentation — specifically answering: How fast is Nigeria's economy growing? How does that growth translate into per-capita prosperity? What inflation, unemployment, and investment risks accompany it? And how does Nigeria compare to peer emerging markets?

## 📊 Dataset

- **Source:** [World Bank World Development Indicators (WDI)](https://datatopics.worldbank.org/world-development-indicators/)
- **Scope:** 10 countries × 9 economic indicators × 2000–2025
- **Indicators analyzed:** GDP (current US$), GDP growth (annual %), GDP per capita, inflation (CPI), FDI net inflows, gross capital formation, exports/imports (% of GDP), and unemployment rate

## 🧹 Data Cleaning & Transformation (SQL / SSMS)

- Imported the full WDI dataset (~198MB, 400,000+ rows) into SQL Server via SSMS
- Resolved column truncation errors on long country/indicator names
- Removed a phantom header row imported as literal data
- Renamed all 70 auto-generated columns into meaningful names (CountryName, CountryCode, IndicatorName, IndicatorCode, Y1960–Y2025)
- Filtered to 10 countries × 9 indicators, excluding aggregate regional groupings to avoid double-counting
- Resolved a data type mismatch across year columns via explicit casting
- Reshaped wide-format data into long format (CountryName, IndicatorCode, Year, Value) using SQL `UNPIVOT`, restricted to 2000–2025
- Validated the cleaned table by spot-checking Nigeria's GDP growth against known historical events (2016 oil-price recession, 2020 COVID contraction) — both confirmed accurately in the data

Full SQL script: [`sql/data_cleaning_and_transformation.sql`](sql/data_cleaning_and_transformation.sql)

## 📈 Dashboard Structure (Power BI)

**Page 1 — Overview:** GDP fundamentals across all 10 countries; growth rate vs. per-capita prosperity story

**Page 2 — Comparative Deep Dive:** Nigeria vs. South Africa across inflation, GDP growth, and FDI — surfacing the growth/inflation trade-off

**Page 3 — Banking Risk Indicators:** Inflation, unemployment, and FDI framed specifically for credit and investment risk assessment

All pages feature a navy-and-gold visual theme, interactive slicers (Country, Year, Indicator), and a "Key Insight" callout summarizing the banking-relevant takeaway.

## 🔑 Key Findings

- Nigeria's GDP growth (4.01%) outpaces South Africa (1.11%), but GDP per capita ($1,224) remains among the lowest of the 10 countries analyzed
- Nigeria's inflation (23.01%) is roughly 7x South Africa's (3.21%), reflecting a growth-inflation trade-off
- Nigeria's FDI inflows (1.38% of GDP) sit mid-pack — behind Egypt and Brazil, ahead of South Africa's net outflows
- Nigeria's official unemployment rate (3.06%) is far below South Africa's (32%+), though this likely understates real labor market slack given Nigeria's large informal sector

## 💡 Recommendations

Full recommendations are detailed in the [final report](GDP_Growth_Economic_Performance_Capstone_Report.pdf), covering loan pricing strategy under inflation risk, financial inclusion considerations, FDI-related advisory opportunities, and informal-sector-adjusted risk modeling for SME lending.

## 🛠️ Tools Used

- **SQL Server Management Studio (SSMS)** — data import, cleaning, transformation
- **Power BI Desktop** — dashboard design, DAX measures, visualization
- **Excel** — supplementary review

## 📂 Repository Contents

| File | Description |
|---|---|
| `WDI_GDP_Capstone.pbix` | Power BI dashboard file |
| `GDP_Growth_Economic_Performance_Capstone_Report.pdf` | Full written report |
| `sql/data_cleaning_and_transformation.sql` | Complete SQL cleaning/transformation script |
| `screenshots/` | Dashboard page screenshots |
| `demo/demo_video_link.md` | Link to project walkthrough video |

## 🎥 Demo Video

[Link to be added]

## 🔗 Connect

- LinkedIn: [linkedin.com/in/nana-gold-56b63b329](https://linkedin.com/in/nana-gold-56b63b329)
- GitHub: [github.com/nanajanaku](https://github.com/nanajanaku)

---
*This project was completed as part of the AnalystLab Africa Batch B Internship (June–August 2026). #AnalystLabAfrica*
