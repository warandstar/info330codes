-- Title: Mod03-Labs
-- Dev: Jong Tai Kim
-- Date: 10/16/2018


/* LAB 01 */
SELECT * FROM Northwind.Sys.Tables where type = 'u' Order By Name;
GO

SELECT 
	CategoryId, CategoryName 
	FROM Northwind.dbo.Categories 
	WHERE CategoryName = 'Seafood';
GO

/* LAB 02 */

SELECT 
	ProductId, ProductName, UnitPrice 
	FROM Northwind.dbo.Products 
	WHERE CategoryId = 8 
	ORDER BY UnitPrice DESC;

SELECT 
	ProductId, ProductName, UnitPrice 
	FROM Northwind.dbo.Products 
	WHERE UnitPrice > 100 
	ORDER BY UnitPrice DESC;

SELECT 
	CategoryName, ProductName, UnitPrice 
	FROM Northwind.dbo.Categories 
	 JOIN Northwind.dbo.Products ON Products.CategoryId = Categories.CategoryId
	ORDER BY CategoryName, ProductName;

SELECT 
	CategoryName, ProductName, UnitPrice 
	FROM Northwind.dbo.Categories 
	 JOIN Northwind.dbo.Products ON Products.CategoryId = Categories.CategoryId
	WHERE UnitPrice BETWEEN 10 AND 20
	ORDER BY UnitPrice DESC;


/* LAB 04 */

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
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go

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

Insert Into Inventories
(InventoryDate, ProductID, [Count])
Select '20170101' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170201' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170302' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show all of the data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

SELECT ProductID, ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC;
GO

SELECT ProductID, Count FROM Inventories WHERE Month(InventoryDate) = 1  ORDER BY ProductID
GO

SELECT CategoryName, ProductName, UnitPrice 
	FROM Categories 
	JOIN Products ON Products.CategoryId = Categories.CategoryId
	WHERE UnitPrice BETWEEN 10 AND 20
	ORDER BY UnitPrice DESC
GO

SELECT ProductID, Count 
	FROM Inventories 
	WHERE Month(InventoryDate) = 1 AND CategoryID in (SELECT CategoryID FROM Categories WHERE CategoryName = 'seafood')
	ORDER BY ProductID
GO


-- LAB 05

SELECT ProductName, FORMAT(UnitPrice, 'C', 'en-US') AS UnitPrice
	FROM Northwind.dbo.Products
	ORDER BY ProductName
GO

-- Convert Method
SELECT TOP(5) OrderID, CONVERT(varchar(50), OrderDate, 101) AS 'Order Date' -- just OrderDate gives u bug since it will be ordered in string value
	FROM NorthWind.dbo.Orders
	ORDER BY OrderDate
GO

-- Format method
SELECT TOP(5) OrderID, FORMAT(OrderDate, 'd', 'en-us') AS 'Order Date' 
	FROM NorthWind.dbo.Orders
	ORDER BY OrderDate
GO

-- LAB 06

Use Master;
go

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

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

 
-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go



-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go

--Step 2: Create SQL Transaction Statements
--Question 1: How would you add data to the Categories table?
INSERT INTO dbo.Categories(CategoryName)
	VALUES('Fruits')
GO


--Question 2: How would you add data to the Products table?
INSERT INTO dbo.Products(ProductName,CategoryID, UnitPrice)
	VALUES('Apple', 1, '$3.00')
GO
--Question 3: How would you update data in the Products table?
UPDATE Products
	SET ProductName = 'Banana'
	WHERE ProductID = 1
GO
--Question 4: How would you delete data from the Categories table? -- can't if categoryid is used in product table. (so drop the product table's value first
DELETE FROM Products
	WHERE CategoryID = 1
GO
DELETE FROM Categories
	WHERE CategoryID = 1
GO

-- How about this! --nullifying the categoryID and delete that old categoryID
Update Products Set CategoryID = null Where categoryID = 1;
DELETE FROM Categories WHERE CategoryID = 1



