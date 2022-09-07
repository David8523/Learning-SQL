--1. Select all records where the value of the City column starts with the letter "a".

SELECT * 
FROM Customers
WHERE City LIKE 'a%'

--2. Select all records where the value of the City column ends with the letter "a".

SELECT * 
FROM Customers
WHERE City LIKE '%a'

--3. Select all records where the value of the City column contains the letter "a".

SELECT * 
FROM Customers
WHERE City LIKE '%a%'

--4. Select all records where the value of the City column starts with letter "a" and ends with the letter "b"

SELECT * 
FROM Customers
WHERE City LIKE 'a%b'

--5. Select all records where the value of the City column does NOT start with the letter "a"
SELECT * 
FROM Customers
WHERE City NOT LIKE 'a%'
