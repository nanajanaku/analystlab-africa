
USE Chinook;

SELECT COUNT(*) AS artists  FROM Artist;
SELECT COUNT(*) AS albums   FROM Album;
SELECT COUNT(*) AS tracks   FROM Track;
SELECT COUNT(*) AS customers FROM Customer;
SELECT COUNT(*) AS invoices FROM Invoice
USE Chinook;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME
-- See Invoice columns
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Invoice'

-- See Track columns
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Track'

-- See Customer columns
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer'
-- Query 1: Preview all tables quickly
SELECT TOP 10 * FROM Invoice
SELECT TOP 10 * FROM Track
SELECT TOP 10 * FROM Customer
-- Query 2: All customers from the USA
SELECT FirstName, LastName, City, State, Email
FROM   Customer
WHERE  Country = 'USA'
ORDER BY LastName ASC
-- Query 3: Invoices above $10 sorted by highest amount
SELECT InvoiceId, CustomerId, InvoiceDate,
       BillingCountry, Total
FROM   Invoice
WHERE  Total > 10
ORDER BY Total DESC
-- Query 4: Tracks longer than 5 minutes (300,000 milliseconds)
SELECT Name, Composer, Milliseconds,
       ROUND(Milliseconds / 60000.0, 2) AS minutes
FROM   Track
WHERE  Milliseconds > 300000
ORDER BY Milliseconds DESC
-- Query 5: Total revenue by country
SELECT   BillingCountry,
         COUNT(InvoiceId)        AS total_invoices,
         ROUND(SUM(Total), 2)    AS total_revenue,
         ROUND(AVG(Total), 2)    AS avg_invoice_value
FROM     Invoice
GROUP BY BillingCountry
ORDER BY total_revenue DESC
-- Query 6: Countries generating more than $50 in revenue
SELECT   BillingCountry,
         ROUND(SUM(Total), 2) AS total_revenue
FROM     Invoice
GROUP BY BillingCountry
HAVING   SUM(Total) > 50
ORDER BY total_revenue DESC
-- Query 7: Number of tracks per genre
SELECT   GenreId,
         COUNT(TrackId)  AS total_tracks,
         ROUND(AVG(Milliseconds / 60000.0), 2) AS avg_duration_mins
FROM     Track
GROUP BY GenreId
ORDER BY total_tracks DESC
-- Query 8: Revenue by year
SELECT   YEAR(InvoiceDate)       AS invoice_year,
         COUNT(InvoiceId)        AS total_invoices,
         ROUND(SUM(Total), 2)    AS annual_revenue
FROM     Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY invoice_year
-- Query 9: Top 10 most expensive tracks
SELECT TOP 10
         Name,
         UnitPrice,
         Milliseconds,
         ROUND(Milliseconds / 60000.0, 2) AS duration_mins
FROM     Track
ORDER BY UnitPrice DESC
-- Query 10: INNER JOIN — Customer names on their invoices
SELECT   i.InvoiceId,
         c.FirstName + ' ' + c.LastName AS customer_name,
         c.Country,
         i.InvoiceDate,
         i.Total
FROM     Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
ORDER BY i.Total DESC
-- Query 11: INNER JOIN — Track name with its Genre name
SELECT   t.Name        AS track_name,
         t.Composer,
         g.Name        AS genre,
         t.UnitPrice,
         ROUND(t.Milliseconds / 60000.0, 2) AS duration_mins
FROM     Track t
INNER JOIN Genre g ON t.GenreId = g.GenreId
ORDER BY g.Name, t.Name
-- Query 12: INNER JOIN — Track with Album and Artist name
SELECT   ar.Name       AS artist_name,
         al.Title      AS album_title,
         t.Name        AS track_name,
         g.Name        AS genre,
         t.UnitPrice
FROM     Track t
INNER JOIN Album  al ON t.AlbumId  = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
INNER JOIN Genre  g  ON t.GenreId  = g.GenreId
ORDER BY ar.Name, al.Title, t.Name
-- Query 13: LEFT JOIN — All artists even those with no albums
SELECT   ar.Name      AS artist_name,
         al.Title     AS album_title
