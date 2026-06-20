-- =====================================================
-- ANALYSTLAB AFRICA INTERNSHIP — SQL ANALYSIS
-- Dataset : analystlab_sales_data_2
-- Author  : Nanahawah
-- Date    : June 2025
-- Tool    : SQL Server Management Studio (SSMS)
-- =====================================================

USE analystlab_sales;

-- =====================================================
-- SECTION 2: CORE SQL QUERIES
-- =====================================================

--USE analystlab_sales
select top 10*
from sales_data
-- Query 2: Shipped orders in the USA, highest sales first
SELECT ORDERNUMBER,
       CUSTOMERNAME,
       SALES,
       ORDERDATE,
       PRODUCTLINE
FROM  sales_data
WHERE  STATUS = 'Shipped'
  AND  COUNTRY = 'USA'
ORDER BY SALES DESC
-- Query 3: Orders where sale amount exceeded $5,000
SELECT ORDERNUMBER,
       CUSTOMERNAME,
       SALES,
       ORDERDATE
FROM  sales_data
WHERE  SALES > 5000
ORDER BY SALES DESC
-- Query 4: All cancelled orders (revenue lost)
SELECT ORDERNUMBER,
       CUSTOMERNAME,
       COUNTRY,
       SALES,
       PRODUCTLINE
FROM   sales_data
WHERE  STATUS = 'Cancelled'
ORDER BY SALES DESC
-- Query 5: Total revenue and order count by product line
SELECT   PRODUCTLINE,
         COUNT(*)                AS total_orders,
         SUM(QUANTITYORDERED)    AS total_units_sold,
         ROUND(SUM(SALES), 2)    AS total_revenue,
         ROUND(AVG(SALES), 2)    AS avg_order_value
FROM     sales_data
GROUP BY PRODUCTLINE
ORDER BY total_revenue DESC
-- Query 6: Only product lines earning more than $500,000
SELECT   PRODUCTLINE,
         ROUND(SUM(SALES), 2) AS total_revenue
FROM     sales_data
GROUP BY PRODUCTLINE
HAVING   SUM(SALES) > 500000
ORDER BY total_revenue DESC
-- Query 7: Revenue by year
SELECT   YEAR_ID,
         COUNT(DISTINCT ORDERNUMBER) AS total_orders,
         ROUND(SUM(SALES), 2)        AS annual_revenue
FROM     sales_data
GROUP BY YEAR_ID
ORDER BY YEAR_ID
-- Query 8: Revenue by quarter and year
SELECT   YEAR_ID,
         QTR_ID,
         ROUND(SUM(SALES), 2) AS quarterly_revenue
FROM     sales_data
GROUP BY YEAR_ID, QTR_ID
ORDER BY YEAR_ID, QTR_ID
-- Query 9: Top 10 countries by revenue
SELECT TOP 10
         COUNTRY,
         COUNT(DISTINCT ORDERNUMBER) AS total_orders,
         ROUND(SUM(SALES), 2)        AS total_revenue
FROM     sales_data
GROUP BY COUNTRY
ORDER BY total_revenue DESC
-- Query 10: Deal size breakdown
SELECT   DEALSIZE,
         COUNT(*)             AS order_count,
         ROUND(SUM(SALES), 2) AS total_revenue,
         ROUND(AVG(SALES), 2) AS avg_sale
FROM     sales_data
GROUP BY DEALSIZE
ORDER BY total_revenue DESC

-- =====================================================
-- SECTION 3: ADVANCED SQL CONCEPTS
-- =====================================================

-- -- Query 11: INNER JOIN — match each order to its highest-value line item
SELECT  o.ORDERNUMBER,
        o.CUSTOMERNAME,
        o.PRODUCTLINE,
        o.SALES,
        o.STATUS
