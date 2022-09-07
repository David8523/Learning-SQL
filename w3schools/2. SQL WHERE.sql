--1. Select all records where the City column has the value "Berlin".

SELECT * 
FROM Customers
WHERE City = 'Berlin'

--2. Use the NOT keyword to select all records where City is NOT "Berlin".

SELECT * 
FROM Customers
WHERE NOT City = 'Berlin'

--3. Select all records where the CustomerID column has the value 32.

SELECT * 
FROM Customers
WHERE CustomerID =32

--4. Select all records where the City column has the value 'Berlin' and the PostalCode column has the value 12209.

SELECT * 
FROM Customers
WHERE City = 'Berlin'
AND PostalCode = 12209

--5. Select all records where the City column has the value 'Berlin' or 'London'.

SELECT * 
FROM Customers
WHERE City = 'Berlin'
OR City = 'London';
