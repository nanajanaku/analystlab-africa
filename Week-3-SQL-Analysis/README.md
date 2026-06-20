# 📊 Task 3 — SQL Analysis: Sales Dataset
### AnalystLab Africa Data Analytics Internship

---

## 📁 Project Overview

This project contains a complete SQL analysis of a sales dataset covering **2,823 transactions** across **7 product lines**, **92 customers**, and **19 countries** between 2003 and 2005.

All queries were written and executed in **SQL Server Management Studio (SSMS)** as part of the AnalystLab Africa Data Analytics Internship program.

---

## 📂 Files in This Folder

| File | Description |
|------|-------------|
| `analystlab_sales_analysis.sql` | Complete SQL script — 30+ queries across 5 sections |
| `analystlab_sales_data_2.csv` | Raw dataset used for analysis |
| `SQL_Analysis_Report.docx` | Full explanation of queries and business insights |
| `README.md` | This file |

---

## 🗄️ Dataset Summary

| Detail | Value |
|--------|-------|
| Total rows | 2,823 |
| Total columns | 25 |
| Customers | 92 |
| Countries | 19 |
| Product lines | 7 |
| Years covered | 2003 – 2005 |

**Product Lines:** Classic Cars, Vintage Cars, Motorcycles, Trucks and Buses, Planes, Ships, Trains

---

## 🛠️ Tools Used

- **SQL Server Management Studio (SSMS)** — query writing and execution
- **Microsoft SQL Server** — database engine
- **GitHub** — version control and project submission

---

## 📋 Project Structure

### Section 1 — Database Setup
- Created `analystlab_sales` database in SSMS
- Imported CSV using the Import Flat File wizard
- Verified 2,823 rows imported successfully

### Section 2 — Core SQL Queries
Covered fundamental SQL concepts:
- `SELECT`, `WHERE`, `ORDER BY` — filtering and sorting
- `GROUP BY`, `HAVING` — grouping and conditional aggregation
- Aggregate functions — `SUM()`, `AVG()`, `COUNT()`

### Section 3 — Advanced SQL Concepts
- **INNER JOIN** — matched orders to their highest-value line items
- **LEFT JOIN** — all customers with total spend including inactive ones
- **Subqueries** — customers above average spend, orders above yearly average, best product line per country
- **Window Functions** — `RANK()`, `ROW_NUMBER()`, `PARTITION BY`, running totals, `LAG()` for year-over-year growth

### Section 4 — Business Problem Solving
Answered 6 key business questions:

| Question | Key Finding |
|----------|-------------|
| Top customers | Euro+ Shopping Channel is #1 — high concentration risk |
| Top products | Classic Cars drives the highest revenue across all years |
| Revenue trend | November is consistently the peak month |
| Customer behaviour | Medium deals dominate in volume; Large deals in value |
| Order health | Majority of orders are Shipped — operationally healthy |
| Territory performance | EMEA leads overall revenue |

### Section 5 — Query Optimisation
- Created **5 indexes** on high-frequency filter columns
- Rewrote correlated subqueries as **CTEs** for better performance
- Applied `LAG()` window function for year-over-year growth calculation
- Followed clean SQL conventions throughout — uppercase keywords, meaningful aliases, `ROUND()` on all decimals, `COALESCE()` for NULL handling

---

## 💡 Key Insights

1. **Classic Cars** is the top-performing product line — contributing the largest share of total revenue across all three years
2. **Euro+ Shopping Channel** accounts for a disproportionate share of revenue — a customer concentration risk the business should address
3. **November** is the strongest sales month every year — aligning with year-end gifting behaviour for collectible products
4. **EMEA** is the highest-revenue territory but **APAC** shows higher average order values per transaction
5. **Large deals** are rare but generate significantly more revenue per order than Small or Medium deals

---

## 🚀 How to Run the Queries

1. Open **SQL Server Management Studio (SSMS)**
2. Create a new database called `analystlab_sales`
3. Import `analystlab_sales_data_2.csv` using Tasks → Import Flat File
4. Open `analystlab_sales_analysis.sql`
5. Run each section in order (Sections 2 → 3 → 4 → 5)

---

## 👩🏽‍💻 Author

**Nanahawah**  
Data Analytics Intern — AnalystLab Africa  
[GitHub](https://github.com/nanajanaku) |([LinkedIn](https://www.linkedin.com/in/nanahawah)

---

*Part of the AnalystLab Africa Internship Program — June 2025*
