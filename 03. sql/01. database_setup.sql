-- DATABASE SETUP

CREATE DATABASE kimia_farma;

USE kimia_farma;

CREATE TABLE transaction (
    transaction_id VARCHAR(20),
    date DATE,
    branch_id INT,
    customer_name VARCHAR(100),
    product_id VARCHAR(20),
    price INT,
    discount_percentage DOUBLE,
    rating DOUBLE
);

CREATE TABLE cabang (
    branch_id INT,
    branch_category VARCHAR(100),
    branch_name VARCHAR(255),
    kota VARCHAR(100),
    provinsi VARCHAR(100),
    rating DOUBLE
);

CREATE TABLE product (
    product_id VARCHAR(20),
    product_name VARCHAR(500),
    product_category VARCHAR(100),
    price INT
);

CREATE TABLE inventory (
    Inventory_ID VARCHAR(30),
    branch_id INT,
    product_id VARCHAR(20),
    product_name VARCHAR(500),
    opname_stock INT
);