
--Project: Fraud Detection Analysis
--file: 01_data_assessment.sql
--Objective: Initial sanity ckecks and null diagnostics
--Author: Hejran 


--1. Check data volume and count missing (NULL) values across all columns

SELECT TOP 1 * FROM transactions

SELECT 
      COUNT(*) AS total_rows,
      SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END) AS null_step,
      SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS null_type,
      SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount,

      SUM(CASE WHEN nameOrig IS NULL THEN 1 ELSE 0 END) AS null_nameOrig,
      SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceOrg,
      SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS null_newdbalanceOrig,

      SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END) AS null_nameDest,
      SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceDEST,
      SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_newdbalanceDest,

      SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END) AS null_isFraud,
      SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END) AS null_isFlaggedFraud
FROM transactions;

--2. Diagnose NULL distribution across Fraud vs NON-Fraud transactions

SELECT 
      COUNT(*) AS total_records,
      SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
      SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceOrg,
      SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS null_newdbalanceOrig,
      SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceDEST
FROM transactions
GROUP BY isFraud; 

--3. Fraud and NULL values

SELECT *FROM transactions
WHERE isFraud = 1 AND amount is NULL;


