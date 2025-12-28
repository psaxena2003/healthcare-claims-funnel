-- database: ../healthcare_claims.db
-- ============================================================
-- Project: Healthcare Claims Funnel Analysis
-- Database: SQLite
-- Author: Priyanshi Saxena
-- Description:
-- Executive-level funnel, approval, revenue, and risk analysis
-- ============================================================
-- database: ./Healthcare_Folder/healthcare-claims-funnel/healthcare_claims.db

-- Use the ▷ button in the top right corner to run the entire file.

DROP TABLE IF EXISTS healthcare_claims;

CREATE TABLE healthcare_claims (
    claim_id TEXT PRIMARY KEY,
    claim_age INTEGER,
    patient_id TEXT,
    patient_name TEXT,
    provider_id TEXT,
    provider_name TEXT,
    claim_amount REAL,
    approved_amount REAL,
    claim_status TEXT,
    submission_date TEXT,
    adjudication_date TEXT,
    payment_date TEXT,
    denial_reason TEXT,
    is_approved INTEGER,
    is_denied INTEGER,
    adjudication_days INTEGER,
    payment_delay_days INTEGER,
    approved_missing_payment_flag INTEGER,
    denied_with_payment_flag INTEGER,
    claim_funnel_stage TEXT
);
SELECT COUNT(*) FROM healthcare_claims;
SELECT * FROM healthcare_claims LIMIT 5;
select claim_id, count(*) from healthcare_claims
group by claim_id
having count(*) > 1;
SELECT claim_funnel_stage, COUNT(*) AS claims_count
FROM healthcare_claims
GROUP BY claim_funnel_stage
ORDER BY claims_count DESC;
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
    ROUND(SUM(claim_amount), 2) AS total_claimed,
    ROUND(SUM(approved_amount), 2) AS total_approved,
    ROUND(SUM(claim_amount - approved_amount), 2) AS revenue_leakage
FROM healthcare_claims;
WITH stage_counts AS (
    SELECT
        claim_funnel_stage,
        COUNT(*) AS stage_count
    FROM healthcare_claims
    GROUP BY claim_funnel_stage
),
total AS (
    SELECT SUM(stage_count) AS total_claims FROM stage_counts
)
SELECT
    s.claim_funnel_stage,
    s.stage_count,
    ROUND(s.stage_count * 100.0 / t.total_claims, 2) AS pct_of_total
FROM stage_counts s
CROSS JOIN total t
ORDER BY pct_of_total DESC;
SELECT
    provider_name,
    COUNT(*) AS total_claims,
    SUM(is_approved) AS approved_claims,
    ROUND(SUM(is_approved) * 100.0 / COUNT(*), 2) AS approval_rate_pct
FROM healthcare_claims
GROUP BY provider_name
ORDER BY approval_rate_pct DESC;
SELECT
    denial_reason,
    COUNT(*) AS denial_count
FROM healthcare_claims
WHERE claim_status = 'Denied'
  AND denial_reason IS NOT NULL
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
LIMIT 10;
-- Approved but missing payment
SELECT COUNT(*) AS approved_missing_payment
FROM healthcare_claims
WHERE approved_missing_payment_flag = 1;
-- Denied but still paid
SELECT COUNT(*) AS denied_with_payment
FROM healthcare_claims
WHERE denied_with_payment_flag = 1;
SELECT
    strftime('%Y-%m', submission_date) AS submission_month,
    COUNT(*) AS total_claims,
    SUM(is_approved) AS approved_claims,
    ROUND(SUM(is_approved) * 100.0 / COUNT(*), 2) AS approval_rate_pct
FROM healthcare_claims
GROUP BY submission_month
ORDER BY submission_month;  