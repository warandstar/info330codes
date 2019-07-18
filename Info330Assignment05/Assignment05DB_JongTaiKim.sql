--*************************************************************************--
-- Title: Assignment05
-- Author: Jong Tai Kim
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2018-11-03,Jong Tai Kim,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_JongTaiKim')
 Begin 
  Alter Database [Assignment05DB_JongTaiKim] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_JongTaiKim;
 End
go

Create Database Assignment05DB_JongTaiKim;
go

Use Assignment05DB_JongTaiKim;
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


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

-- STEP 2
--Category	Product	Price	Date		Count
--Beverages	Chai	18.00	2017-01-01	61
--Beverages	Chang	19.00	2017-01-01	17

--Beverages	Chai	18.00	2017-02-01	13
--Beverages	Chang	19.00	2017-02-01	12

--Beverages 	Chai	18.00	2017-03-02	18
--Beverages	Chang	19.00	2017-03-02	12

INSERT INTO Categories(CategoryName)
 Values ('Beverages')
INSERT INTO Products(ProductName, CategoryID, UnitPrice)
 Values ('Chai', 1, 18.00), ('Chang', 1, 19.00)
INSERT INTO Inventories(InventoryDate, ProductID, Count)
 Values ('20170101', 1, 61), ('20170101', 2, 17), ('20170201', 1, 13), ('20170201', 2, 12), ('20170302', 1, 18), ('20170302', 2, 12)
Go

SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM Inventories
Go
-- STEP 3 (Since I copy and paste the statements from assignment doc file, the syntax may be different

-- For Categories 
Create Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: Jong Tai Kim 
** Desc: Processes inserting data into categories table
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into dbo.Categories(CategoryName)
	Values (@CategoryName)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdCategories
(@CategoryName nvarchar(100),
 @CategoryID int)
/* Author: Jong Tai Kim 
** Desc: Processes updating data in categories
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update Categories
	SET CategoryName = @CategoryName
	WHERE CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelCategories
(@CategoryID int)
/* Author: Jong Tai Kim 
** Desc: Processes deleting values in categories
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete From Categories
	Where CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- For Products Table
Create Procedure pInsProducts
(@ProductName nvarchar(100),
@CategoryID int,
@UnitPrice money)
/* Author: Jong Tai Kim 
** Desc: Processes inserting data into products table
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into Products(ProductName, CategoryID, UnitPrice)
	Values (@ProductName, @CategoryID, @UnitPrice)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdProducts
(@ProductID int,
@ProductName nvarchar(100),
@CategoryID int,
@UnitPrice money)
/* Author: Jong Tai Kim 
** Desc: Processes updating date in products table
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update Products
	Set ProductName = @ProductName,
		CategoryID = @CategoryID,
		UnitPrice = @UnitPrice
	Where ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelProducts
(@ProductID int)
/* Author: Jong Tai Kim 
** Desc: Processes deleting values from products table 
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete From products
	Where ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- For Inventories Table
Create Procedure pInsInventories
(@InventoryDate date,
@ProductID int,
@Count int)
/* Author: Jong Tai Kim 
** Desc: Processes inserting values into inventories table
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into Inventories(InventoryDate, ProductID, Count)
	Values (@InventoryDate, @ProductID, @Count)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdInventories
(@InventoryID int,
@InventoryDate date,
@ProductID int,
@Count int)
/* Author: Jong Tai Kim 
** Desc: Processes updating data into inventories table 
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update Inventories
	Set InventoryDate = @InventoryDate,
		ProductID = @ProductID,
		Count = @Count
	Where InventoryID = @InventoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelInventories
(@InventoryID int)
/* Author: Jong Tai Kim 
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2018-11-03>,Jong Tai Kim,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete From Inventories
	Where InventoryID = @InventoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- STEP 4: Testing 

-- Testing pInsCategories
Declare @Status int;
Exec @Status = pInsCategories @CategoryName = 'CatA'
Select [pInsCategories Status] = @Status;
Select * From Categories
Go

-- Testing pUpdCategories
Declare @Status int;
Exec @Status = pUpdCategories @CategoryName = 'CatB', @CategoryID = 2
Select [pUpdCategories Status] = @Status;
Select * From Categories
Go

-- Testing pDelCategories
Declare @Status int;
Exec @Status = pDelCategories @CategoryID = 2
Select [pDelCategories Status] = @Status;
Select * From Categories
Go

-- Testing pInsProducts
Declare @Status int;
Exec @Status = pInsProducts @ProductName = 'ProA', @CategoryID = 1, @UnitPrice = 10.00;
Select [pInsProducts Status] = @Status;
Select * From Products
Go

-- Testing pUpdProducts
Declare @Status int;
Exec @Status = pUpdProducts @ProductID = 3, @ProductName = 'ProB', @CategoryID = 1, @UnitPrice = 11.00;
Select [pUpdProducts Status] = @Status;
Select * From Products
Go

-- Testing pDelProducts
Declare @Status int;
Exec @Status = pDelProducts @ProductID = 3
Select [pDelProducts Status] = @Status;
Select * From Products
Go

-- Testing pInsInventories
Declare @Status int;
Exec @Status = pInsInventories @InventoryDate = '20170401', @ProductID = 1, @Count = 10;
Select [pInsInventories Status] = @Status;
Select * From Inventories
Go

-- Testing pUpdInventories
Declare @Status int;
Exec @Status = pUpdInventories @InventoryID = 7, @InventoryDate = '20170401', @ProductID = 1, @Count = 11;
Select [pUpdInventories Status] = @Status;
Select * From Inventories
Go

-- Testing pDelInventories
Declare @Status int;
Exec @Status = pDelInventories @InventoryID = 7
Select [pDelInventories Status] = @Status;
Select * From Inventories
Go