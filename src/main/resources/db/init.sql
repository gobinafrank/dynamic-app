-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS javaapp;

-- Use the database
USE javaapp;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data if the table is empty
INSERT INTO users (name, email)
SELECT 'John Doe', 'john@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'john@example.com');

INSERT INTO users (name, email)
SELECT 'Jane Smith', 'jane@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'jane@example.com');

INSERT INTO users (name, email)
SELECT 'Bob Johnson', 'bob@example.com'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'bob@example.com');
