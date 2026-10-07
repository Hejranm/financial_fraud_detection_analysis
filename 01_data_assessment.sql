
--Project: Fraud Detection Analysis
--file: 01_data_assessment.sql
--Objective: Initial sanity ckecks and null diagnostics
--Author: Hejran 


--1. Check data volume and count missing (NULL) values across all columns 
-- فحص اجمالي البيانات والقيم المفقودة 



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
-- معرفة اذا القيم الفارغة تقع ضمن العمليات الاحتيالية ام السليمة
SELECT 
      isFraud,
      COUNT(*) AS total_records,
      SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
      SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceOrg,
      SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS null_newdbalanceOrig,
      SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_olsdbalanceDEST
FROM transactions
GROUP BY isFraud; 

--3. Isolate fraud transactions containing NULL values accross any financial balance column
-- عزل حالات الاحتيال التي تحتوي القيم المفقودة في اي من الاعمدة المالية 

SELECT * FROM transactions
WHERE isFraud = 1
AND (amount is NULL 
     OR oldbalanceOrg IS NULL 
     OR oldbalanceDest IS NULL);

--4. Check for negative balances / amount and zero-values transactions 
-- فحص وجود قيم سالبة او مبالغ مالية تساوي صفر في الاعمدة المالية 

SELECT 
     COUNT(*) AS total_rows,
     SUM(CASE WHeN amount < 0 THEN 1 ELSE 0 END) AS negative_amount,
     SUM(CASE WHEN amount = 0 THEN 1 ELSE 0 END) AS zero_amount,

     SUM(CASE WHEN oldbalanceOrg < 0 THEN 1 ELSE 0 END) AS negative_oldbalanceOrg,
     SUM(CASE WHEN newbalanceOrig < 0 THEN 1 ELSE 0 END) AS negative_newbalanceOrig,

     SUM(CASE WHEN oldbalanceDest < 0 THEN 1 ELSE 0 END) AS negative_oldbalanceDest,
     SUM(CASE WHEN newbalanceDest < 0 THEN 1 ELSE 0 END) AS negative_newbalanceDest
FROM transactions;

--5. Check for fully duplicated records across transactions 
-- فحص سجلات مكررة متكاملة عبر جميع المعاملات 


SELECT 
     step, type, amount, nameOrig,nameDest, isFraud,
     COUNT(*) AS occurrence_count
FROM transactions
GROUP BY 
       step, type, amount, nameOrig, nameDest, isFraud
HAVING COUNT(*) > 1;