FROM    sales_data o
INNER JOIN (
    SELECT ORDERNUMBER,
           MAX(SALES) AS max_sale
    FROM   sales_data
    GROUP BY ORDERNUMBER
) AS top_lines
ON  o.ORDERNUMBER = top_lines.ORDERNUMBER
AND o.SALES       = top_lines.max_sale
ORDER BY o.SALES DESC
-- Query 12: LEFT JOIN — all customers with their total spend
-- (LEFT JOIN ensures even customers with no shipped orders still appear)
SELECT   c.CUSTOMERNAME,
         c.COUNTRY,
         COALESCE(ROUND(SUM(o.SALES), 2), 0) AS total_spent
FROM     (SELECT DISTINCT CUSTOMERNAME, COUNTRY FROM sales_data) AS c
LEFT JOIN sales_data o ON c.CUSTOMERNAME = o.CUSTOMERNAME
GROUP BY  c.CUSTOMERNAME, c.COUNTRY
ORDER BY  total_spent DESC
-- Query 13: Customers who spent MORE than the average customer total
SELECT   CUSTOMERNAME,
         COUNTRY,
         ROUND(SUM(SALES), 2) AS total_revenue
FROM     sales_data
GROUP BY CUSTOMERNAME, COUNTRY
HAVING   SUM(SALES) > (
             SELECT AVG(customer_total)
             FROM (
                 SELECT SUM(SALES) AS customer_total
                 FROM   sales_data
                 GROUP BY CUSTOMERNAME
             ) AS avg_calc
         )
ORDER BY total_revenue DESC
-- Query 14: Orders above that specific year's average order value
SELECT  ORDERNUMBER,
        CUSTOMERNAME,
        YEAR_ID,
        ROUND(SALES, 2) AS sales
FROM    sales_data o
WHERE   SALES > (
            SELECT AVG(SALES)
            FROM   sales_data
            WHERE  YEAR_ID = o.YEAR_ID
        )
ORDER BY YEAR_ID, SALES 
-- Query 15: Best-selling product line per country
SELECT  COUNTRY,
        PRODUCTLINE,
        ROUND(SUM(SALES), 2) AS revenue
FROM    sales_data s
WHERE   PRODUCTLINE = (
            SELECT TOP 1 PRODUCTLINE
            FROM   sales_data
            WHERE  COUNTRY = s.COUNTRY
            GROUP BY PRODUCTLINE
            ORDER BY SUM(SALES) DESC
        )
GROUP BY COUNTRY, PRODUCTLINE
ORDER BY COUNTRY
-- Query 16: RANK — rank all customers by total revenue
SELECT   CUSTOMERNAME,
         COUNTRY,
         ROUND(SUM(SALES), 2) AS total_revenue,
         RANK() OVER (
             ORDER BY SUM(SALES) DESC
         ) AS revenue_rank
FROM     sales_data
GROUP BY CUSTOMERNAME, COUNTRY
ORDER BY revenue_rank
-- Query 17: PARTITION BY — rank customers WITHIN each country
SELECT   CUSTOMERNAME,
         COUNTRY,
         ROUND(SUM(SALES), 2) AS total_revenue,
         RANK() OVER (
             PARTITION BY COUNTRY
             ORDER BY SUM(SALES) DESC
         ) AS country_rank
FROM     sales_data
GROUP BY CUSTOMERNAME, COUNTRY
ORDER BY COUNTRY, country_rank
-- Query 18: ROW_NUMBER — unique row per product line ordered by sales
SELECT   PRODUCTLINE,
         CUSTOMERNAME,
         ROUND(SALES, 2) AS sales,
         ROW_NUMBER() OVER (
             PARTITION BY PRODUCTLINE
             ORDER BY SALES DESC
         )               AS row_num
FROM     sales_data
ORDER BY PRODUCTLINE, row_num
-- Query 19: Running total of revenue by month within each year
SELECT   YEAR_ID,
         MONTH_ID,
         ROUND(SUM(SALES), 2) AS monthly_revenue,
         ROUND(SUM(SUM(SALES)) OVER (
             PARTITION BY YEAR_ID
             ORDER BY MONTH_ID
         ), 2) AS running_total
FROM     sales_data
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID



-- =====================================================
-- SECTION 4: BUSINESS PROBLEM SOLVING
-- =====================================================

