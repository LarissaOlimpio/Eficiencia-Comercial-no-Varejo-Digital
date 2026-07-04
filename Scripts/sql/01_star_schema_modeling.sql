/*
  Project: Sales Analysis
  Step: Data Modeling (Star Schema)
  Description: Creation of dimension and fact tables.
*/
-- Create database

create database db_sales;
use db_sales;

-- 1. Create Dimension Tables
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name TEXT,
    category TEXT
);

CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region TEXT
);

CREATE TABLE payment_methods (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_method TEXT
);

-- 2. Create Fact Table
CREATE TABLE sales (
    transaction_id INT PRIMARY KEY,
    date TEXT,
    year INT,
    month INT,
    month_name TEXT,
    quarter TEXT,
    product_id INT,
    region_id INT,
    payment_id INT,
    units INT,
    unit_price DOUBLE,
    revenue DOUBLE,
    -- Establishing relationships
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (payment_id) REFERENCES payment_methods(payment_id)
);