
# Insurance Analytics – SQL Project

## 📌 Project Overview

This project analyzes an insurance dataset using **MySQL** to identify customer, policy, premium, claim, and policy-status trends.

The objective is to extract meaningful business insights from insurance data using SQL queries and analytical techniques.

## 🎯 Business Objectives

The analysis focuses on:

- Customer and policy volume
- Claim amount analysis
- Coverage and premium analysis
- Active and inactive policies
- Customer demographics
- Policy type distribution
- Premium growth trends
- Policy expiry trends

## 🛠️ Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- SQL
- CTEs
- Aggregate Functions
- CASE Statements
- JOINs
- Window Functions
- Date Functions

## 📊 Key Analysis Performed

### Customer & Policy Analysis

1. Total number of customers
2. Total number of policies issued
3. Total claim amount
4. Average coverage amount per policy
5. Average premium amount per policy
6. Percentage of active policies
7. Policy count by status
8. Active vs inactive policy ratio

### Customer Demographics

9. Top age groups by policy count
10. Gender with the highest policy participation
11. Difference between male and female policy counts

### Policy Type Analysis

12. Policy type with the maximum number of policies
13. Policy type with the minimum number of policies
14. Comparison between Auto and Health policies
15. Policy distribution across policy types

### Premium & Time-Series Analysis

16. Average premium growth rate
17. Year-over-year premium growth trend
18. Difference between highest and lowest premium growth rates
19. Yearly trend of policies ending between 2016 and 2034

## 🔍 SQL Concepts Demonstrated

This project demonstrates practical use of:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `COUNT()`
- `SUM()`
- `AVG()`
- `ROUND()`
- `ABS()`
- `CASE WHEN`
- `JOIN`
- `CTE`
- `LAG()`
- `YEAR()`
- `NULLIF()`
- Window Functions

## 💡 Example Analysis

### Gender with highest policy participation

```sql
SELECT 
    c.gender,
    COUNT(p.policy_id) AS policy_count
FROM policy_details p
JOIN customer_information c 
    ON p.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY policy_count DESC
LIMIT 1;
```

### Premium Growth Analysis

The project uses `LAG()` to compare the average premium of the current year with the previous year and calculate year-over-year growth.

```sql
LAG(avg_premium) OVER (ORDER BY policy_year)
```

This helps identify whether premium values are increasing or decreasing over time.

## 📈 Business Insights

The analysis can help an insurance business understand:

- Which customer groups have higher policy participation
- Which policy types are most popular
- The proportion of active and inactive policies
- Changes in average premium over time
- Future policy expiry trends
- Differences in policy participation between customer demographics
- Claim and coverage patterns

## 📁 Project Files

```text
sql/
    insurance_analysis.sql

data/
    customer_information.csv
    payment_history.csv
    policy_details.csv
    additional_fields.csv
    claims.csv

screenshots/
    MySQL analysis screenshots
```

## 👨‍💻 Author

**Aditya Bhoyar**

Aspiring Data Analyst | SQL | Excel | Power BI | Python

GitHub: `https://github.com/Aditya-Bhoyar1409`

LinkedIn: `https://www.linkedin.com/in/aditya-bhoyar-252a76268`