-- -- Query 20: Top 10 customers by total revenue
SELECT TOP 10
         CUSTOMERNAME,
         COUNTRY,
         COUNT(DISTINCT ORDERNUMBER) AS total_orders,
         SUM(QUANTITYORDERED)        AS total_units_bought,
         ROUND(SUM(SALES), 2)        AS total_revenue,
         ROUND(AVG(SALES), 2)        AS avg_order_value
FROM     sales_data
GROUP BY CUSTOMERNAME, COUNTRY
ORDER BY total_revenue DESC
-- Query 21: Revenue and volume by product line
SELECT   PRODUCTLINE,
         COUNT(DISTINCT ORDERNUMBER) AS total_orders,
         SUM(QUANTITYORDERED)        AS total_units_sold,
         ROUND(SUM(SALES), 2)        AS total_revenue,
         ROUND(AVG(PRICEEACH), 2)    AS avg_unit_price
FROM     sales_data
GROUP BY PRODUCTLINE
ORDER BY total_revenue DESC
-- Query 22: Top 5 individual products by revenue
SELECT TOP 5
         PRODUCTCODE,
         PRODUCTLINE,
         SUM(QUANTITYORDERED)     AS units_sold,
         ROUND(SUM(SALES), 2)     AS total_revenue,
         ROUND(AVG(PRICEEACH), 2) AS avg_price
FROM     sales_data
GROUP BY PRODUCTCODE, PRODUCTLINE
ORDER BY total_revenue DESC
-- Query 23: Monthly revenue trend across all years
SELECT   YEAR_ID,
         MONTH_ID,
         COUNT(DISTINCT ORDERNUMBER) AS orders_placed,
         ROUND(SUM(SALES), 2)        AS monthly_revenue
FROM     sales_data
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID
        
-- Query 24: Which month made the most money each year?
SELECT   YEAR_ID,
         MONTH_ID,
         ROUND(SUM(SALES), 2) AS monthly_revenue
FROM     sales_data
GROUP BY YEAR_ID, MONTH_ID
HAVING   SUM(SALES) = (
             SELECT MAX(month_total)
             FROM (SELECT YEAR_ID  AS yr,
                        SUM(SALES) AS month_total
                 FROM   sales_data
                 WHERE  YEAR_ID = sales_data.YEAR_ID
                 GROUP BY YEAR_ID, MONTH_ID
             ) AS peak )
         ORDER BY YEAR_ID
         -- Query 25: Customer purchasing behaviour profile
SELECT   CUSTOMERNAME,
         COUNT(DISTINCT ORDERNUMBER) AS total_orders,
         SUM(QUANTITYORDERED)        AS total_units,
         ROUND(SUM(SALES), 2)        AS total_spent,
         ROUND(AVG(SALES), 2)        AS avg_order_value,
         MIN(DEALSIZE)               AS smallest_deal,
         MAX(DEALSIZE)               AS largest_deal
FROM     sales_data
GROUP BY CUSTOMERNAME
ORDER BY total_spent DESC
-- Query 26: How many customers fall into each spending tier?
SELECT   DEALSIZE,
         COUNT(DISTINCT CUSTOMERNAME) AS customer_count,
         ROUND(SUM(SALES), 2)         AS total_revenue,
         ROUND(AVG(SALES), 2)         AS avg_spend_per_order
FROM     sales_data
GROUP BY DEALSIZE
ORDER BY total_revenue DESC
-- Query 27: Order status breakdown
SELECT   STATUS,
         COUNT(DISTINCT ORDERNUMBER) AS order_count,
         ROUND(SUM(SALES), 2)        AS total_value
FROM     sales_data
GROUP BY STATUS
ORDER BY order_count DESC
-- Query 28: Cancelled and on-hold orders by country (risk view)
SELECT   COUNTRY,
         STATUS,
         COUNT(DISTINCT ORDERNUMBER) AS affected_orders,
         ROUND(SUM(SALES), 2)        AS revenue_at_risk
