# Financial Fraud Detection Analysis

## Introduction

This project focuses on analyzing financial transaction data to identify fraudulent activities, explore transaction patterns, and uncover insights that can support fraud detection.

Using SQL Server and Power BI, the project covers data exploration, data cleaning, SQL-based analysis, and interactive dashboard development.

The goal is to transform raw transaction data into meaningful insights and highlight patterns associated with fraudulent transactions.

## Project Objectives

The main objectives of this project are:

- **Data Exploration:** Examine the transaction dataset and understand its structure and characteristics.
- **Data Cleaning:** Identify and handle missing values, review data types, and prepare the data for analysis.
- **Fraud Analysis:** Analyze fraudulent and legitimate transactions to identify patterns and trends.
- **Transaction Analysis:** Explore transaction types, amounts, and other relevant transaction characteristics.
- **Data Visualization:** Develop an interactive Power BI dashboard to present key findings and support data-driven insights.

## Tools & Technologies

- **SQL Server (T-SQL):** Data exploration, data cleaning, and transaction analysis.
- **Power BI:** Dashboard development, data visualization, and interactive reporting.

  ## Data Exploration & Cleaning

The initial stage focused on understanding the dataset and preparing it for analysis.

Key activities included:

- **Data Assessment:** Examining the dataset structure, total record count, and column information.
- **NULL Values Analysis:** Identifying, counting, and investigating missing (NULL) values across relevant columns.
- **Data Type Validation:** Reviewing and adjusting column data types to ensure consistency.
- **Data Preparation:** Preparing the dataset for further SQL analysis and visualization.

  ## SQL Analysis

Exploratory Data Analysis (EDA) was performed using T-SQL to investigate fraudulent transactions, assess financial impact, and identify suspicious transaction patterns.

The analysis covered:

1. **Fraud Overview:** Calculating total transactions, fraudulent and legitimate transaction counts, and overall fraud rates.
2. **Financial Impact:** Measuring total fraud losses and comparing average transaction amounts between fraudulent and legitimate transactions.
3. **Fraud by Transaction Type:** Analyzing fraud distribution and fraud rates across different transaction types.
4. **Transaction Value Comparison:** Comparing transaction counts, average amounts, minimum values, and maximum values between fraudulent and legitimate transactions.
5. **Behavior Analysis:** Investigating the relationship between zero-balance account anomalies and fraudulent transactions.
6. **Detection System Benchmark:** Evaluating the existing fraud detection system by examining correctly flagged and missed fraud cases.
7. **Unlabeled Fraud Detection:** Identifying legitimate-labeled transactions with balance discrepancies in Transfer and Cash Out operations.

## Power BI Dashboard

An interactive Power BI dashboard was developed to visualize financial transactions and highlight fraud-related patterns.

The dashboard provides:

- An overview of financial transactions.
- Visual analysis of fraudulent transactions.
- Interactive filters to explore transaction data.
- Charts and visualizations to support data-driven insights.

## Exploratory Data Analysis (EDA) & Key Findings

Using SQL Server (T-SQL), seven analytical queries were developed to explore fraudulent transactions, assess their financial impact, investigate transaction behavior, and evaluate existing fraud detection mechanisms.

### 1. Fraud Overview

Examined the overall transaction volume and compared fraudulent transactions with legitimate ones.

**Key Findings:**
- Total transactions: **200,000**
- Fraudulent transactions: **147**
- Legitimate transactions: **199,853**
- Fraud rate: **0.0735%**
- Legitimate transaction rate: **99.9265%**

### 2. Financial Impact Analysis

Evaluated the financial impact of fraudulent transactions by comparing transaction amounts, averages, and total monetary values.

**Key Findings:**
- Total transaction value: **36,142,233,373.33$**
- Total value of fraudulent transactions: **73,476,299.82$**
- Total value of legitimate transactions: **36,068,757,073.51$**
- Average fraudulent transaction amount: **499,838.77$**
- Average legitimate transaction amount: **180,476.44$**
- Fraudulent transaction value as a percentage of total transaction value: **0.20%$**

**Insight:** The average fraudulent transaction amount was approximately 2.77 times higher than the average legitimate transaction amount.

### 3. Fraud Breakdown by Transaction Type

Analyzed fraudulent transactions across different transaction types to identify potentially vulnerable channels.

**Key Findings:**

