-- Project: Fraud Detection Analysis
-- File: 02_data_cleaning.sql
-- Objective: Cleaning missing values and engineering transaction freatures 
-- Author: Hejran Mohammed 
--=========================================================================

--1. Investigate transactions with missing amount values 
-- Found 2 records values; retained NULL values (not replaced with 0)

SELECT * FROM dbo.transactions
WHERE amount IS NULL;

--2. Count missing oldbalanceOrg values grouped by transactions type

SELECT 
     type,
     COUNT(*) AS null_records 
     FROM dbo.transactions
     WHERE oldbalanceOrg IS NULL 
     GROUP BY type;

--3. Compare missing values in oldbalanceOrg and newbalanceOrig 

SELECT 
      COUNT(*) AS total_null_oldbalance,
      SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS both_null,
      SUM(CASE WHEN newbalanceOrig IS NOT NULL THEN 1 ELSE 0 END) AS old_null_only
FROM dbo.transactions
WHERE oldbalanceOrg IS NULL;

--4. Investigate records where oldbalanceOrig is null but newbalanceOrig is not null

SELECT 
     step,
     type,
     amount,
     nameOrig,
     oldbalanceOrg,
     newbalanceOrig,
     isFraud
FROM dbo.transactions
WHERE oldbalanceOrg IS NULL AND newbalanceOrig IS NOT NULL;

--5. Count missing newoldabalance values groped by transactions type

SELECT 
      type,
      COUNT(*) AS null_records
FROM dbo.transactions
WHERE newbalanceOrig IS NULL 
GROUP BY type;

SELECT COUNT(*) AS null_oldbalanceOrig
FROM dbo.transactions
WHERE oldbalanceOrg IS NULL;

SELECT COUNT(*) AS null_newbalanceOrig
FROM dbo.transactions
WHERE newbalanceOrig IS NULL;

--6. Count missing oldbalanceDest values grouped by transactions type 

SELECT 
     type,
     COUNT(*) AS null_records 
FROM dbo.transactions 
WHERE oldbalanceDest IS NULL 
GROUP BY type;

DROP TABLE IF EXISTS cleaned_transactions;

--7. Create cleaned transactions table: handling NULLs and Casting data types values in one step
-- Add Surrogate Primary Key (Transaction ID) 
-- الهدف: انشاء جدول معاملات جديد خالي من القيم المفقودة تماما مع ضبط انواع البيانات لتوفير مساحة تخزين في الذاكرة 
-- واستبدال انواع البيانات التي لا تقبل دوال الجمع بأخرى تقبلها لتسهيل المعاملات الرياضية
-- اعطاء كل معاملة رقم تعريفي مميز لتتبع العمليات وتسريع الاستعلامات 
 
 SELECT 
       IDENTITY(INT,1,1) AS transaction_id,
       step,
       CAST(type AS varchar(10)) AS type,
       CAST(COALESCE(amount, 0) AS decimal(18,2)) AS amount,
       CAST(nameOrig AS varchar(15)) AS nameOrig,
       CAST(COALESCE(oldbalanceOrg, 0) AS decimal(18,2)) oldbalanceOrg,
       CAST(COALESCE(newbalanceOrig, 0) AS decimal(18,2)) newbalanceOrig,
       CAST(nameDest AS varchar(15)) AS nameDest,
       CAST(COALESCE(oldbalanceDest,0) AS decimal(18,2)) oldbalanceDest,
       CAST(COALESCE(newbalanceDest,0) AS decimal(18,2)) newbalanceDest,
       CAST(isFraud AS tinyint) AS isFraud,
       isFlaggedFraud
INTO cleaned_transactions
FROM transactions;
 
--8. Add and calculate 'is_account_emptied' flag (Drain Account Indication) 
-- الهدف: المساعدة في كشف الاحتيال ورصد السلوك المشبوه فورا من خلال فحص فاتورة العميل قبل وبعد التحويل 

ALTER TABLE cleaned_transactions
ADD is_account_emptied INT;
GO
UPDATE cleaned_transactions
SET is_account_emptied = CASE
    WHEN oldbalanceOrg > 0 AND newbalanceOrig = 0 THEN 1 ELSE 0
END;
GO

--9. ADD and calculate balance discrepancy and error in the sender's and receiver's account to spot balance manipulation
--   الهدف: كشف اي تلاعب او خلل في الارصدة من خلال حساب الفارق الحسابي في رصيد المرسل والمستقبل

ALTER TABLE cleaned_transactions
ADD orig_balance_error DECIMAL(18,2) DEFAULT 0.00,
    dest_balance_error DECIMAL(18,2) DEFAULT 0.00;
GO
UPDATE cleaned_transactions
SET orig_balance_error =(oldbalanceOrg - amount) - newbalanceOrig,
    dest_balance_error =(oldbalanceDest - amount) - newbalanceDest;
GO