FROM     Artist ar
LEFT JOIN Album al ON ar.ArtistId = al.ArtistId
ORDER BY ar.Name
-- Query 14: LEFT JOIN — All customers and their total spend
-- (includes customers with no invoices)
SELECT   c.FirstName + ' ' + c.LastName  AS customer_name,
         c.Country,
         COALESCE(ROUND(SUM(i.Total), 2), 0) AS total_spent
FROM     Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName, c.Country
ORDER BY total_spent DESC
-- Query 15: Customers who spent more than the average customer
SELECT   c.FirstName + ' ' + c.LastName AS customer_name,
         c.Country,
         ROUND(SUM(i.Total), 2)          AS total_spent
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName, c.Country
HAVING   SUM(i.Total) > (
             SELECT AVG(customer_total)
             FROM (
                 SELECT SUM(Total) AS customer_total
                 FROM   Invoice
                 GROUP BY CustomerId
             ) AS avg_calc
         )
ORDER BY total_spent DESC
-- Query 16: Tracks that have never been purchased
SELECT   t.Name       AS track_name,
         ar.Name      AS artist_name,
         g.Name       AS genre
FROM     Track t
INNER JOIN Album  al ON t.AlbumId   = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
INNER JOIN Genre  g  ON t.GenreId   = g.GenreId
WHERE    t.TrackId NOT IN (
             SELECT TrackId FROM InvoiceLine
         )
ORDER BY ar.Name, t.Name
-- Query 17: Most purchased genre per country
SELECT   BillingCountry,
         Genre,
         total_purchases
FROM (
    SELECT   i.BillingCountry,
             g.Name AS Genre,
             COUNT(il.TrackId) AS total_purchases,
             RANK() OVER (
                 PARTITION BY i.BillingCountry
                 ORDER BY COUNT(il.TrackId) DESC
             ) AS rnk
    FROM     InvoiceLine il
    INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    INNER JOIN Track   t ON il.TrackId   = t.TrackId
    INNER JOIN Genre   g ON t.GenreId    = g.GenreId
    GROUP BY i.BillingCountry, g.Name
) AS ranked
WHERE rnk = 1
ORDER BY BillingCountry
-- Query 18: RANK customers by total spend globally
SELECT   c.FirstName + ' ' + c.LastName       AS customer_name,
         c.Country,
         ROUND(SUM(i.Total), 2)                AS total_spent,
         RANK() OVER (
             ORDER BY SUM(i.Total) DESC
         )                                      AS spend_rank
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName, c.Country
ORDER BY spend_rank
-- Query 19: RANK customers within each country
SELECT   c.FirstName + ' ' + c.LastName        AS customer_name,
         c.Country,
         ROUND(SUM(i.Total), 2)                 AS total_spent,
         RANK() OVER (
             PARTITION BY c.Country
             ORDER BY SUM(i.Total) DESC
         )                                       AS country_rank
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName, c.Country
ORDER BY c.Country, country_rank
-- Query 20: Running total of revenue by month within each year
SELECT   YEAR(InvoiceDate)                         AS invoice_year,
         MONTH(InvoiceDate)                        AS invoice_month,
         ROUND(SUM(Total), 2)                      AS monthly_revenue,
         ROUND(SUM(SUM(Total)) OVER (
             PARTITION BY YEAR(InvoiceDate)
             ORDER BY MONTH(InvoiceDate)
         ), 2)                                      AS running_total
FROM     Invoice
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY invoice_year, invoice_month
-- Query 21: ROW_NUMBER — rank tracks within each album by duration
SELECT   ar.Name    AS artist,
         al.Title   AS album,
         t.Name     AS track,
         ROUND(t.Milliseconds / 60000.0, 2) AS duration_mins,
         ROW_NUMBER() OVER (
             PARTITION BY t.AlbumId
             ORDER BY t.Milliseconds DESC
         )          AS track_rank
