--Project: Fraud Detection Analysis
--File: 03_eda_fraud_analysis.sql
--Objective: Exploratory Data Analysis (EDA) and Business Relavent Insights
--=========================================================================

--1. Fraud Overview: Total transaction volume, fraud count, and overall fraud rate
-- الهدف: معرفة المجموع الكلي لعمليات الاحتيال مقابل العمليات السليمة مع نسبة كل منهما

SELECT
      COUNT(*) AS total_transactions,
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS total_fraud_transactions,
      SUM(CASE WHEN isFraud = 0 THEN 1 ELSE 0 END) AS total_legit_transactions,
      ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_percentage,
      ROUND(CAST(SUM(CASE WHEN isFraud = 0 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS legit_precentage
FROM cleaned_transactions;


--2. Financial Impact: Total financial loss and average amount comperison
-- الهدف: حساب المجموع الكلي والمتوسط لمبالغ عمليات الاحتيال والعمليات السليمة مع حساب نسبة الخسائر المالية 

SELECT 
    FORMAT(SUM(amount), 'N2') AS total_monetary_volume,
    FORMAT(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END), 'N2') AS total_fraud_loss,
    FORMAT(SUM(CASE WHEN isFraud = 0 THEN amount ELSE 0 END), 'N2') AS total_legit_volume,
    FORMAT(AVG(CASE WHEN isFraud = 1 THEN amount ELSE NULL END), 'N2') AS avg_fraud_amount,
    FORMAT(AVG(CASE WHEN isFraud = 0 THEN amount ELSE NULL END), 'N2') AS avg_normal_amount,
    ROUND(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END) * 100.0 / SUM(amount), 
        2) AS fraud_loss_percentage
FROM cleaned_transactions;



--3. Fraud Breakdown by Transactions Type: Identifying vulnerable channels

SELECT
     type,
     COUNT(*) AS total_transactions,
     SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
     FORMAT(SUM(CASE WHEN isFraud =1 THEN amount ELSE 0 END), 'N2') AS total_fraud_loss,
     ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_rate_precentage,
     ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END) AS FLOAT) * 100 / NULLIF(SUM(amount), 0),2)
     AS fraud_amount_precentage
FROM cleaned_transactions
GROUP BY type
ORDER BY fraud_transactions DESC;

--4. Transaction Value Comparison (Fraud vs Legitimate)
-- الهدف:مقارنة المقاييس المالية (العدد، المتوسط، وأقل وأعلى مبلغ) بين العمليات الاحتيالية والسليمة لتحديد الأنماط السلوكية والشذوذ في القيم

SELECT 
    CASE WHEN isFraud = 1 THEN 'Fraudulent' ELSE 'Legitimate' 
    END AS transaction_nature,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS average_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount
FROM cleaned_transactions
GROUP BY isFraud;

--5. Behavior Analysis: Impact of drained account (Zero-Balance Anomaly)
-- قياس مدى ارتباط تصفير الحسابات بحدوث الاحتيالي 

SELECT
      is_account_emptied,
      COUNT(*) AS total_transactions,
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
      ROUND(CAST(SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*), 4) AS fraud_rate_percentage
FROM cleaned_transactions
GROUP BY is_account_emptied;

--6. Legacy Detection System Benchmark: Evaluating rule-basced alerts
-- تقييم كفاءة قاعدة النظام عبر النتبيهات الصادرة بحالات الفعلية لكشف حالات الاحتيال التي افلتت من النظام 

SELECT 
      SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) AS actual_fraud_cases,
      SUM(CASE WHEN isFlaggedFraud = 1 THEN 1 ELSE 0 END) AS flagged_by_system,
      SUM(CASE WHEN isFraud = 1 AND isFlaggedFraud = 1 THEN 1 ELSE 0 END) AS correctly_flagged,
      SUM(CASE WHEN isFraud = 1 AND isFlaggedFraud = 0 THEN 1 ELSE 0 END) AS missed_fraud
FROM cleaned_transactions;

--7. Unlabeled Fraud Detection (Balance Discrepancy Anomaly)
-- الهدف: كشف المعاملات المصنفة كسليمة ولكنها تحتوي على خلل حسابي في الارصدة مما يشير الى احتمالية وجود احتيال غير مكتشف 

SELECT 
      COUNT(*) AS suspicious_unlabeled_transactions,
      FORMAT(SUM(amount), 'N2') AS total_suspicious_volume,
      FORMAT(AVG(amount),'N2') AS avg_suspicious_amount
FROM cleaned_transactions
WHERE isFraud = 0
AND orig_balance_error != 0.00
AND TYPE IN ('TRANSFER', 'CASH_OUT');
