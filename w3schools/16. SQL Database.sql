--1. Write the correct SQL statement to create a new database called testDB.

CREATE DATABASE testDB

--2. Write the correct SQL statement to delete a database named testDB.

DROP DATABASE testDB

--3. Write the correct SQL statement to create a new table called Persons.

CREATE TABLE Persons 
(PersonID int, 
LastName varchar(255), 
FirstName varchar(255), 
Address varchar(255), 
City varchar(255) )

--4. Write the correct SQL statement to delete a table called Persons.

DROP TABLE Persons

--5. Use the TRUNCATE statement to delete all data inside a table.

TRUNCATE TABLE Persons

--6. Add a column of type DATE called Birthday.

ALTER TABLE Persons
ADD Birthday DATE

--7. Delete the column Birthday from the Persons table.

ALTER TABLE Persons
DROP COLUMN Birthday
