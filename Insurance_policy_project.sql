#Create the db
CREATE DATABASE insurance_analytics;

#use of db
USE insurance_analytics;

SET GLOBAL local_infile = 1;

#CREATE TABLES
CREATE TABLE customer_information (
    customer_id     VARCHAR(15)   PRIMARY KEY,
    name            VARCHAR(60),
    gender          VARCHAR(10),
    age             INT,
    occupation      VARCHAR(80),
    marital_status  VARCHAR(20),
    address         VARCHAR(100)
);

CREATE TABLE policy_details (
    policy_id           VARCHAR(15)   PRIMARY KEY,
    policy_type         VARCHAR(20),
    coverage_amount     DECIMAL(12,2),
    premium_amount      DECIMAL(10,2),
    policy_start_date   DATE,
    policy_end_date     DATE,
    payment_frequency   VARCHAR(20),
    status              VARCHAR(20),
    customer_id         VARCHAR(15),
    FOREIGN KEY (customer_id) REFERENCES customer_information(customer_id)
);

CREATE TABLE claims (
    claim_id           VARCHAR(15)   PRIMARY KEY,
    date_of_claim       DATE,
    claim_amount         DECIMAL(12,2),
    claim_status         VARCHAR(20),
    reason_for_claim     VARCHAR(150),
    settlement_date      DATE,
    policy_id            VARCHAR(15),
    FOREIGN KEY (policy_id) REFERENCES policy_details(policy_id)
);

CREATE TABLE payment_history (
    payment_id       VARCHAR(15)   PRIMARY KEY,
    date_of_payment    DATE,
    amount_paid         DECIMAL(10,2),
    payment_method       VARCHAR(20),
    payment_status       VARCHAR(20),
    policy_id            VARCHAR(15),
    FOREIGN KEY (policy_id) REFERENCES policy_details(policy_id)
);

CREATE TABLE additional_fields (
    agent_id          VARCHAR(15),
    renewal_status      VARCHAR(20),
    policy_discounts     INT,
    risk_score           INT,
    policy_id            VARCHAR(15) PRIMARY KEY,
    FOREIGN KEY (policy_id) REFERENCES policy_details(policy_id)
);

#LOAD DATA
LOAD DATA LOCAL INFILE 'C:/Users/saksh/Downloads/customer_information (1).csv'
INTO TABLE customer_information
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, name, gender, age, occupation, marital_status, address);

LOAD DATA LOCAL INFILE 'C:/Users/saksh/Downloads/policy_details (1).csv'
INTO TABLE policy_details
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(policy_id, policy_type, coverage_amount, premium_amount, policy_start_date,
 policy_end_date, payment_frequency, status, customer_id);
 
LOAD DATA LOCAL INFILE 'C:/Users/saksh/Downloads/claims (1).csv'
INTO TABLE claims
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(claim_id, date_of_claim, claim_amount, claim_status, reason_for_claim,
 @settlement_date, policy_id)
SET settlement_date = NULLIF(@settlement_date, '');

LOAD DATA LOCAL INFILE 'C:/Users/saksh/Downloads/payment_history (1).csv'
INTO TABLE payment_history
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(payment_id, date_of_payment, amount_paid, payment_method, payment_status,
 policy_id);
 
LOAD DATA LOCAL INFILE 'C:/Users/saksh/Downloads/additional_fields (1).csv'
INTO TABLE additional_fields
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(agent_id, renewal_status, policy_discounts, risk_score, policy_id);

#CHECKING THE COUNT OF DATA
SELECT 'customer_information' AS tbl, COUNT(*) AS row_count FROM customer_information
UNION ALL SELECT 'policy_details', COUNT(*) FROM policy_details
UNION ALL SELECT 'claims', COUNT(*) FROM claims
UNION ALL SELECT 'payment_history', COUNT(*) FROM payment_history
UNION ALL SELECT 'additional_fields', COUNT(*) FROM additional_fields;

SELECT COUNT(*) AS total_claims,
       SUM(settlement_date IS NULL) AS null_settlement_dates
FROM claims;

#Section1 Customer and Policy Overview
# 1. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customer_information;

# 2. Total number of policies issued
SELECT COUNT(*) AS total_policies
FROM policy_details;

# 3. Total claim amount generated from all policies
SELECT SUM(claim_amount) AS total_claim_amount
FROM claims;

# 4. Average coverage amount per policy
SELECT AVG(coverage_amount) AS avg_coverage_amount
FROM policy_details;

# 5. Average premium amount collected per policy
SELECT AVG(premium_amount) AS avg_premium_amount
FROM policy_details;

#Section2 Policy Performance Analysis
# 6. Percentage of policies currently active
SELECT
    ROUND(
        100.0 * SUM(status = 'Active') / COUNT(*), 2
    ) AS pct_active_policies
FROM policy_details;
 
# 7. Count of policies by status (active, lapsed, terminated)
SELECT status, COUNT(*) AS policy_count
FROM policy_details
GROUP BY status
ORDER BY policy_count DESC;
 
# 8. Policy status with the highest number of policies
SELECT status, COUNT(*) AS policy_count
FROM policy_details
GROUP BY status
ORDER BY policy_count DESC
LIMIT 1;
 
