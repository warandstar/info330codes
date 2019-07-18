--*************************************************************************--
-- Title: Info 330 Assignment 01 DB
-- Author: Jong Tai Kim
-- Desc: Applying Normalization into the example from the assignment. 
-- Change Log: 
-- 2018-10-07, Jong Tai Kim, create the script
--**************************************************************************--


CREATE DATABASE Assignment01DB_JongTaiKim;
Go

USE Assignment01DB_JongTaiKim;
Go

/*
DROP TABLE Project
Go
DROP TABLE ProjectEmployeeHour
Go
DROP TABLE Employee
Go
Drop Table ProjectDate
Go
*/

CREATE TABLE Project (
	ProjectId int Primary Key,
	ProjectName varchar(50),
	ProjectDescription varchar(200),
);
Go

CREATE TABLE Employee (
	EmployeeId int Primary Key,
	EmployeeFirstName varchar(50),
	EmployeeLastName varchar(50)
);
Go

CREATE TABLE ProjectDate (
	ProjectDateId int Primary Key,
	ProjectDate Date
)
Go

-- bridge table
CREATE TABLE ProjectEmployeeHour (
	ProjectId int,
	ProjectDateId int, 
	EmployeeId int, 
	ProjectEmployeeHour FLOAT,
Primary Key(ProjectId, ProjectDateId, EmployeeId)
);
Go 

SELECT * FROM Project
SELECT * FROM ProjectDate
SELECT * FROM Employee
SELECT * FROM ProjectEmployeeHour



