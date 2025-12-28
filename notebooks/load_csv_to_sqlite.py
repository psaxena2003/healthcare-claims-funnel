import sqlite3
import pandas as pd

# Paths
db_path = "healthcare-claims-funnel/healthcare_claims.db"
csv_path = "healthcare-claims-funnel/data/cleaned/healthcare_claims_cleaned_final.csv"

# Connect to SQLite
conn = sqlite3.connect(db_path)

# Read CSV
df = pd.read_csv(csv_path)

# Load into SQLite
df.to_sql(
    "healthcare_claims",
    conn,
    if_exists="append",   # table already exists
    index=False
)

conn.close()

print("✅ CSV successfully loaded into SQLite")
