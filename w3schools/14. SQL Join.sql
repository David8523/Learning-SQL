--1. Insert the missing parts in the JOIN clause to join the two tables Orders and Customers, using the CustomerID field in both tables as the relationship between the two tables.

SELECT *
FROM Orders
LEFT JOIN Customers
ON Orders.CustomerID = Customers.CustomerID

--2. Choose the correct JOIN clause to select all records from the two tables where there is a match in both tables.

SELECT *
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID=Customers.CustomerID