FROM     sales_data
WHERE    STATUS IN ('Cancelled', 'On Hold')
GROUP BY COUNTRY, STATUS
ORDER BY revenue_at_risk DESC
-- Query 29: Territory performance summary
SELECT   TERRITORY,
         COUNT(DISTINCT CUSTOMERNAME) AS customers,
         COUNT(DISTINCT ORDERNUMBER)  AS total_orders,
         ROUND(SUM(SALES), 2)         AS total_revenue,
         ROUND(AVG(SALES), 2)         AS avg_order_value
FROM     sales_data
WHERE    TERRITORY IS NOT NULL
GROUP BY TERRITORY
ORDER BY total_revenue DESC
-- Query 30: EMEA vs NA vs APAC — deal size mix per territory
SELECT   TERRITORY,
         DEALSIZE,
         COUNT(*)             AS order_count,
         ROUND(SUM(SALES), 2) AS revenue
FROM     sales_data
WHERE    TERRITORY IS NOT NULL
GROUP BY TERRITORY, DEALSIZE
ORDER BY TERRITORY, revenue DESC

-- =====================================================
-- SECTION 5: QUERY OPTIMISATION
-- =====================================================

-- Index on columns you filter by most (WHERE clause)
CREATE INDEX idx_sales_status
    ON sales_data (STATUS);

CREATE INDEX idx_sales_country
    ON sales_data (COUNTRY);

CREATE INDEX idx_sales_productline
    ON sales_data (PRODUCTLINE);

CREATE INDEX idx_sales_customername
    ON sales_data (CUSTOMERNAME);

-- Composite index for time-series queries (GROUP BY YEAR_ID, MONTH_ID)
CREATE INDEX idx_sales_year_month
    ON sales_data (YEAR_ID, MONTH_ID)
    -- Verify your indexes were created
SELECT  name        AS index_name,
        type_desc   AS index_type
FROM    sys.indexes
WHERE   object_id = OBJECT_ID('sales_data')
  AND   name IS NOT NULL
  -- BEFORE: Slow version (subquery runs 2,823 times)
SELECT CUSTOMERNAME,
       SALES
FROM   sales_data
WHERE  SALES > (SELECT AVG(SALES) FROM sales_data)
-- AFTER: Fast version using a CTE (average computed once)
WITH avg_cte AS (
    SELECT AVG(SALES) AS overall_avg
    FROM   sales_data
)
SELECT  s.CUSTOMERNAME,
        s.PRODUCTLINE,
        ROUND(s.SALES, 2)        AS sales,
        ROUND(a.overall_avg, 2)  AS company_avg
FROM    sales_data s
CROSS JOIN avg_cte a
WHERE   s.SALES > a.overall_avg
ORDER BY s.SALES DESC
-- Showpiece: Year-over-year revenue growth per product line
WITH yearly_revenue AS (
    SELECT   PRODUCTLINE,
             YEAR_ID,
             ROUND(SUM(SALES), 2) AS revenue
    FROM     sales_data
    GROUP BY PRODUCTLINE, YEAR_ID
),
with_growth AS (
    SELECT   PRODUCTLINE,
             YEAR_ID,
             revenue,
             LAG(revenue) OVER (
                 PARTITION BY PRODUCTLINE
                 ORDER BY YEAR_ID
             )                                        AS prev_year_revenue,
             ROUND(
                 (revenue - LAG(revenue) OVER (
                     PARTITION BY PRODUCTLINE
                     ORDER BY YEAR_ID
                 )) / NULLIF(LAG(revenue) OVER (
                     PARTITION BY PRODUCTLINE
                     ORDER BY YEAR_ID
                 ), 0) * 100
             , 2)                                     AS growth_pct
    FROM     yearly_revenue
)
SELECT  PRODUCTLINE,
        YEAR_ID,
        revenue,
        prev_year_revenue,
        COALESCE(CAST(growth_pct AS VARCHAR) + '%', 'Base year') AS yoy_growth
FROM    with_growth
ORDER BY PRODUCTLINE, YEAR_ID;
