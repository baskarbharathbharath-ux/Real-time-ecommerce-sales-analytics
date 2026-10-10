-- Run while connected to the schema that will own the project objects.
CREATE TABLE ecommerce_orders (
    order_id        NUMBER(12)      PRIMARY KEY,
    order_timestamp TIMESTAMP       NOT NULL,
    customer_id     NUMBER(12)      NOT NULL,
    product_id      VARCHAR2(20)    NOT NULL,
    product_name    VARCHAR2(100)   NOT NULL,
    category        VARCHAR2(50)    NOT NULL,
    quantity        NUMBER(5)       NOT NULL CHECK (quantity > 0),
    unit_price      NUMBER(12,2)    NOT NULL CHECK (unit_price >= 0),
    discount_pct    NUMBER(5,4)     DEFAULT 0 NOT NULL CHECK (discount_pct BETWEEN 0 AND 1),
    net_amount      NUMBER(14,2)    NOT NULL CHECK (net_amount >= 0),
    payment_method  VARCHAR2(30)    NOT NULL,
    city            VARCHAR2(60)    NOT NULL,
    order_status    VARCHAR2(20)    NOT NULL,
    created_at      TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE INDEX ix_ecom_order_ts ON ecommerce_orders(order_timestamp);
CREATE INDEX ix_ecom_category ON ecommerce_orders(category);
CREATE INDEX ix_ecom_status ON ecommerce_orders(order_status);
