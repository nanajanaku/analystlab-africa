# 🎵 Week 3 — SQL Analysis: Chinook Database
### AnalystLab Africa Data Analytics Internship

---

## 📁 Project Overview

This project contains a complete SQL analysis of the Chinook Database — a sample database representing a digital music store. The analysis covers **11 related tables**, **59 customers**, **275 artists**, **3,503 tracks**, and **412 invoices** spanning multiple years.

All queries were written and executed in **SQL Server Management Studio (SSMS)** as part of the AnalystLab Africa Data Analytics Internship program.

---

## 📂 Files in This Folder

| File | Description |
|------|-------------|
| `chinook_analysis.sql` | Complete SQL script — 30+ queries across 5 sections |
| `Chinook_SqlServer.sql` | Original Chinook database setup script |
| `Week3_Chinook_Analysis_Report.docx` | Full explanation of queries and business insights |
| `README.md` | This file |

---

## 🗄️ Database Summary

| Detail | Value |
|--------|-------|
| Total tables | 11 |
| Artists | 275 |
| Albums | 347 |
| Tracks | 3,503 |
| Customers | 59 |
| Invoices | 412 |
| Employees | 8 |
| Genres | 25 |

---

## 🔗 Schema — How the Tables Connect

```
Artist ──── Album ──── Track ──── InvoiceLine ──── Invoice ──── Customer
                         │                                          │
                       Genre                                    Employee
                         │
                     MediaType
                         │
                    PlaylistTrack ──── Playlist
```

Unlike a flat CSV file, Chinook has real table relationships — making JOINs across multiple tables essential for meaningful analysis.

---

## 🛠️ Tools Used

- **SQL Server Management Studio (SSMS)** — query writing and execution
- **Microsoft SQL Server** — database engine
- **GitHub** — version control and project submission

---

## 📋 Project Structure

### Section 1 — Database Setup
- Executed `Chinook_SqlServer.sql` in SSMS to create all 11 tables
- Verified row counts across key tables
- Explored schema using `INFORMATION_SCHEMA.COLUMNS`

### Section 2 — Core SQL Queries
- `SELECT`, `WHERE`, `ORDER BY` — filtering customers, tracks, and invoices
- `GROUP BY`, `HAVING` — revenue by country, genre, and year
- Aggregate functions — `SUM()`, `AVG()`, `COUNT()`

### Section 3 — Advanced SQL Concepts
- **INNER JOIN** — connecting invoices to customers, tracks to artists and genres
- **4-table JOIN** — Artist → Album → Track → Genre in a single query
- **LEFT JOIN** — all artists including those with no albums
- **Subqueries** — customers above average spend, tracks never purchased
- **Window Functions** — `RANK()`, `ROW_NUMBER()`, `PARTITION BY`, running totals

### Section 4 — Business Problem Solving

| Business Question | Key Finding |
|-------------------|-------------|
| Top customers | Czech Republic and USA customers dominate spend |
| Top artists | Iron Maiden and U2 lead in tracks sold |
| Top genre | Rock generates the highest revenue by far |
| Revenue trend | Consistent monthly revenue with slight peaks mid-year |
| Top country | USA leads in total revenue and customer count |
| Sales agents | All 3 agents perform within a similar revenue range |
| Unsold tracks | Hundreds of tracks have never been purchased |

### Section 5 — Query Optimisation
- Created **7 indexes** on high-frequency JOIN and filter columns
- Rewrote correlated subqueries as **CTEs** for better performance
- Built a **YoY revenue growth by genre** query using `LAG()` and two CTEs
- Used **CTE + RANK() + PARTITION BY** to find the top customer per country

---

## 💡 Key Business Insights

1. **Rock** is the dominant genre — it accounts for the largest share of tracks sold and total revenue across all years
2. **USA** has the most customers and highest total revenue — the primary market for the store
3. **Hundreds of tracks have never been purchased** — a significant dead inventory problem the store should address through promotions or removal
4. **All three sales agents** perform within a similar revenue range — no single agent is dramatically outperforming or underperforming
5. **Iron Maiden and U2** are the top-selling artists by track count — stocking more of their catalogue would likely drive additional revenue

---

## 🚀 How to Run the Queries

1. Open **SQL Server Management Studio (SSMS)**
2. Run `Chinook_SqlServer.sql` to set up the database
3. Open `chinook_analysis.sql`
4. Make sure `USE Chinook;` is at the top
5. Run each section in order (Sections 2 → 3 → 4 → 5)

---

## 👩🏽‍💻 Author

**Nanahawah**
Data Analytics Intern — AnalystLab Africa
[GitHub](https://github.com/nanajanaku) | [LinkedIn](https://www.linkedin.com/in/nana-gold-56b63b329/)

---

*Part of the AnalystLab Africa Internship Program — June 2025*
