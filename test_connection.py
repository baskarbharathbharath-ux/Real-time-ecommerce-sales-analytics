import os
import sys
import oracledb
from dotenv import load_dotenv

load_dotenv()

user = os.getenv("ORACLE_USER")
password = os.getenv("ORACLE_PASSWORD")
dsn = os.getenv("ORACLE_DSN")

if not all([user, password, dsn]):
    sys.exit("Missing ORACLE_USER, ORACLE_PASSWORD, or ORACLE_DSN. Check your .env file.")

try:
    with oracledb.connect(user=user, password=password, dsn=dsn) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT SYSDATE FROM dual")
            print("Oracle connection successful. Database time:", cur.fetchone()[0])
except Exception as exc:
    sys.exit(f"Oracle connection failed: {exc}")
