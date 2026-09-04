CREATE DATABASE placement_db;

USE placement_db;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    roll_no VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    password VARCHAR(100),
    cgpa DECIMAL(3,2),
    branch VARCHAR(50)
);

CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    industry VARCHAR(50)
);

CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    title VARCHAR(100),
    min_cgpa DECIMAL(3,2),
    eligible_branches TEXT,   -- comma separated
    required_skills TEXT,     -- comma separated
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    job_id INT,
    status VARCHAR(20), -- PENDING, SHORTLISTED, REJECTED
    applied_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);