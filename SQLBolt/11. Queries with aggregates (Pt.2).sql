-- 1. Find the number of Artists in the studio (without a HAVING clause)

SELECT COUNT(role)
FROM employees
WHERE role = 'Artist'

-- 2. Find the number of Employees of each role in the studio

SELECT role,COUNT(name) AS number_of_employees
FROM employees
GROUP BY role

-- 3. Find the total number of years employed by all Engineers

SELECT role, SUM(years_employed)
FROM employees
GROUP BY role
HAVING role = "Engineer"
