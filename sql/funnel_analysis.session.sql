USE healthcare_claims;

DROP TABLE IF EXISTS healthcare_claims;

CREATE TABLE healthcare_claims (
    claim_id VARCHAR(20) PRIMARY KEY,
    claim_age INT,
    patient_name VARCHAR(100),
    patient_id VARCHAR(20),
    provider_id VARCHAR(20),
    provider_name VARCHAR(100),
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    claim_status VARCHAR(20),
    submission_date DATE,
    adjudication_date DATE,
    payment_date DATE,
    denial_reason VARCHAR(255),
    is_approved TINYINT,
    is_denied TINYINT,
    adjudication_days INT,
    payment_delay_days INT,
    approved_missing_payment_flag TINYINT,
    denied_with_payment_flag TINYINT,
    claim_funnel_stage VARCHAR(50)
);
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/healthcare_claims_cleaned_final.csv'
INTO TABLE healthcare_claims
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    claim_id,
    claim_age,
    patient_id,
    patient_name,
    provider_id,
    provider_name,
    claim_amount,
    approved_amount,
    claim_status,
    @submission_date,
    @adjudication_date,
    @payment_date,
    denial_reason,
    is_approved,
    is_denied,
    adjudication_days,
    @payment_delay_days,
    approved_missing_payment_flag,
    denied_with_payment_flag,
    claim_funnel_stage
)
SET
    submission_date      = STR_TO_DATE(NULLIF(@submission_date, ''), '%Y-%m-%d'),
    adjudication_date    = STR_TO_DATE(NULLIF(@adjudication_date, ''), '%Y-%m-%d'),
    payment_date         = STR_TO_DATE(NULLIF(@payment_date, ''), '%Y-%m-%d'),
    payment_delay_days   = NULLIF(@payment_delay_days, '');

-- Basic Data Exploration Queries

SELECT count(*) FROM healthcare_claims;

SELECT claim_id, count(*) as is_duplicate
from healthcare_claims
group by claim_id
HAVING is_duplicate > 1;

SELECT claim_funnel_stage, COUNT(*)
FROM healthcare_claims
GROUP BY claim_funnel_stage;

SELECT
    COUNT(*) AS total_claims,
    SUM(is_approved) AS approved_claims,
    SUM(is_denied) AS denied_claims
FROM healthcare_claims;

SELECT
    ROUND(SUM(is_approved) * 100.0 / COUNT(*), 2) AS approval_rate_pct
FROM healthcare_claims;

SELECT
    provider_name,
    COUNT(*) AS total_claims,
    SUM(is_denied) AS denied_claims,
    ROUND(SUM(is_denied) * 100.0 / COUNT(*), 2) AS denial_rate_pct
FROM healthcare_claims
GROUP BY provider_name
ORDER BY denial_rate_pct DESC;

SELECT
    ROUND(AVG(adjudication_days), 2) AS avg_adjudication_days,
    ROUND(AVG(payment_delay_days), 2) AS avg_payment_delay_days
FROM healthcare_claims
WHERE claim_status = 'Approved';

SELECT
    SUM(claim_amount) AS total_claimed,
    SUM(approved_amount) AS total_approved,
    SUM(claim_amount - approved_amount) AS revenue_leakage
FROM healthcare_claims;

SELECT
    claim_funnel_stage,
    COUNT(*) AS claims_count
FROM healthcare_claims
GROUP BY claim_funnel_stage
ORDER BY claims_count DESC;

WITH stage_counts AS (
    SELECT
        claim_funnel_stage,
        COUNT(*) AS cnt
    FROM healthcare_claims
    GROUP BY claim_funnel_stage
),
total AS (
    SELECT SUM(cnt) AS total_claims FROM stage_counts
)
SELECT
    s.claim_funnel_stage,
    s.cnt,
    ROUND(s.cnt * 100.0 / t.total_claims, 2) AS pct_of_total
FROM stage_counts s
CROSS JOIN total t
ORDER BY pct_of_total DESC;

SELECT
    provider_name,
    COUNT(*) AS total_claims,
    SUM(is_approved) AS approved_claims,
    SUM(is_denied) AS denied_claims,
    ROUND(SUM(is_approved) * 100.0 / COUNT(*), 2) AS approval_rate_pct
FROM healthcare_claims
GROUP BY provider_name
ORDER BY approval_rate_pct DESC;

SELECT
    denial_reason,
    COUNT(*) AS denial_count
FROM healthcare_claims
WHERE claim_status = 'Denied'
GROUP BY denial_reason
ORDER BY denial_count DESC;

SELECT
    patient_name,
    COUNT(*) AS total_claims,
    SUM(is_denied) AS denied_claims,
    ROUND(SUM(is_denied) * 100.0 / COUNT(*), 2) AS denial_rate_pct
FROM healthcare_claims
GROUP BY patient_name
ORDER BY denial_rate_pct DESC
limit 10;

SELECT
    patient_name, COUNT(*) AS approved_missing_payment
FROM healthcare_claims
WHERE approved_missing_payment_flag = 1
GROUP BY patient_name;

SELECT
    COUNT(*) AS denied_with_payment
FROM healthcare_claims
WHERE denied_with_payment_flag = 1;

SELECT
    MONTH(submission_date) AS submission_month,
    COUNT(*) AS total_claims,
    SUM(is_approved) AS approved_claims,
    ROUND(SUM(is_approved) * 100.0 / COUNT(*), 2) AS approval_rate
FROM healthcare_claims
GROUP BY submission_month
ORDER BY submission_month;
