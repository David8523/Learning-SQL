--1. Use the MIN function to select the record with the smallest value of the Price column.

SELECT MIN(Price)
FROM Products

--2. Use an SQL function to select the record with the highest value of the Price column.

SELECT MAX(Price)
FROM Products

--3. Use the correct function to return the number of records that have the Price value set to 18.

SELECT COUNT(*)
FROM Products
WHERE Price = 18;

--3. Use an SQL function to calculate the average price of all products.

SELECT AVG(Price)
FROM Products

--5. Use an SQL function to calculate the sum of all the Price column values in the Products table.

SELECT SUM(Price)
FROM Products
