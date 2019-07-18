--*************************************************************************--
-- Title: Info 330 Assignment 03 DB
-- Author: Jong Tai Kim
-- Desc: Applying Module03 knowledge to find data requested from database
-- Change Log: 
-- 2018-10-18, Jong Tai Kim, create the script
--**************************************************************************--


If Exists(Select Name from SysDatabases Where Name = 'Assignment03DB_JongTaiKim')
	Begin 
	 Alter Database [Assignment03DB_JongTaiKim] set Single_user With Rollback Immediate;
	 Drop Database Assignment03DB_JongTaiKim;
	End
GO

Create Database Assignment03DB_JongTaiKim;
GO

Use Assignment03DB_JongTaiKim;
GO

-- 0301: List of the customer companies and their contact people
CREATE VIEW vList0301 AS
	SELECT 
	 CompanyName, 
	 ContactName
	FROM Northwind.dbo.Customers;
GO
 

-- 0302: List of the customer companies and their contact people only from Canada and US
CREATE VIEW vList0302 AS
	SELECT 
	 CompanyName, 
	 ContactName
	FROM Northwind.dbo.Customers
	WHERE Country = 'Canada' OR Country = 'USA';
GO


-- 0303: List of products, their standard price and their categories, order by category name and product name in alphabetical order
-- TOP (100) is included only because ORDER BY command does not work for view for some reason. 
CREATE VIEW vList0303 AS
	SELECT TOP (100) PERCENT
	 CategoryName,
	 ProductName,
	 Format(UnitPrice, 'c', 'en-us') AS 'UnitPrice'
	FROM Northwind.dbo.Products
	JOIN Northwind.dbo.Categories ON Products.CategoryID = Categories.CategoryID
	ORDER BY CategoryName, ProductName;
GO

-- 0304: List of how many customers in US
CREATE VIEW vList0304 AS
	SELECT
	 COUNT(Country) AS Count, 
	 Country
	FROM Northwind.dbo.Customers
	WHERE Country = 'USA'
	GROUP BY Country;
GO

-- 0305: List of how many customers in Canada and US, with subtotal for each
CREATE VIEW vList0305 AS
	SELECT
	 COUNT(Country) AS Count,
	 Country
	FROM Northwind.dbo.Customers
	WHERE Country = 'USA' OR Country = 'Canada'
	GROUP BY Country; 
GO

/*
-- 0306: List of products ordered by the price highest to the lowest, where products that have a price greater than $100
CREATE VIEW vList0306 AS
	SELECT TOP (100) PERCENT
	 ProductName,
	 UnitPrice
	FROM Northwind.dbo.Products
	WHERE UnitPrice > 100
	ORDER BY UnitPrice DESC;
GO

*/