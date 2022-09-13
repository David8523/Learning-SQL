-- 1. Find the name and role of all employees who have not been assigned to a building

SELECT *
FROM employees
LEFT JOIN buildings ON employees.building = buildings.building_name
WHERE building_name IS NULL

-- 2. Find the names of the buildings that hold no employees

SELECT *
FROM buildings
LEFT JOIN employees ON buildings.building_name = employees.building
WHERE role IS NULL
