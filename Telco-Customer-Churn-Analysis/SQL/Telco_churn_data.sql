select count(*) AS Total_rows 
from telco_customers
SELECT TOP 10 customerID, Contract, InternetService, OnlineSecurity, TechSupport, TotalCharges, Churn
FROM telco_customers
SELECT customerID, tenure, MonthlyCharges, TotalCharges
FROM telco_customers
WHERE TRIM(TotalCharges) = ''
SELECT customerID, tenure, MonthlyCharges, TotalCharges
FROM telco_customers
WHERE TotalCharges IS NULL
ALTER TABLE telco_customers
ADD TotalCharges_clean FLOAT
UPDATE telco_customers
SET TotalCharges_clean = 
    CASE 
        WHEN TotalCharges IS NULL THEN 0
        ELSE CAST(TotalCharges AS FLOAT)
    END
    SELECT COUNT(*) AS total_rows, 
       SUM(CASE WHEN TotalCharges_clean = 0 THEN 1 ELSE 0 END) AS zero_charge_rows
FROM telco_customers
ALTER TABLE telco_customers
ADD ChurnFlag TINYINT
UPDATE telco_customers
SET ChurnFlag = 
    CASE 
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END
    SELECT 
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC
SELECT 
    CASE 
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 36 THEN '25-36'
        WHEN tenure BETWEEN 37 AND 48 THEN '37-48'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60'
        ELSE '61-72'
    END AS tenure_bucket,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY 
    CASE 
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 36 THEN '25-36'
        WHEN tenure BETWEEN 37 AND 48 THEN '37-48'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60'
        ELSE '61-72'
    END
ORDER BY tenure_bucket
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC
SELECT 
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY TechSupport
ORDER BY churn_rate_pct DESC
SELECT 
    OnlineSecurity,
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers
GROUP BY OnlineSecurity
ORDER BY churn_rate_pct DESC
CREATE OR ALTER VIEW vw_churn_summary AS
SELECT 'Contract Type' AS driver, Contract AS segment, 
       COUNT(*) AS total_customers, SUM(ChurnFlag) AS churned, 
       ROUND(AVG(ChurnFlag * 1.0) * 100, 1) AS churn_rate_pct
FROM telco_customers GROUP BY Contract

UNION ALL

SELECT 'Internet Service', InternetService, 
       COUNT(*), SUM(ChurnFlag), 
       ROUND(AVG(ChurnFlag * 1.0) * 100, 1)
FROM telco_customers GROUP BY InternetService

UNION ALL

SELECT 'Payment Method', PaymentMethod, 
       COUNT(*), SUM(ChurnFlag), 
       ROUND(AVG(ChurnFlag * 1.0) * 100, 1)
FROM telco_customers GROUP BY PaymentMethod
SELECT * FROM vw_churn_summary ORDER BY driver, churn_rate_pct DESC