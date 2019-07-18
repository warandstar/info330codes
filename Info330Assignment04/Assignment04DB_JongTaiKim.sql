--*************************************************************************--
-- Title: Info 330 Assignment 04 DB
-- Author: Jong Tai Kim
-- Desc: Applying Module04 knowledge to find data requested from database
-- Change Log: 
-- 2018-10-27, Jong Tai Kim, create the script
--**************************************************************************--



If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_JongTaiKim')
	Begin 
	 Alter Database [Assignment04DB_JongTaiKim] set Single_user With Rollback Immediate;
	 Drop Database Assignment04DB_JongTaiKim;
	End
GO

Create Database Assignment04DB_JongTaiKim;
GO

Use Assignment04DB_JongTaiKim;
GO

-- Data Request: 0301
-- Request: List of customer companies and their contact people

CREATE VIEW vCustomerContacts 
AS
	SELECT 
	 CompanyName,
	 ContactName
	FROM Northwind.dbo.Customers;
GO

Select * from vCustomerContacts;

-- Data Request: 0302
-- Request: List of customer companies and their contact people, but only the ones in US and Canada

CREATE VIEW vUSAandCanadaCustomerContacts
AS
	SELECT TOP 100000
	 CompanyName,
	 ContactName,
	 Country
	FROM Northwind.dbo.Customers
	WHERE Country = 'USA' OR Country = 'Canada'
	ORDER BY Country, CompanyName;
GO

Select * from vUSAandCanadaCustomerContacts;

-- Data Request: 0303
-- Request: List of products, their standard price and their categories. Order the results by Category Name and then Product Name, in alphabetical order.

CREATE VIEW vProductPricesByCategories
AS
	SELECT TOP 100000000
	 CategoryName,
	 ProductName,
	 [UnitPrice] = FORMAT(UnitPrice, 'C', 'en-US')
	FROM Northwind.dbo.Products AS P
	JOIN Northwind.dbo.Categories AS C
	 ON P.CategoryID = C.CategoryID
	ORDER BY CategoryName, ProductName
GO

Select * from vProductPricesByCategories;

-- Data Request: 0323
-- Request: List of products, their standard price and their categories. Order the results by Category Name and then Product Name, in alphabetical order but only for the seafood category

CREATE FUNCTION fProductPricesByCategories
(@Category varchar(50))
RETURNS TABLE
AS
	RETURN(
		SELECT TOP 100000000
		 CategoryName,
		 ProductName,
		 [UnitPrice] = FORMAT(UnitPrice, 'C', 'en-US')
		FROM Northwind.dbo.Products AS P
		JOIN Northwind.dbo.Categories AS C
		 ON P.CategoryID = C.CategoryID
		WHERE CategoryName = @Category
		ORDER BY CategoryName, ProductName
	)
GO

Select * from dbo.fProductPricesByCategories('seafood');

-- Data Request: 0317
-- Request: List of how many orders our customers have placed each year

CREATE VIEW vCustomerOrderCounts
AS
	SELECT TOP 1000000
	 CompanyName,
	 [NumberOfOrders] = COUNT(OrderID),
	 [Year] = YEAR(OrderDate)
	FROM Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	 ON C.CustomerID = O.CustomerID
	GROUP BY YEAR(OrderDate), CompanyName
	ORDER BY CompanyName
GO

Select * from vCustomerOrderCounts;

-- Data Request: 0318
-- Request: List of total order dollars our customers have placed each year


CREATE VIEW vCustomerOrderDollars
AS
	SELECT TOP 1000000
	 CompanyName,
	 [TotalDollars] = FORMAT(SUM(UnitPrice * Quantity), 'C', 'en-US'),
	 [Year] = YEAR(OrderDate)
	FROM Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	 ON C.CustomerID = O.CustomerID
	JOIN Northwind.dbo.[Order Details] AS OD
	 ON O.OrderID = OD.OrderID
	GROUP BY YEAR(OrderDate), CompanyName
	ORDER BY CompanyName
GO

Select * from vCustomerOrderDollars;
