# Joins-SQL

Hands-on SQL JOIN examples with real-world data. Covers INNER, LEFT, RIGHT, FULL OUTER, CROSS, and SELF joins with visual diagrams and interview-ready queries.

## Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Join Types Demonstrated](#join-types-demonstrated)
  - [INNER JOIN](#inner-join)
  - [LEFT JOIN](#left-join)
  - [RIGHT JOIN](#right-join)
  - [FULL OUTER JOIN](#full-outer-join)
  - [CROSS JOIN](#cross-join)
  - [SELF JOIN](#self-join)
- [Advanced Queries](#advanced-queries)
- [Getting Started](#getting-started)
- [Sample Results](#sample-results)
- [Key Learning Outcomes](#key-learning-outcomes)

---

## Overview

This project demonstrates practical SQL join operations through a company management database that tracks:
- **Employees** and their department assignments
- **Departments** across different locations
- **Projects** with budgets and timelines
- **Employee-Project assignments** with roles and hours

The database is designed to showcase real-world scenarios including:
- Employees without department assignments
- Departments with no employees
- Projects without assigned staff
- Many-to-many relationships

---

## Database Schema

### Tables Structure

```
employees
├── employee_id (PK)
├── first_name
├── last_name
├── department_id (FK)
├── salary
└── hire_date

departments
├── department_id (PK)
├── department_name
└── location

projects
├── project_id (PK)
├── project_name
├── budget
└── start_date

employee_projects (Junction Table)
├── employee_id (FK)
├── project_id (FK)
├── role
└── hours_worked
```

### Entity Relationship

```
employees ──┬─< employee_projects >─┬── projects
            │                        │
            └──> departments
```

---

## Join Types Demonstrated

### INNER JOIN

**Purpose:** Returns only records that have matching values in both tables

**Use Case:** Get employees with their department information (excludes employees without departments)

**Visual Concept:**
```
Table A          Table B          Result
   ●                ●               ●
   ●  ─────────     ●  ──────►      ●
   ●                ○
   ○
```

**Example Query:**
```sql
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.department_id;
```

**Expected Output:** 7 rows (excludes Lisa Garcia who has no department)

---

### LEFT JOIN

**Purpose:** Returns all records from the left table + matching records from the right table

**Use Case:** Get all employees and their departments (includes employees without departments)

**Visual Concept:**
```
Table A          Table B          Result
   ●                ●               ●
   ●  ─────────     ●  ──────►      ●
   ●                ○               ● (NULL)
   ○                                ○ (NULL)
```

**Example Query:**
```sql
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;
```

**Expected Output:** 8 rows (includes Lisa Garcia with NULL department)

---

### RIGHT JOIN

**Purpose:** Returns all records from the right table + matching records from the left table

**Use Case:** Get all departments and their employees (includes empty departments)

**Visual Concept:**
```
Table A          Table B          Result
   ●                ●               ●
   ●  ─────────     ●  ──────►      ●
   ○                ●               ● (NULL)
                    ○               ○ (NULL)
```

**Example Query:**
```sql
SELECT
    d.department_name,
    e.first_name,
    e.last_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;
```

**Expected Output:** 8 rows (includes Finance department with no employees)

---

### FULL OUTER JOIN

**Purpose:** Returns all records when there's a match in either left or right table

**Use Case:** Get complete view of employees and departments (shows all unmatched records from both sides)

**Visual Concept:**
```
Table A          Table B          Result
   ●                ●               ●
   ●  ─────────     ●  ──────►      ●
   ●                ○               ● (NULL)
   ○                                ○ (NULL)
                    ●               ● (NULL)
                    ○               ○ (NULL)
```

**MySQL Implementation:**
```sql
-- MySQL uses UNION of LEFT and RIGHT joins
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id

UNION

SELECT e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;
```

---

### CROSS JOIN

**Purpose:** Returns Cartesian product (every row from Table A paired with every row from Table B)

**Use Case:** Generate all possible employee-project combinations for planning

**Visual Concept:**
```
Table A (3 rows)  ×  Table B (2 rows)  =  Result (6 rows)
   A1                     B1                 A1-B1
   A2                     B2                 A1-B2
   A3                                        A2-B1
                                             A2-B2
                                             A3-B1
                                             A3-B2
```

**Example Query:**
```sql
SELECT
    e.first_name,
    p.project_name
FROM employees e
CROSS JOIN projects p;
```

**Expected Output:** 40 rows (8 employees × 5 projects)

---

### SELF JOIN

**Purpose:** Join a table to itself to find relationships within the same table

**Use Case:** Find employee pairs working in the same department

**Visual Concept:**
```
employees (as e1)  ──┐
                     ├──> Compare department_id
employees (as e2)  ──┘
```

**Example Query:**
```sql
SELECT
    e1.first_name AS employee1,
    e2.first_name AS employee2,
    d.department_name
FROM employees e1
INNER JOIN employees e2
    ON e1.department_id = e2.department_id
    AND e1.employee_id < e2.employee_id
INNER JOIN departments d
    ON e1.department_id = d.department_id;
```

**Expected Output:** Shows employee pairs from same departments

---

## Advanced Queries

### 1. Department Statistics
- Employee count per department
- Average salary by department
- Uses LEFT JOIN to include empty departments

### 2. Multi-Project Employees
- Identifies employees on multiple projects
- Total hours worked
- Uses HAVING clause with joins

### 3. Project Budget Analysis
- Team size per project
- Total hours worked
- Cost per hour calculation
- Handles division by zero

### 4. Unassigned Employees
- Finds employees not on any project
- Uses LEFT JOIN with WHERE IS NULL pattern

### 5. Department Project Involvement
- Cross-departmental project analysis
- Multiple INNER JOINs across 4 tables

---

## Getting Started

### Prerequisites
- MySQL 5.7+ or MariaDB 10.2+
- MySQL Workbench (recommended) or command-line client

### Installation Steps

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/yourusername/sql-joins-portfolio.git
   cd sql-joins-portfolio
   ```

2. **Create the database and tables**
   ```bash
   mysql -u your_username -p < schema.sql
   ```

3. **Run the join examples**
   ```bash
   mysql -u your_username -p company_db < sql_joins_examples.sql
   ```

4. **Or use MySQL Workbench:**
   - Open `schema.sql` and execute
   - Open `sql_joins_examples.sql` and run queries individually

### Quick Test
```sql
USE company_db;
SELECT COUNT(*) FROM employees;  -- Should return 8
SELECT COUNT(*) FROM departments;  -- Should return 5
SELECT COUNT(*) FROM projects;  -- Should return 5
```

---

## Sample Results

### INNER JOIN Example Output
```
employee_id | first_name | last_name | department_name | location
------------|------------|-----------|-----------------|-------------
101         | John       | Smith     | Engineering     | New York
102         | Sarah      | Johnson   | Engineering     | New York
103         | Michael    | Williams  | Marketing       | Los Angeles
104         | Emily      | Brown     | Marketing       | Los Angeles
105         | David      | Jones     | Sales           | Chicago
107         | James      | Martinez  | HR              | Boston
108         | Maria      | Rodriguez | Engineering     | New York
```

### LEFT JOIN Example Output (Notice Lisa Garcia with NULL department)
```
employee_id | first_name | last_name | department_name | location
------------|------------|-----------|-----------------|-------------
101         | John       | Smith     | Engineering     | New York
102         | Sarah      | Johnson   | Engineering     | New York
103         | Michael    | Williams  | Marketing       | Los Angeles
104         | Emily      | Brown     | Marketing       | Los Angeles
105         | David      | Jones     | Sales           | Chicago
106         | Lisa       | Garcia    | NULL            | NULL
107         | James      | Martinez  | HR              | Boston
108         | Maria      | Rodriguez | Engineering     | New York
```

### Department Statistics (Advanced Query)
```
department_name | location     | employee_count | avg_salary
----------------|--------------|----------------|------------
Engineering     | New York     | 3              | 88333.33
Marketing       | Los Angeles  | 2              | 69500.00
Sales           | Chicago      | 1              | 75000.00
HR              | Boston       | 1              | 62000.00
Finance         | New York     | 0              | NULL
```

---

## Key Learning Outcomes

### Technical Skills Demonstrated

✅ **JOIN Fundamentals**
- Understanding of when to use each join type
- Proper syntax for INNER, LEFT, RIGHT, and FULL OUTER joins
- Working with multiple joins in a single query

✅ **Data Relationships**
- One-to-many relationships (departments → employees)
- Many-to-many relationships (employees ↔ projects via junction table)
- Handling NULL values appropriately

✅ **Query Optimization**
- Using appropriate join types to minimize unnecessary data
- Proper use of WHERE vs HAVING clauses
- Understanding Cartesian products and avoiding them when unintended

✅ **Real-World Applications**
- Finding orphaned records (employees without projects)
- Aggregating data across related tables
- Generating reports from normalized data

✅ **Best Practices**
- Table aliasing for readability
- Clear column naming in results
- Handling edge cases (division by zero, NULL values)
- Preventing duplicate results in self joins

---

## Files in This Repository

```
sql-joins-portfolio/
│
├── README.md                    # This file
├── schema.sql                   # Database creation and sample data
├── sql_joins_examples.sql       # All join examples and queries
└── sample_results.txt           # Expected query outputs
```

---

## Common Interview Questions Covered

1. **What's the difference between INNER JOIN and LEFT JOIN?**
   - Demonstrated in Examples 1.1 vs 2.1

2. **How do you find records that don't have a match?**
   - LEFT JOIN with WHERE IS NULL (Example A4)

3. **How do you join more than two tables?**
   - Multiple joins in Examples 1.2, A5

4. **What is a self join and when would you use it?**
   - Example 6.1 (finding employee pairs)

5. **How do you handle many-to-many relationships?**
   - Junction table pattern (employee_projects)

---

## Future Enhancements

- [ ] Add performance benchmarks with EXPLAIN
- [ ] Include index optimization examples
- [ ] Add stored procedures using joins
- [ ] Create views for common join patterns
- [ ] Add window functions with joins

---

## License

This project is open source and available for educational purposes.

---

## Contact

**Eric Joye**
mail@ericjoye.com | https://www.linkedin.com/in/ericjoye | https://github.com/ericjoye

*Demonstrating SQL proficiency for entry-level data analyst and developer positions*
