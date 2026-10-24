-- Project: Fraud Detection Analysis
-- File: 02_data_cleaning.sql
-- Objective: Cleaning missing values and engineering transaction freatures 
-- Author: Hejran Mohammed 

DROP TABLE IF EXISTS cleaned_transactions;

--1. Create cleaned transactions table: handling NULLs and Casting data types values in one step
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
 
--2. Add and calculate 'is_account_emptied' flag (Drain Account Indication) 
-- الهدف: المساعدة في كشف الاحتيال ورصد السلوك المشبوه فورا من خلال فحص فاتورة العميل قبل وبعد التحويل 

ALTER TABLE cleaned_transactions
ADD is_account_emptied INT;
GO
UPDATE cleaned_transactions
SET is_account_emptied = CASE
    WHEN oldbalanceOrg > 0 AND newbalanceOrig = 0 THEN 1 ELSE 0
END;
GO

--4. ADD and calculate balance discrepancy and error in the sender's and receiver's account to spot balance manipulation
--   الهدف: كشف اي تلاعب او خلل في الارصدة من خلال حساب الفارق الحسابي في رصيد المرسل والمستقبل

ALTER TABLE cleaned_transactions
ADD orig_balance_error DECIMAL(18,2) DEFAULT 0.00,
    dest_balance_error DECIMAL(18,2) DEFAULT 0.00;
GO
UPDATE cleaned_transactions
SET orig_balance_error =(oldbalanceOrg - amount) - newbalanceOrig,
    dest_balance_error =(oldbalanceDest - amount) - newbalanceDest;
GO

