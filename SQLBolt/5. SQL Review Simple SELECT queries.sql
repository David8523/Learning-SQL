-- 1. List all the Canadian cities and their populations

SELECT country, population 
FROM north_american_cities
WHERE country = "Canada"

-- 2. Order all the cities in the United States by their latitude from north to south

SELECT city
FROM north_american_cities
WHERE country = "United States"
ORDER BY latitude DESC

-- 3. List all the cities west of Chicago, ordered from west to east

SELECT city
FROM north_american_cities
WHERE longitude < (
	SELECT longitude
	FROM north_american_cities
	WHERE city = "Chicago")
ORDER BY longitude ASC

-- 4. List the two largest cities in Mexico (by population)

SELECT city
FROM north_american_cities
WHERE country = "Mexico" 
ORDER BY population DESC
LIMIT 2
