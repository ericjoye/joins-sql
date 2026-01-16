-- ============================================
-- SQL JOINS COMPREHENSIVE EXAMPLES
-- Portfolio Project demonstrating all join types
-- ============================================

USE company_db;

-- ============================================
-- 1. INNER JOIN
-- Returns only matching records from both tables
-- ============================================

-- Example 1.1: Get employees with their department information
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.department_id
ORDER BY e.employee_id;

-- Example 1.2: Get employees and their project assignments
SELECT
    e.first_name,
    e.last_name,
    p.project_name,
    ep.role,
    ep.hours_worked
FROM employees e
INNER JOIN employee_projects ep
    ON e.employee_id = ep.employee_id
INNER JOIN projects p
    ON ep.project_id = p.project_id
ORDER BY e.last_name, p.project_name;


-- ============================================
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- Returns all records from left table + matching from right
-- ============================================

-- Example 2.1: Get all employees and their departments (including those without departments)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
ORDER BY e.employee_id;

-- Example 2.2: Get all projects and their assigned employees (including projects without employees)
SELECT
    p.project_name,
    p.budget,
    e.first_name,
    e.last_name,
    ep.role
FROM projects p
LEFT JOIN employee_projects ep
    ON p.project_id = ep.project_id
LEFT JOIN employees e
    ON ep.employee_id = e.employee_id
ORDER BY p.project_name;


-- ============================================
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns all records from right table + matching from left
-- ============================================

-- Example 3.1: Get all departments and their employees (including departments without employees)
SELECT
    d.department_name,
    d.location,
    e.first_name,
    e.last_name,
    e.salary
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id
ORDER BY d.department_name, e.last_name;


-- ============================================
-- 4. FULL OUTER JOIN
-- Returns all records when there's a match in either table
-- Note: MySQL doesn't support FULL OUTER JOIN directly
-- Use UNION of LEFT and RIGHT joins
-- ============================================

-- Example 4.1: Get all employees and departments (show unmatched from both sides)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id

UNION

SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;


-- ============================================
-- 5. CROSS JOIN
-- Returns Cartesian product (all possible combinations)
-- ============================================

-- Example 5.1: Get all possible employee-project combinations
-- (Useful for generating all possible assignments)
SELECT
    e.first_name,
    e.last_name,
    p.project_name
FROM employees e
CROSS JOIN projects p
ORDER BY e.last_name, p.project_name;


-- ============================================
-- 6. SELF JOIN
-- Join a table to itself
-- ============================================

-- Example 6.1: Find employees in the same department (employee pairs)
SELECT
    e1.first_name AS employee1_first,
    e1.last_name AS employee1_last,
    e2.first_name AS employee2_first,
    e2.last_name AS employee2_last,
    d.department_name
FROM employees e1
INNER JOIN employees e2
    ON e1.department_id = e2.department_id
    AND e1.employee_id < e2.employee_id  -- Prevent duplicate pairs
INNER JOIN departments d
    ON e1.department_id = d.department_id
ORDER BY d.department_name;


-- ============================================
-- ADVANCED QUERIES WITH JOINS
-- ============================================

-- Example A1: Department employee count and average salary
SELECT
    d.department_name,
    d.location,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.location
ORDER BY employee_count DESC;

-- Example A2: Employees working on multiple projects
SELECT
    e.first_name,
    e.last_name,
    COUNT(ep.project_id) AS project_count,
    SUM(ep.hours_worked) AS total_hours
FROM employees e
INNER JOIN employee_projects ep
    ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(ep.project_id) > 1
ORDER BY project_count DESC;

-- Example A3: Projects with budget and total hours worked
SELECT
    p.project_name,
    p.budget,
    COUNT(DISTINCT ep.employee_id) AS team_size,
    SUM(ep.hours_worked) AS total_hours,
    ROUND(p.budget / NULLIF(SUM(ep.hours_worked), 0), 2) AS cost_per_hour
FROM projects p
LEFT JOIN employee_projects ep
    ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name, p.budget
ORDER BY p.project_name;

-- Example A4: Find employees not assigned to any project
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
LEFT JOIN employee_projects ep
    ON e.employee_id = ep.employee_id
LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE ep.employee_id IS NULL
ORDER BY e.last_name;

-- Example A5: Department project involvement
SELECT
    d.department_name,
    p.project_name,
    COUNT(DISTINCT e.employee_id) AS employees_assigned
FROM departments d
INNER JOIN employees e
    ON d.department_id = e.department_id
INNER JOIN employee_projects ep
    ON e.employee_id = ep.employee_id
INNER JOIN projects p
    ON ep.project_id = p.project_id
GROUP BY d.department_id, d.department_name, p.project_id, p.project_name
ORDER BY d.department_name, p.project_name;
