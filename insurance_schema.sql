DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS claims;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    dob DATE,
    address TEXT
);

CREATE TABLE agents (
    agent_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    region TEXT
);

CREATE TABLE policies (
    policy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    agent_id INTEGER,
    policy_type TEXT,
    start_date DATE,
    end_date DATE,
    premium REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

CREATE TABLE claims (
    claim_id INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id INTEGER,
    claim_date DATE,
    claim_amount REAL,
    claim_type TEXT,
    status TEXT,
    payout_amount REAL,
    is_fraud INTEGER,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);