| Transaction Type | Total Transactions | Fraud Transactions | Fraud Rate |
|---|---:|---:|---:|
| CASH_OUT | 66,428 | 75 | 0.1128% |
| TRANSFER | 16,936 | 72 | 0.4277% |
| PAYMENT | 73,427 | 0 | 0% |
| CASH_IN | 41,579 | 0 | 0% |
| DEBIT | 1,670 | 0 | 0% |

- All 147 identified fraudulent transactions occurred within CASH_OUT and TRANSFER.
- TRANSFER recorded a higher fraud rate than CASH_OUT.
- TRANSFER accounted for approximately 38.05 million in fraudulent transaction value, compared to 35.43 million for CASH_OUT.

**Insight:** Although CASH_OUT had a slightly higher number of fraudulent transactions, TRANSFER showed a higher fraud rate and a greater total fraudulent transaction value.

### 4. Transaction Value Comparison

Compared fraudulent and legitimate transactions based on their average, minimum, and maximum transaction amounts.

**Key Findings:**

| Metric | Legitimate | Fraudulent |
|---|---:|---:|
| Transaction Count | 199,853 | 147 |
| Average Amount | 180,476.44 | 499,838.77 |
| Minimum Amount | 0.32 | 0.00 |
| Maximum Amount | 6,419,835.50 | 5,460,003.00 |

**Insight:** Fraudulent transactions had a higher average amount, while legitimate transactions recorded a higher maximum transaction amount.

### 5. Account Drainage Behavior Analysis

Investigated the relationship between account drainage (zero-balance anomaly) and fraudulent transaction occurrence.

**Key Findings:**

| Account Status | Total Transactions | Fraud Count | Fraud Rate |
|---|---:|---:|---:|
| Non-Drained | 156,052 | 10 | 0.0064% |
| Drained | 43,948 | 137 | 0.3117% |

- 137 fraudulent transactions occurred within the drained-account group.
- Only 10 fraudulent transactions occurred within the non-drained group.
- The fraud rate among drained-account transactions was approximately 48.7 times higher.

**Insight:** Transactions involving drained accounts showed a substantially higher fraud rate, indicating a notable behavioral pattern associated with fraudulent activity.

### 6. Legacy Fraud Detection System Evaluation

Evaluated the existing rule-based fraud detection alerts by comparing actual fraudulent transactions against transactions flagged by the system.

**Key Findings:**
- Actual fraud cases: **147**
- Transactions flagged by the system: **0**
- Correctly flagged fraud cases: **0**
- Missed fraud cases: **147**
- Fraud detection recall: **0%**

**Insight:** The existing detection system failed to flag any of the 147 identified fraudulent transactions in the analyzed dataset, highlighting a significant gap in its detection performance.

### 7. Unlabeled Fraud Detection – Balance Discrepancy Analysis

Investigated transactions labeled as legitimate but showing discrepancies in original account balances.

The analysis focused on:
- Transactions labeled as legitimate (`isFraud = 0`).
- Transactions with non-zero original balance discrepancies.
- TRANSFER and CASH_OUT transaction types.

**Key Findings:**
- Suspicious unlabeled transactions: **78,745**
- Total suspicious transaction value: **27,145,655,144.98**
- Average suspicious transaction amount: **344,728.62**

**Insight:** The analysis identified a substantial volume of potentially suspicious transactions that were labeled as legitimate but showed original balance discrepancies, highlighting the need for further investigation beyond existing fraud labels.

*Note: These transactions are classified as potentially suspicious based on balance discrepancies, not as confirmed fraudulent transactions.*

## Conclusion

This project demonstrates an end-to-end data analysis workflow for financial fraud detection, from data exploration and cleaning to SQL-based analysis and interactive Power BI visualization.

Through this project, I applied analytical techniques to:

- Examine financial transaction patterns.
- Identify trends associated with fraudulent activities.
- Evaluate the financial impact of fraudulent transactions.
- Investigate account behavior and balance discrepancies.
- Assess the performance of an existing fraud detection system.

The findings highlight the importance of data-driven analysis in understanding financial fraud patterns and identifying potentially suspicious activities.

## Author

**Hejran Mohammed**

Data Analysis | SQL Server | Power BI

This project was developed as part of my practical journey in data analysis, focusing on financial fraud detection and analytical problem-solving.
