-- Module 04
-- Name: Jong Tai Kim
-- Desc: Learn how SQL works
-- Date: 10/23/18


-- LAB 01


If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_JongTaiKim')
 Begin 
  Alter Database [MyLabsDB_JongTaiKim] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_JongTaiKim;
 End
go

Create Database MyLabsDB_JongTaiKim;
go

Use MyLabsDB_JongTaiKim;
go

Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;

SELECT 
	CategoryName 
	FROM Northwind.dbo.Categories 
	ORDER BY CategoryName;

SELECT 
	ProductName, UnitPrice 
	FROM Northwind.dbo.Products 
	ORDER BY ProductName

SELECT 
	CategoryName, ProductName, UnitPrice
	FROM Northwind.dbo.Categories AS C 
	JOIN Northwind.dbo.Products AS P
	 ON C.CategoryID = P.CategoryID
	ORDER BY CategoryName, ProductName

SELECT
	OrderID, CategoryName, ProductName, Quantity
	FROM Northwind.dbo.Categories AS C
	JOIN Northwind.dbo.Products AS P
	 ON C.CategoryID = P.CategoryID
	JOIN Northwind.dbo.[Order Details] AS O
	 ON O.ProductID = P.ProductID
	ORDER BY OrderID, CategoryName, ProductName, Quantity

SELECT
	O.OrderID, OrderDate, CategoryName, ProductName, Quantity
	FROM Northwind.dbo.Categories AS C
	JOIN Northwind.dbo.Products AS P
	 ON C.CategoryID = P.CategoryID
	JOIN Northwind.dbo.[Order Details] AS OD
	 ON OD.ProductID = P.ProductID
	JOIN Northwind.dbo.Orders AS O
	 ON O.OrderID = OD.OrderID
	ORDER BY OrderID, OrderDate, CategoryName, ProductName, Quantity

-- LAB 02

CREATE VIEW vCustomersByLocation AS
	SELECT
	 CompanyName, 
	 [Customer Address] = Address + ', ' + City + ' ' + Region + ' ' + PostalCode + ', ' + Country
	From Northwind.dbo.Customers;
GO

CREATE VIEW vNumberOfCustomerOrdersByLocation AS
	SELECT
	 CompanyName,
	 [CustomerAddress] = Address + ', ' + City + ' ' + Region + ' ' + PostalCode + ', ' + Country,
	 [Count] = COUNT(OrderID)
	From Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
	GROUP BY CompanyName, Address, City, Region, PostalCode, Country;
GO

SELECT * FROM vNumberOfCustomerOrdersByLocation

CREATE VIEW vNumberOfCustomerOrdersByLocationAndYears AS
	SELECT
	 [Year] = YEAR(O.OrderDate),
	 CompanyName,
	 [CustomerAddress] = Address + ', ' + City + ' ' + Region + ' ' + PostalCode + ', ' + Country,
	 [Count] = COUNT(OrderID)
	From Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	 ON C.CustomerID = O.CustomerID
	WHERE YEAR(o.OrderDate) = 1996
	GROUP BY CompanyName, Address, City, Region, PostalCode, Country, YEAR(o.OrderDate);
GO

SELECT * FROM vNumberOfCustomerOrdersByLocationAndYears

-- LAB 04

CREATE PROCEDURE pSelCustomersByLocation
AS
	SELECT 
	 CompanyName,
	 PostalCode
	FROM Northwind.dbo.Customers
GO

CREATE PROCEDURE pSelNumberOfCustomerOrdersByLocation
AS
	SELECT 
	 CompanyName,
	 PostalCode,
	 Country,
	 [Count] = COUNT(OrderID)
	FROM Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	 ON C.CustomerID = O.CustomerID
	GROUP BY CompanyName, PostalCode, Country
GO

CREATE PROCEDURE pSelNumberOfCustomerOrdersByLocationAndYears(@Year int)
AS
BEGIN
	SELECT 
	 CompanyName,
	 PostalCode,
	 Country, 
	 [Count] = COUNT(OrderID),
	 [Year] = YEAR(O.OrderDate)
	FROM Northwind.dbo.Customers AS C
	JOIN Northwind.dbo.Orders AS O
	 ON C.CustomerID = O.CustomerID
	WHERE YEAR(O.OrderDate) = @Year
	GROUP BY CompanyName, PostalCode, Country, YEAR(O.orderDate)
END
GO

exec pSelNumberOfCustomerOrdersByLocationAndYears @Year = 1996

exec pSelNumberOfCustomerOrdersByLocationAndYears @Year = 1997

Select 
	ProductID, 
	[SUM] = SUM(Quantity),
	[Qty KPI] = 
		CASE WHEN SUM(Quantity) >= 500 THEN 1
		     WHEN SUM(Quantity) BETWEEN 250 AND 500 THEN 0
			 WHEN SUM(Quantity) < 250 THEN -1
	END
	From Northwind.dbo.[Order Details] 
	GROUP BY ProductID
	Order By ProductID;
