
--Project: Fraud Detection Analysis
--file: 01_data_assessment.sql
--Objective: Initial sanity ckecks and null diagnostics
--Author: Hejran Mohammed
--=======================================================

--1. Check total records

SELECT COUNT(*) AS total_records FROM transactions;

--2. Check total columns count 

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transactions';

--3. Inspect Column Metadata & data type 

SELECT 
      COLUMN_NAME,
      DATA_TYPE,
      CHARACTER_MAXIMUM_LENGTH,
      IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transactions';

--4. Check for missing (NULL) values across all financial columns 
-- فحص اجمالي البيانات والقيم المفقودة 

SELECT 
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

--3. Comprehensive Numerical Range & Outlier Detection across All Numeric Columns
-- الهدف: تدقيق شامل لكافة الاعمدة الرقمية (القيم الصغرى, العظمى, والمتوسطة) لمعرفة الحدود الزمنية ورصد الارقام والمبالغ الشاذة والسالبة 

SELECT 
      MIN(step) AS min_step,
      MAX(step) AS max_step,

      MIN(amount) AS min_amount,
      AVG(amount) AS avg_amount,
      MAX(amount) AS max_amount,

      MIN(oldbalanceOrg) AS min_oldbalanceOrg,
      MAX(oldbalanceOrg) AS max_oldbalanceOrg,
      MIN(newbalanceOrig) AS min_newbalanceOrg,
      MAX(newbalanceOrig) AS max_newbalanceOrg,

      MIN(oldbalanceDest) AS min_oldbalanceDest,
      MAX(oldbalanceDest) AS max_oldbalanceDest,
      MIN(newbalanceDest) AS min_newbalanceDest,
      MAX(newbalanceDest) AS max_newbalanceDest,

      MIN(CAST(isFraud AS INT)) AS min_isFraud,
      MAX(CAST(isFraud AS INT)) AS max_isFraud,
      MIN(CAST(isFlaggedFraud AS INT)) AS min_isFlaggedFraud,
      MAX(CAST(isFlaggedFraud AS INT)) AS max_isFlaggedFraud
FROM transactions

--7. Text Colums Audit (Lengths, Patterns, and Blank Checks)
-- الهدف : فحص وتدقيق الاعمدة النصية منها فحص اطوال النصوص,البادئات المصرفية, ورصد الفراغات المخفية

 SELECT
      MIN(LEN(nameOrig)) AS min_len_orig,
      MAX(LEN(nameOrig)) AS max_len_orig,
      MIN(LEN(nameDest)) AS min_len_dest,
      MAX(LEN(namedest)) AS max_len_dest,


      COUNT(CASE WHEN nameOrig NOT LIKE 'C%' AND nameOrig NOT LIKE 'M%' THEN 1 END) AS invalid_nameOrig_prefix,
      COUNT(CASE WHEN nameDest NOT LIKE 'C%' AND nameDest NOT LIKE 'M%' THEN 1 END) AS invalid_nameDest_prefix,


      COUNT(CASE WHEN TRIM(type) = '' THEN 1 END) AS empty_type,
      COUNT(CASE WHEN TRIM(nameOrig) = '' THEN 1 END) AS empty_nameOrig,
      COUNT(CASE WHEN TRIM(nameDest) = '' THEN 1 END) AS empty_nameDest
FROM transactions;

--8. Check for fully duplicated records across transactions 
-- فحص وجود سجلات مكررة بالكامل عبر جميع الاعمدة 

SELECT 
     step, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig,
     nameDest,oldbalanceDest, newbalanceDest,isFraud, isFlaggedFraud,
     COUNT(*) AS occurrence_count
FROM transactions
GROUP BY 
       step, type, amount, nameOrig, nameDest, oldbalanceOrg, newbalanceOrig,
       nameDest,oldbalanceDest, newbalanceDest,isFraud, isFlaggedFraud
HAVING COUNT(*) > 1;

--9. Primary Key & Identity Column Audit
-- الهدف: التحقق من وجود مفتاح اساسي او معرف فريد للجدول

SELECT 
     K.TABLE_NAME,
     K.COLUMN_NAME,
     K.CONSTRAINT_NAMe
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS t
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k
     ON t.CONSTRAINT_NAME = K.CONSTRAINT_NAME
WHERE t.CONSTRAINT_TYPE = 'PRIMARY KEY'
AND t.TABLE_NAME = 'transactions'; 

