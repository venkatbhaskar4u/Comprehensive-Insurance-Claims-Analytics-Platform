import sqlite3
import random
import datetime

conn = sqlite3.connect('insurance.db')
cur = conn.cursor()

# Customers and Agents
customers = [
    ("Alice Smith", "1982-07-18", "123 Main St"),
    ("Bob Murray", "1976-04-11", "456 Cherry Ln"),
    ("Carol Lee", "1992-04-29", "789 Elm St"),
    ("David King", "1968-10-06", "135 Pine St"),
    ("Eva Stone", "1989-12-22", "357 Oak St")
]
agents = [
    ("Jim Jones", "West"),
    ("Susan Clark", "East"),
    ("Alex Ray", "South")
]

cur.executemany("INSERT INTO customers (name, dob, address) VALUES (?, ?, ?);", customers)
cur.executemany("INSERT INTO agents (name, region) VALUES (?, ?);", agents)

# Policies
policy_types = ["Auto", "Home", "Health", "Life"]
for i in range(1, 6):
    for j in range(1,4): # each customer has 3 policies with random agent
        cur.execute(
            "INSERT INTO policies (customer_id, agent_id, policy_type, start_date, end_date, premium) VALUES (?, ?, ?, ?, ?, ?);",
            (
                i,
                random.randint(1,3),
                random.choice(policy_types),
                "2021-01-01",
                "2026-01-01",
                round(random.uniform(500, 3500), 2)
            )
        )

# Claims
claim_types = ["Collision", "Theft", "Natural Disaster", "Medical"]
status_choices = ["Approved", "Pending", "Denied"]
for _ in range(60): # add 60 claims
    policy = random.randint(1,15)
    cdate = (datetime.date(2021,1,1) + datetime.timedelta(days=random.randint(0,1200)))
    claim_amt = round(random.uniform(300, 15000), 2)
    payout = claim_amt * (random.uniform(0.5, 1))
    is_fraud = 1 if claim_amt > 12000 and random.randint(0,1) else 0
    cur.execute(
        "INSERT INTO claims (policy_id, claim_date, claim_amount, claim_type, status, payout_amount, is_fraud) VALUES (?, ?, ?, ?, ?, ?, ?);",
        (
            policy,
            cdate.isoformat(),
            claim_amt,
            random.choice(claim_types),
            random.choice(status_choices),
            payout,
            is_fraud
        )
    )

conn.commit()
conn.close()