# 9. Ratio between active and inactive policies
SELECT
    SUM(status = 'Active') AS active_count,
    SUM(status <> 'Active') AS inactive_count,
    ROUND(SUM(status = 'Active') / NULLIF(SUM(status <> 'Active'), 0), 2) AS active_to_inactive_ratio
FROM policy_details;
 
#Section3 Customer Demographics
# 10. Age group with the highest number of policies
SELECT
    CASE
        WHEN c.age BETWEEN 18 AND 29 THEN '18-29'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+'
    END AS age_group,
    COUNT(p.policy_id) AS policy_count
FROM policy_details p
JOIN customer_information c ON p.customer_id = c.customer_id
GROUP BY age_group
ORDER BY policy_count DESC
LIMIT 1;
 
# 11. Top three age groups by policy count
SELECT
    CASE
        WHEN c.age BETWEEN 18 AND 29 THEN '18-29'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+'
    END AS age_group,
    COUNT(p.policy_id) AS policy_count
FROM policy_details p
JOIN customer_information c ON p.customer_id = c.customer_id
GROUP BY age_group
ORDER BY policy_count DESC
LIMIT 3;
 
# 12. Gender with the highest policy participation
SELECT c.gender, COUNT(p.policy_id) AS policy_count
FROM policy_details p
JOIN customer_information c ON p.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY policy_count DESC
LIMIT 1;
 
# 13. Difference between male and female policy counts
SELECT
    SUM(c.gender = 'Male') AS male_policy_count,
    SUM(c.gender = 'Female') AS female_policy_count,
    ABS(SUM(c.gender = 'Male') - SUM(c.gender = 'Female')) AS male_female_difference
FROM policy_details p
JOIN customer_information c ON p.customer_id = c.customer_id;
 
#Section4 Policy Type Analysis
# 14. Policy type with the maximum number of policies
SELECT policy_type, COUNT(*) AS policy_count
FROM policy_details
GROUP BY policy_type
ORDER BY policy_count DESC
LIMIT 1;
 
# 15. Policy type with the minimum number of policies
SELECT policy_type, COUNT(*) AS policy_count
FROM policy_details
GROUP BY policy_type
ORDER BY policy_count ASC
LIMIT 1;
 
# 16. Compare Auto and Health policy counts
SELECT
    SUM(policy_type = 'Auto') AS auto_count,
    SUM(policy_type = 'Health') AS health_count
FROM policy_details;
 
# 17. Total number of policies across all policy types
SELECT policy_type, COUNT(*) AS policy_count
FROM policy_details
GROUP BY policy_type
ORDER BY policy_count DESC;
-- Grand total = same result as KPI #2

#Section5 Trend Analysis
# 18. Average premium growth rate over all years
WITH yearly_premium AS (
    SELECT
        YEAR(policy_start_date) AS policy_year,
        AVG(premium_amount) AS avg_premium
    FROM policy_details
    GROUP BY YEAR(policy_start_date)
),
growth AS (
    SELECT
        policy_year,
        avg_premium,
        100.0 * (avg_premium - LAG(avg_premium) OVER (ORDER BY policy_year))
            / NULLIF(LAG(avg_premium) OVER (ORDER BY policy_year), 0) AS growth_rate_pct
    FROM yearly_premium
)
SELECT ROUND(AVG(growth_rate_pct), 2) AS avg_premium_growth_rate_pct
FROM growth
WHERE growth_rate_pct IS NOT NULL;
 
# 19. Is the premium growth trend increasing or decreasing over time?
-- (inspect growth_rate_pct year over year to read the trend direction)
WITH yearly_premium AS (
    SELECT
        YEAR(policy_start_date) AS policy_year,
        AVG(premium_amount) AS avg_premium
    FROM policy_details
    GROUP BY YEAR(policy_start_date)
)
SELECT
    policy_year,
    avg_premium,
    100.0 * (avg_premium - LAG(avg_premium) OVER (ORDER BY policy_year))
        / NULLIF(LAG(avg_premium) OVER (ORDER BY policy_year), 0) AS growth_rate_pct
FROM yearly_premium
ORDER BY policy_year;
 
# 20. Difference between the highest and lowest premium growth rates
WITH yearly_premium AS (
    SELECT
        YEAR(policy_start_date) AS policy_year,
        AVG(premium_amount) AS avg_premium
    FROM policy_details
    GROUP BY YEAR(policy_start_date)
),
growth AS (
    SELECT
        policy_year,
        100.0 * (avg_premium - LAG(avg_premium) OVER (ORDER BY policy_year))
            / NULLIF(LAG(avg_premium) OVER (ORDER BY policy_year), 0) AS growth_rate_pct
    FROM yearly_premium
)
SELECT MAX(growth_rate_pct) - MIN(growth_rate_pct) AS growth_rate_range_pct
FROM growth
WHERE growth_rate_pct IS NOT NULL;
 
# 21. Yearly trend of policies ending from 2016 to 2034
SELECT
    YEAR(policy_end_date) AS end_year,
    COUNT(*) AS policies_ending
FROM policy_details
WHERE YEAR(policy_end_date) BETWEEN 2016 AND 2034
GROUP BY YEAR(policy_end_date)
ORDER BY end_year;