FROM     Track t
INNER JOIN Album  al ON t.AlbumId   = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
ORDER BY ar.Name, al.Title, track_rank
-- Query 22: Top 10 customers by total spend
SELECT TOP 10
         c.FirstName + ' ' + c.LastName  AS customer_name,
         c.Country,
         c.Email,
         COUNT(i.InvoiceId)              AS total_purchases,
         ROUND(SUM(i.Total), 2)          AS total_spent,
         ROUND(AVG(i.Total), 2)          AS avg_purchase_value
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName, c.Country, c.Email
ORDER BY total_spent DESC
-- Query 23: Top 10 artists by tracks sold
SELECT TOP 10
         ar.Name                  AS artist_name,
         COUNT(il.TrackId)        AS tracks_sold,
         ROUND(SUM(il.UnitPrice), 2) AS revenue_generated
FROM     InvoiceLine il
INNER JOIN Track  t  ON il.TrackId   = t.TrackId
INNER JOIN Album  al ON t.AlbumId    = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId  = ar.ArtistId
GROUP BY ar.Name
ORDER BY tracks_sold DESC
-- Query 24: Revenue and track count by genre
SELECT   g.Name                      AS genre,
         COUNT(il.TrackId)           AS tracks_sold,
         ROUND(SUM(il.UnitPrice), 2) AS total_revenue,
         ROUND(AVG(il.UnitPrice), 2) AS avg_track_price
FROM     InvoiceLine il
INNER JOIN Track t ON il.TrackId = t.TrackId
INNER JOIN Genre g ON t.GenreId  = g.GenreId
GROUP BY g.Name
ORDER BY total_revenue DESC
-- Query 25: Monthly revenue trend
SELECT   YEAR(i.InvoiceDate)        AS invoice_year,
         MONTH(i.InvoiceDate)       AS invoice_month,
         COUNT(i.InvoiceId)         AS total_invoices,
         ROUND(SUM(i.Total), 2)     AS monthly_revenue
FROM     Invoice i
GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
ORDER BY invoice_year, invoice_month
-- Query 26: Best month per year
SELECT   invoice_year,
         invoice_month,
         monthly_revenue
FROM (
    SELECT   YEAR(InvoiceDate)                       AS invoice_year,
             MONTH(InvoiceDate)                      AS invoice_month,
             ROUND(SUM(Total), 2)                    AS monthly_revenue,
             RANK() OVER (
                 PARTITION BY YEAR(InvoiceDate)
                 ORDER BY SUM(Total) DESC
             )                                        AS rnk
    FROM     Invoice
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
) AS ranked
WHERE rnk = 1
ORDER BY invoice_year
-- Query 27: Revenue by country with customer count
SELECT   c.Country,
         COUNT(DISTINCT c.CustomerId)  AS total_customers,
         COUNT(i.InvoiceId)            AS total_invoices,
         ROUND(SUM(i.Total), 2)        AS total_revenue,
         ROUND(AVG(i.Total), 2)        AS avg_order_value
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY total_revenue DESC
-- Query 28: Employee sales performance
SELECT   e.FirstName + ' ' + e.LastName   AS employee_name,
         e.Title,
         e.HireDate,
         COUNT(i.InvoiceId)               AS total_invoices,
         ROUND(SUM(i.Total), 2)           AS total_revenue,
         ROUND(AVG(i.Total), 2)           AS avg_sale
FROM     Employee e
INNER JOIN Customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice  i ON c.CustomerId = i.CustomerId
GROUP BY e.FirstName, e.LastName, e.Title, e.HireDate
ORDER BY total_revenue DESC
-- Query 29: Top 10 albums by tracks sold
SELECT TOP 10
         ar.Name                     AS artist_name,
         al.Title                    AS album_title,
         COUNT(il.TrackId)           AS tracks_sold,
         ROUND(SUM(il.UnitPrice), 2) AS total_revenue
FROM     InvoiceLine il
INNER JOIN Track  t  ON il.TrackId  = t.TrackId
INNER JOIN Album  al ON t.AlbumId   = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name, al.Title
ORDER BY tracks_sold DESC
-- Query 30: Unsold tracks — inventory dead weight
SELECT   ar.Name   AS artist_name,
         al.Title  AS album_title,
         t.Name    AS track_name,
         g.Name    AS genre,
         t.UnitPrice
