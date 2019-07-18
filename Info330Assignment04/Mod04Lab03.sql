-- Module 04
-- Name: Jong Tai Kim
-- Desc: Learn how SQL works
-- Date: 10/23/18


-- LAB 03


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

Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 03) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

-- Q1
CREATE VIEW vCategories WITH SCHEMABINDING 
AS
	SELECT
	 CategoryID,
	 CategoryName
	FROM dbo.Categories;
GO

CREATE VIEW vProducts WITH SCHEMABINDING 
AS
	SELECT
	 ProductID,
	 ProductName,
	 CategoryID,
	 UnitPrice
	FROM dbo.Products;
GO

CREATE VIEW vEmployees WITH SCHEMABINDING 
AS
	SELECT 
	 EmployeeID,
	 [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName,
	 ManagerID
	FROM dbo.Employees
GO

CREATE VIEW vInventories WITH SCHEMABINDING
AS
	SELECT
	 InventoryID,
	 InventoryDate,
	 EmployeeID,
	 ProductID,
	 Count
	FROM dbo.Inventories
GO

-- Q2
DENY SELECT ON Categories to PUBLIC
DENY SELECT ON Products to PUBLIC
DENY SELECT ON Employees to PUBLIC
DENY SELECT ON Inventories to PUBLIC

-- Q3
CREATE VIEW vCategoriesAndProducts
AS
	SELECT TOP (100)
	 CategoryName,
	 ProductName,
	 UnitPrice
	FROM Categories 
	JOIN Products
	 ON Categories.CategoryID = Products.CategoryID
	ORDER BY CategoryName, ProductName
GO

-- Q4
CREATE VIEW vProductsAndCountsByDates
AS
	SELECT TOP (100)
	 ProductName,
	 Count,
	 InventoryDate
	 FROM Products
	 JOIN Inventories
	  ON Products.ProductID = Inventories.ProductID
	 ORDER BY ProductName, InventoryDate, Count;
GO

SELECT * FROM vProductsAndCountsByDates

-- Q5

CREATE VIEW vDatesAndEmployees
AS
	SELECT TOP (100)
	 InventoryDate,
	 [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
	FROM Inventories
	JOIN Employees
	 ON Inventories.EmployeeID = Employees.EmployeeID
	GROUP BY InventoryDate, EmployeeFirstName, EmployeeLastName
	ORDER BY InventoryDate;
GO

SELECT * FROM vDatesAndEmployees

-- Q6

CREATE FUNCTION fDatesAndEmployees(@EmployeeFirstName [nvarchar](100), @EmployeeLastName [nvarchar](100))
RETURNS TABLE 
AS RETURN(
	SELECT TOP (100)
	 InventoryDate,
	 [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
	FROM Inventories
	JOIN Employees
	 ON Inventories.EmployeeID = Employees.EmployeeID
	WHERE EmployeeFirstName = @EmployeeFirstName AND EmployeeLastName = @EmployeeLastName
	GROUP BY InventoryDate, EmployeeFirstName, EmployeeLastName
	ORDER BY InventoryDate
);
GO

SELECT * FROM fDatesAndEmployees('Robert', 'King')