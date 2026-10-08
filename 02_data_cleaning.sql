-- Project: Fraud Detection Analysis
-- File: 02_data_cleaning.sql
-- Objective: Cleaning missing values and engineering transaction freatures 
-- Author: Hejran Mohammed 

DROP TABLE IF EXISTS cleaned_transactions;

--1. Create cleaned transactions table and handle NULL values in financial fileds
 
 SELECT 
       step,
       type,
       COALESCE(amount, 0) AS amount,
       nameOrig,
       COALESCE(oldbalanceOrg, 0) AS oldbalanceOrg,
       COALESCE(newbalanceOrig, 0) AS newbalanceOrig,
       nameDest,
       COALESCE(oldbalanceDest,0) AS oldbalanceDest,
       COALESCE(newbalanceDest,0) AS newbalanceDest,
       isFraud,
       isFlaggedFraud
INTO cleaned_transactions
FROM transactions;

--2. Add and calculate 'is_account_emptied' flag (Drain Account Indication) 
-- اضافة اعمدة تساعد على كشف الاحتيال ورصد السلوك المشبوه فورا من خلال فحص فاتورة العميل 

ALTER TABLE cleaned_transactions
ADD is_account_emptied INT;
GO

UPDATE cleaned_transactions
SET is_account_emptied = CASE
    WHEN oldbalanceOrg > 0 AND newbalanceOrig = 0 THEN 1 ELSE 0
END;
GO

--3. ADD and calculate balance discrepancy for sender account

ALTER TABLE cleaned_transactions 
ADD orig_balance_error FLOAT;
GO

UPDATE cleaned_transactions
SET orig_balance_error = (newbalanceOrig + amount) - oldbalanceOrg;
go

--4. ADD and calculate balance discrepancy for destination account

ALTER TABLE cleaned_transactions
ADD dest_balance_error FLOAT;
GO

UPDATE cleaned_transactions
SET dest_balance_error = (oldbalanceDest + amount) - newbalanceDest;
GO