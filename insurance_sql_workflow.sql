-- 1. Basic Querying: Find large claims
SELECT * FROM claims
WHERE claim_amount > 10000;

-- 2. Transformation: Add and set claim severity
ALTER TABLE claims ADD COLUMN claim_severity TEXT;
UPDATE claims
SET claim_severity = CASE
    WHEN claim_amount > 10000 THEN 'High'
    WHEN claim_amount BETWEEN 5000 AND 10000 THEN 'Medium'
    ELSE 'Low'
END;

-- 3. Advanced Querying: Monthly trends & customer ranking
-- a. Monthly claim summary by severity
SELECT
    strftime('%Y-%m', claim_date) AS claim_month,
    claim_severity,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_amount
FROM claims
GROUP BY claim_month, claim_severity
ORDER BY claim_month DESC, claim_severity DESC;

-- b. Window function: Rank customers by claim amount
SELECT
    c.name,
    SUM(cl.claim_amount) AS total_claimed,
    RANK() OVER (ORDER BY SUM(cl.claim_amount) DESC) AS rank_claimed
FROM customers c
JOIN policies p ON c.customer_id = p.customer_id
JOIN claims cl ON p.policy_id = cl.policy_id
GROUP BY c.name;

-- 4. Optimization: Indexes and Top Customers Subquery
CREATE INDEX idx_claim_amount ON claims(claim_amount);
CREATE INDEX idx_claim_date ON claims(claim_date);

SELECT name, total_claimed FROM (
    SELECT
        c.name,
        SUM(cl.claim_amount) AS total_claimed
    FROM customers c
    JOIN policies p ON c.customer_id = p.customer_id
    JOIN claims cl ON p.policy_id = cl.policy_id
    GROUP BY c.name
) ORDER BY total_claimed DESC LIMIT 10;

-- 5. Views: Monthly Fraud and High Severity
CREATE VIEW monthly_fraud_summary AS
SELECT
    strftime('%Y-%m', claim_date) AS claim_month,
    COUNT(*) AS total_fraud_claims,
    SUM(claim_amount) AS total_fraud_amount
FROM claims
WHERE is_fraud = 1
GROUP BY claim_month;

CREATE VIEW high_severity_claims AS
SELECT * FROM claims WHERE claim_severity = 'High';

-- Done: Modular, performant workflow for insurance analytics!
