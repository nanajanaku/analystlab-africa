/* =====================================================================
   GDP Growth & Economic Performance — Data Cleaning & Transformation
   AnalystLab Africa Batch B Capstone Project
   Source: World Bank World Development Indicators (WDI)
   =====================================================================
   NOTE: Raw tables (WDI_Data, WDI_Country, WDI_Series) were imported
   into SSMS using the Import Flat File wizard from WDICSV.csv,
   WDICountry.csv, and WDISeries.csv respectively. Text columns were
   widened (nvarchar(max) where needed) to avoid truncation errors on
   long country/indicator names during import.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- STEP 1: Remove phantom header row imported as a literal data row
-- ---------------------------------------------------------------------
DELETE FROM WDI_Data WHERE column1 = 'Country Name';

-- ---------------------------------------------------------------------
-- STEP 2: Rename metadata columns
-- ---------------------------------------------------------------------
EXEC sp_rename 'WDI_Data.column1', 'CountryName', 'COLUMN';
EXEC sp_rename 'WDI_Data.column2', 'CountryCode', 'COLUMN';
EXEC sp_rename 'WDI_Data.column3', 'IndicatorName', 'COLUMN';
EXEC sp_rename 'WDI_Data.column4', 'IndicatorCode', 'COLUMN';

-- ---------------------------------------------------------------------
-- STEP 3: Rename year columns (column5..column70 -> Y1960..Y2025)
-- ---------------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @i INT = 5;
DECLARE @year INT = 1960;

WHILE @i <= 70
BEGIN
    SET @sql = @sql + 'EXEC sp_rename ''WDI_Data.column' + CAST(@i AS NVARCHAR(10)) +
                ''', ''Y' + CAST(@year AS NVARCHAR(4)) + ''', ''COLUMN'';' + CHAR(13);
    SET @i = @i + 1;
    SET @year = @year + 1;
END

EXEC sp_executesql @sql;

-- ---------------------------------------------------------------------
-- STEP 4: Filter to 10 countries x 9 GDP-related indicators
--         (individual countries only, aggregate regions excluded)
-- ---------------------------------------------------------------------
SELECT *
INTO WDI_GDP_Filtered
FROM WDI_Data
WHERE CountryName IN (
    'Nigeria', 'South Africa', 'Egypt, Arab Rep.', 'Kenya', 'Ghana',
    'India', 'Indonesia', 'Brazil',
    'United States', 'China'
)
AND IndicatorCode IN (
    'NY.GDP.MKTP.CD',       -- GDP (current US$)
    'NY.GDP.MKTP.KD.ZG',    -- GDP growth (annual %)
    'NY.GDP.PCAP.CD',       -- GDP per capita (current US$)
    'FP.CPI.TOTL.ZG',       -- Inflation, consumer prices (annual %)
    'BX.KLT.DINV.WD.GD.ZS', -- FDI, net inflows (% of GDP)
    'NE.GDI.TOTL.ZS',       -- Gross capital formation (% of GDP)
    'NE.EXP.GNFS.ZS',       -- Exports of goods and services (% of GDP)
    'NE.IMP.GNFS.ZS',       -- Imports of goods and services (% of GDP)
    'SL.UEM.TOTL.ZS'        -- Unemployment (% of labor force)
);

-- Sanity check: expect 10 countries x 9 indicators = 90 rows
SELECT CountryName, COUNT(*) AS IndicatorCount
FROM WDI_GDP_Filtered
GROUP BY CountryName
ORDER BY CountryName;

-- ---------------------------------------------------------------------
-- STEP 5: Cast year columns to FLOAT (fixes a data type mismatch that
--         blocked UNPIVOT) and reshape wide -> long format, 2000-2025.
--         UNPIVOT automatically drops NULLs, handling missing-data
--         cleanup in the same step.
-- ---------------------------------------------------------------------
SELECT
    CountryName,
    CountryCode,
    IndicatorName,
    IndicatorCode,
    CAST(RIGHT(YearColumn, 4) AS INT) AS Year,
    Value
INTO WDI_GDP_Long
FROM (
    SELECT
        CountryName,
        CountryCode,
        IndicatorName,
        IndicatorCode,
        CAST(Y2000 AS FLOAT) AS Y2000, CAST(Y2001 AS FLOAT) AS Y2001,
        CAST(Y2002 AS FLOAT) AS Y2002, CAST(Y2003 AS FLOAT) AS Y2003,
        CAST(Y2004 AS FLOAT) AS Y2004, CAST(Y2005 AS FLOAT) AS Y2005,
        CAST(Y2006 AS FLOAT) AS Y2006, CAST(Y2007 AS FLOAT) AS Y2007,
        CAST(Y2008 AS FLOAT) AS Y2008, CAST(Y2009 AS FLOAT) AS Y2009,
        CAST(Y2010 AS FLOAT) AS Y2010, CAST(Y2011 AS FLOAT) AS Y2011,
        CAST(Y2012 AS FLOAT) AS Y2012, CAST(Y2013 AS FLOAT) AS Y2013,
        CAST(Y2014 AS FLOAT) AS Y2014, CAST(Y2015 AS FLOAT) AS Y2015,
        CAST(Y2016 AS FLOAT) AS Y2016, CAST(Y2017 AS FLOAT) AS Y2017,
        CAST(Y2018 AS FLOAT) AS Y2018, CAST(Y2019 AS FLOAT) AS Y2019,
        CAST(Y2020 AS FLOAT) AS Y2020, CAST(Y2021 AS FLOAT) AS Y2021,
        CAST(Y2022 AS FLOAT) AS Y2022, CAST(Y2023 AS FLOAT) AS Y2023,
        CAST(Y2024 AS FLOAT) AS Y2024, CAST(Y2025 AS FLOAT) AS Y2025
    FROM WDI_GDP_Filtered
) AS src
UNPIVOT (
    Value FOR YearColumn IN (
        Y2000, Y2001, Y2002, Y2003, Y2004, Y2005, Y2006, Y2007, Y2008, Y2009,
        Y2010, Y2011, Y2012, Y2013, Y2014, Y2015, Y2016, Y2017, Y2018, Y2019,
        Y2020, Y2021, Y2022, Y2023, Y2024, Y2025
    )
) AS unpvt;

-- ---------------------------------------------------------------------
-- STEP 6: Validation checks
-- ---------------------------------------------------------------------

-- Row count and year range check
SELECT COUNT(*) AS TotalRows, MIN(Year) AS EarliestYear, MAX(Year) AS LatestYear
FROM WDI_GDP_Long;

-- Spot check: Nigeria GDP growth trend (validated against known
-- 2016 recession and 2020 COVID contraction)
SELECT Year, Value AS GDPGrowthPercent
FROM WDI_GDP_Long
WHERE CountryName = 'Nigeria'
  AND IndicatorCode = 'NY.GDP.MKTP.KD.ZG'
ORDER BY Year;

/* =====================================================================
   Result: WDI_GDP_Long — clean, long-format, Power BI-ready table
   (2,253 rows, 2000-2025, 10 countries x 9 indicators)
   ===================================================================== */
