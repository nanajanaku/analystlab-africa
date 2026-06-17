# 📊 AnalystLab Africa — Data Analytics Internship Project

> **Intern:** Ajanaku Nanahawah
> **Program:** AnalystLab Africa Data Analytics Internship
> **Tools Used:** SQL Server Management Studio (SSMS) | Power BI
> **Datasets:** Netflix Titles | Online Retail
> **Completion Date:** June 2025

---

## 📁 Project Overview

This project was completed as part of the **AnalystLab Africa Data Analytics Internship Program**. It involved end-to-end data analysis across two real-world datasets — **Netflix Titles** and **Online Retail** — covering data ingestion, cleaning, exploratory data analysis (EDA), visualization, and insight generation.

All analysis was performed using **SQL Server Management Studio (SSMS)** and dashboards were built in **Power BI**.

---

## 📂 Repository Structure

```
analystlab-africa/
│
├── 📁 datasets/
│   ├── Netflix_Cleaned.csv
│   └── OnlineRetail_Cleaned.csv
│
├── 📁 dashboards/
│   ├── Netflix_Dashboard.png
│   └── OnlineRetail_Dashboard.png
│
├── 📁 reports/
│   ├── AnalystLab_Africa_Insight_Report.docx
│   └── AnalystLab_Africa_Full_Documentation.docx
│
└── README.md
```

---

## 🗂️ Datasets

### 1. Netflix Titles Dataset
| Attribute | Details |
|---|---|
| Source | Kaggle — Netflix Titles Dataset |
| Total Records | 8,787 titles |
| Movies | 6,124 (69.69%) |
| TV Shows | 2,663 (30.31%) |
| Total Directors | 4,524 unique directors |
| Key Columns | show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description |

### 2. Online Retail Dataset
| Attribute | Details |
|---|---|
| Source | Kaggle / UCI Machine Learning Repository |
| Initial Records | 535,187 transactions |
| Final Records | 534,125 (after cleaning) |
| Total Revenue | £9.75M |
| Total Orders | 23,796 |
| Total Customers | 4,372 |
| Total Countries | 38 |
| Key Columns | InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country |

---

## 🧹 Data Cleaning Summary

### Netflix Titles
- Replaced missing values in `director` (2,634), `cast` (825), and `country` (831) with **'Unknown'**
- Removed rows with missing `date_added` (10), `rating` (4), and `duration` (3)
- Removed **3 duplicate titles** (2 Movies, 1 TV Show)
- Trimmed whitespace and standardized text to proper case
- Converted `date_added` to proper **DATE** data type
- Split `duration` into two new columns: `duration_minutes` (Movies) and `duration_seasons` (TV Shows)

### Online Retail
- Deleted **1,454 rows** with missing `Description` — product cannot be identified without it
- Replaced **135,080 missing** `CustomerID` values with **'Unknown'** — guest purchases retain revenue value
- Removed **4,879 duplicate groups** keeping one copy of each unique record
- Retained **9,725 cancellation records** (C-prefixed invoices with negative quantities) as valid business data
- Flagged **474 negative quantity rows** without C prefix as anomalies for further investigation
- Flagged **1,060 zero unit price records** as potential promotional items or data entry errors
- Standardized country names: `EIRE → Ireland` | `RSA → South Africa` | `Unspecified → Unknown`
- Converted `InvoiceDate` to proper **DATE** data type
- Created new column: `TotalPrice = Quantity × UnitPrice`
- **Final record count:** 534,125 (from 535,187)

---

## 📈 Summary Statistics

### Netflix Titles
| Metric | MIN | MAX | AVG |
|---|---|---|---|
| Release Year | 1925 | 2021 | 2014 |
| Duration — Movies (mins) | 3 | 312 | 99 |

### Online Retail
| Metric | MIN | MAX | AVG |
|---|---|---|---|
| Quantity | -80,995 | 80,995 | 9 |
| Unit Price (£) | 0.01 | 38,970.00 | 4.70 |
| Total Price (£) | -168,469.60 | 168,469.60 | 18.25 |

> ⚠️ *Negative values in Quantity and TotalPrice represent cancellation/return transactions (C-prefixed invoices) — valid business records retained for completeness.*

---

## 🔍 Key Insights

### Netflix Titles
| # | Insight |
|---|---|
| 1 | **Movies dominate** — 69.69% Movies vs 30.31% TV Shows |
| 2 | **Explosive growth from 2016** — content peaked around 2018–2019 during Netflix's global expansion |
| 3 | **USA leads production** with 2,809 titles followed by India and the UK |
| 4 | **Mature audience focus** — 60%+ of content rated TV-MA or TV-14 |
| 5 | **Dramas & International Movies** dominate the genre landscape |

### Online Retail
| # | Insight |
|---|---|
| 1 | **Paper Craft, Little Birdie** leads with 80,995 units sold — a bulk-driven volume leader |
| 2 | **UK dominates revenue** at 84.01% (£9M+) — significant market concentration risk |
| 3 | **Holiday season peak** — revenue hit £1.5M in November 2011 driven by Q4 demand |
| 4 | **Frequency vs Volume differ** — White Hanging Heart T-Light Holder leads in order count (2,311 orders) while Paper Craft leads in units |
| 5 | **Mixed customer behavior** — clear split between bulk buyers and frequent small-order customers |

---

## 📊 Dashboards

### Netflix Content Analysis Dashboard
![Netflix Dashboard](dashboards/Netflix_Dashboard.png)

**Theme:** Black (#141414) and Netflix Red (#E50914)
**KPI Cards:** Total Titles (8,787) | Total Movies (6,124) | Total TV Shows (2,663) | Total Directors (4,524)
**Charts:** Content Type Distribution | Content Added By Year | Top 10 Countries | Content Rating Distribution | Top 10 Genres
**Slicers:** Type | Rating | Release Year

---

### Online Retail Sales Dashboard
![Online Retail Dashboard](dashboards/OnlineRetail_Dashboard.png)

**Theme:** Deep Navy (#0A1628) and Bright Blue (#1F8EF1)
**KPI Cards:** Total Revenue (£9.75M) | Total Countries (38) | Total Orders (23,796) | Total Customers (4,372)
**Charts:** Revenue Trend by Month | Sales Distribution by Country | Top 10 Countries by Revenue | Top 10 Best Selling Products | Top 10 Customers by Revenue
**Slicers:** Country | Product | Month

---

## 📦 Deliverables

| Deliverable | Status |
|---|---|
| Cleaned Netflix Dataset (CSV) | ✅ Complete |
| Cleaned Online Retail Dataset (CSV) | ✅ Complete |
| Netflix Power BI Dashboard | ✅ Complete |
| Online Retail Power BI Dashboard | ✅ Complete |
| 1-Page Insight Report (Word) | ✅ Complete |
| Full Project Documentation (Word) | ✅ Complete |

---

## 🔗 Google Drive

All deliverables are available on Google Drive:

👉 [Click here to access the project folder](https://drive.google.com/drive/folders/1Jk9T3FGLEzVnMeAsYEGw1jmtjk6yajOl?usp=sharing)

---

## 👤 Author

**Ajanaku Nanahawah**
Data Analytics Intern — AnalystLab Africa
🔗 [LinkedIn](https://www.linkedin.com/in/nanajanaku)
🐙 [GitHub](https://github.com/nanajanaku)

---

*This project was completed as part of the AnalystLab Africa Data Analytics Internship Program — June 2025*
