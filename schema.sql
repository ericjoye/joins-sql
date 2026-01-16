-- ============================================
-- SQL JOINS DEMO DATABASE SCHEMA
-- Portfolio Project by [Your Name]
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

-- ============================================
-- TABLE 1: employees
-- ============================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE
);

-- ============================================
-- TABLE 2: departments
-- ============================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

-- ============================================
-- TABLE 3: projects
-- ============================================
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(12, 2),
    start_date DATE
);

-- ============================================
-- TABLE 4: employee_projects (junction table)
-- ============================================
CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    hours_worked INT,
    PRIMARY KEY (employee_id, project_id)
);

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Insert Departments
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Engineering', 'New York'),
(2, 'Marketing', 'Los Angeles'),
(3, 'Sales', 'Chicago'),
(4, 'HR', 'Boston'),
(5, 'Finance', 'New York');

-- Insert Employees
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary, hire_date) VALUES
(101, 'John', 'Smith', 1, 85000.00, '2020-01-15'),
(102, 'Sarah', 'Johnson', 1, 92000.00, '2019-03-22'),
(103, 'Michael', 'Williams', 2, 68000.00, '2021-06-10'),
(104, 'Emily', 'Brown', 2, 71000.00, '2020-11-05'),
(105, 'David', 'Jones', 3, 75000.00, '2018-09-18'),
(106, 'Lisa', 'Garcia', NULL, 65000.00, '2022-02-14'),  -- No department assigned
(107, 'James', 'Martinez', 4, 62000.00, '2021-07-30'),
(108, 'Maria', 'Rodriguez', 1, 88000.00, '2019-12-01');

-- Insert Projects
INSERT INTO projects (project_id, project_name, budget, start_date) VALUES
(201, 'Website Redesign', 150000.00, '2023-01-10'),
(202, 'Mobile App Development', 300000.00, '2023-02-15'),
(203, 'Marketing Campaign Q1', 75000.00, '2023-01-05'),
(204, 'Database Migration', 200000.00, '2023-03-01'),
(205, 'AI Integration', 500000.00, '2023-04-20');  -- No employees assigned yet

-- Insert Employee-Project Assignments
INSERT INTO employee_projects (employee_id, project_id, role, hours_worked) VALUES
(101, 201, 'Lead Developer', 120),
(102, 201, 'Backend Developer', 100),
(101, 202, 'Technical Lead', 80),
(102, 202, 'Senior Developer', 95),
(103, 203, 'Campaign Manager', 140),
(104, 203, 'Content Creator', 110),
(105, 203, 'Sales Coordinator', 60),
(107, 204, 'Project Manager', 75),
(108, 204, 'Database Architect', 130);
