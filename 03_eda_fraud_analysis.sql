--Project: Fraud Detection Analysis
--File: 03_eda_fraud_analysis.sql
--Objective: Exploratory Data Analysis (EDA) and Business Relavent Insights
--=========================================================================

--1. Fraud Overview: Total transaction volume, fraud count, and overall fraud rate

SELECT
      COUNT(*) AS total_transactions,
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
      ROUND(CAST(SUM(CASE WHEN isFraud = 1 then 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_percentage
FROM cleaned_transactions;

--2. Financial Impact: Total financial loss and average amount comperison

SELECT
      FORMAT(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END), 'N2') AS total_fraud_loss,
      FORMAT(AVG(CASE WHEN isFraud = 1 THEN amount ELSE NULL END), 'N2') AS avg_fraud_amount,
      FORMAT(AVG(CASE WHEN isFraud = 0 THEN amount ELSE NULL END), 'N2') AS avg_normal_amount
FROM cleaned_transactions;

--3. Fraud Breakdown by Transactions Type: Identifying vulnerable channels

SELECT
     type,
     COUNT(*) AS total_transactions,
     SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
     FORMAT(SUM(CASE WHEN isFraud =1 THEN amount ELSE 0 END), 'N2') AS total_fraud_loss,
     ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_rate_precentage
FROM cleaned_transactions
GROUP BY type
ORDER BY fraud_transactions DESC;

--4. Behavior Analysis: Impact of drained account (Zero-Balance Anomaly)

SELECT
      is_account_emptied,
      COUNT(*) AS total_transactions,
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
      ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_rate_percentage
FROM cleaned_transactions
GROUP BY is_account_emptied;

--5. Legacy Detection System Benchmark: Evaluating rule-basced alerts

SELECT 
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS actual_fraud_cases,
      SUM(CASE WHEN isFlaggedFraud = 1 THEN 1 ELSE 0 END) AS flagged_by_system,
      SUM(CASE WHEN isFraud = 1 AND isFlaggedFraud = 1 THEN 1 ELSE 0 END) AS correctly_flagged,
      SUM(CASE WHEN isFraud = 1 AND isFlaggedFraud = 0 THEN 1 ELSE 0 END) AS missed_fraud
FROM cleaned_transactions;