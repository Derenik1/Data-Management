CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    join_date DATE,
    loyalty_points INT DEFAULT 0
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    product_id INT REFERENCES products(product_id),
    stock_quantity INT CHECK (stock_quantity >= 0),
    last_restock_date DATE
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    sale_date DATE
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    role VARCHAR(20) -- e.g. admin, staff, viewer
);

CREATE TABLE error_logs (
    log_id SERIAL PRIMARY KEY,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT,
    source VARCHAR(100)
);