FROM     Track t
INNER JOIN Album  al ON t.AlbumId   = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
INNER JOIN Genre  g  ON t.GenreId   = g.GenreId
WHERE    t.TrackId NOT IN (
             SELECT TrackId FROM InvoiceLine
         )
ORDER BY ar.Name, al.Title
-- Index on Invoice table (most queried table)
CREATE INDEX idx_invoice_customerid
    ON Invoice (CustomerId);

CREATE INDEX idx_invoice_date
    ON Invoice (InvoiceDate);

CREATE INDEX idx_invoice_country
    ON Invoice (BillingCountry);

-- Index on Track table
CREATE INDEX idx_track_albumid
    ON Track (AlbumId);

CREATE INDEX idx_track_genreid
    ON Track (GenreId);

-- Index on InvoiceLine (used in every JOIN to Track)
CREATE INDEX idx_invoiceline_trackid
    ON InvoiceLine (TrackId);

CREATE INDEX idx_invoiceline_invoiceid
    ON InvoiceLine (InvoiceId)
    -- BEFORE: Slow — subquery runs once per customer row
SELECT   c.FirstName + ' ' + c.LastName AS customer_name,
         i.Total
FROM     Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE    i.Total > (SELECT AVG(Total) FROM Invoice)
-- AFTER: Fast — average computed once in CTE
WITH avg_cte AS (
    SELECT AVG(Total) AS overall_avg
    FROM   Invoice
)
SELECT   c.FirstName + ' ' + c.LastName  AS customer_name,
         c.Country,
         ROUND(i.Total, 2)               AS invoice_total,
         ROUND(a.overall_avg, 2)         AS company_avg
FROM     Invoice i
INNER JOIN Customer c ON i.CustomerId = c.CustomerId
CROSS JOIN avg_cte a
WHERE    i.Total > a.overall_avg
ORDER BY i.Total DESC
-- YoY revenue growth per genre using LAG() and two CTEs
WITH yearly_genre AS (
    SELECT   g.Name                      AS genre,
             YEAR(i.InvoiceDate)         AS invoice_year,
             ROUND(SUM(il.UnitPrice), 2) AS revenue
    FROM     InvoiceLine il
    INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    INNER JOIN Track   t ON il.TrackId   = t.TrackId
    INNER JOIN Genre   g ON t.GenreId    = g.GenreId
    GROUP BY g.Name, YEAR(i.InvoiceDate)
),
with_growth AS (
    SELECT   genre,
             invoice_year,
             revenue,
             LAG(revenue) OVER (
                 PARTITION BY genre
                 ORDER BY invoice_year
             )                           AS prev_year_revenue,
             ROUND((revenue - LAG(revenue) OVER (
                 PARTITION BY genre
                 ORDER BY invoice_year)
             ) / NULLIF(LAG(revenue) OVER (
                 PARTITION BY genre
                 ORDER BY invoice_year), 0) * 100, 2) AS growth_pct
    FROM     yearly_genre
)
SELECT   genre,
         invoice_year,
         revenue,
         prev_year_revenue,
         COALESCE(CAST(growth_pct AS VARCHAR) + '%', 'Base year') AS yoy_growth
FROM     with_growth
ORDER BY genre, invoice_year
-- Top spending customer in each country
WITH ranked_customers AS (
    SELECT   c.FirstName + ' ' + c.LastName  AS customer_name,
             c.Country,
             ROUND(SUM(i.Total), 2)           AS total_spent,
             RANK() OVER (
                 PARTITION BY c.Country
                 ORDER BY SUM(i.Total) DESC
             )                                 AS rnk
    FROM     Customer c
    INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.FirstName, c.LastName, c.Country
)
SELECT   country,
         customer_name,
         total_spent
FROM     ranked_customers
WHERE    rnk = 1
ORDER BY total_spent DESC