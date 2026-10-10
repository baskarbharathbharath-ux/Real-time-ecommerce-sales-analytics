"""
Simulate e-commerce orders and insert them into Oracle Database.
Stop safely with Ctrl+C.
"""
import os
import random
import time
from datetime import datetime
from decimal import Decimal
import oracledb
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv("ORACLE_USER")
DB_PASSWORD = os.getenv("ORACLE_PASSWORD")
DB_DSN = os.getenv("ORACLE_DSN")
INTERVAL_SECONDS = float(os.getenv("INTERVAL_SECONDS", "5"))

PRODUCTS = [
    ("P1001", "Wireless Mouse", "Electronics", Decimal("799.00")),
    ("P1002", "Bluetooth Speaker", "Electronics", Decimal("2499.00")),
    ("P1003", "Cotton T-Shirt", "Fashion", Decimal("599.00")),
    ("P1004", "Running Shoes", "Fashion", Decimal("2199.00")),
    ("P1005", "Water Bottle", "Home", Decimal("399.00")),
    ("P1006", "Desk Lamp", "Home", Decimal("1299.00")),
    ("P1007", "Notebook Set", "Stationery", Decimal("249.00")),
    ("P1008", "Backpack", "Accessories", Decimal("1599.00")),
]
CITIES = ["Chennai", "Bengaluru", "Hyderabad", "Mumbai", "Pune", "Coimbatore", "Delhi"]
PAYMENTS = ["UPI", "CARD", "COD", "NET_BANKING", "WALLET"]
STATUSES = ["COMPLETED", "COMPLETED", "COMPLETED", "PROCESSING", "CANCELLED"]

def next_order_id(cursor):
    cursor.execute("SELECT NVL(MAX(order_id), 100000) + 1 FROM ecommerce_orders")
    return int(cursor.fetchone()[0])

def make_order(order_id):
    product_id, product_name, category, price = random.choice(PRODUCTS)
    quantity = random.randint(1, 4)
    discount_pct = random.choice([0, 0, 0.05, 0.10, 0.15, 0.20])
    gross = price * quantity
    discount_amount = (gross * Decimal(str(discount_pct))).quantize(Decimal("0.01"))
    net_amount = (gross - discount_amount).quantize(Decimal("0.01"))
    return {
        "order_id": order_id,
        "order_timestamp": datetime.now(),
        "customer_id": random.randint(1001, 1500),
        "product_id": product_id,
        "product_name": product_name,
        "category": category,
        "quantity": quantity,
        "unit_price": price,
        "discount_pct": Decimal(str(discount_pct)),
        "net_amount": net_amount,
        "payment_method": random.choice(PAYMENTS),
        "city": random.choice(CITIES),
        "order_status": random.choice(STATUSES),
    }

INSERT_SQL = """
INSERT INTO ecommerce_orders (
    order_id, order_timestamp, customer_id, product_id, product_name, category,
    quantity, unit_price, discount_pct, net_amount, payment_method, city, order_status
) VALUES (
    :order_id, :order_timestamp, :customer_id, :product_id, :product_name, :category,
    :quantity, :unit_price, :discount_pct, :net_amount, :payment_method, :city, :order_status
)
"""

def main():
    if not all([DB_USER, DB_PASSWORD, DB_DSN]):
        raise SystemExit("Missing Oracle settings. Copy .env.example to .env and fill in credentials.")

    print("Connecting to Oracle...")
    with oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN) as conn:
        with conn.cursor() as cur:
            order_id = next_order_id(cur)
            print(f"Simulator running; interval={INTERVAL_SECONDS}s. Press Ctrl+C to stop.")
            while True:
                row = make_order(order_id)
                cur.execute(INSERT_SQL, row)
                conn.commit()
                print(
                    f"{row['order_timestamp']:%Y-%m-%d %H:%M:%S} | "
                    f"Order {order_id} | {row['product_name']} | "
                    f"₹{row['net_amount']} | {row['order_status']}"
                )
                order_id += 1
                time.sleep(INTERVAL_SECONDS)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nSimulator stopped.")
