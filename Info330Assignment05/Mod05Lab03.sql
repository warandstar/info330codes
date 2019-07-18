--*************************************************************************--
-- Title: Mod05 Labs Database 
-- Author: YourNameHere
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
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
,[UnitPrice] [mOney] NOT NULL
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

Insert Into Inventories
(InventoryDate, ProductID, [Count])
Select '20170101' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Inventories;
go
Exec sp_help Categories;
go
Exec sp_help Products;
go 
Exec sp_help Inventories; 
go
Create Procedure pInsCategory
(@CategoryName nvarchar(100))
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

EXEC pInsCategory
@CategoryName = 'Fruits'
GO



Create Procedure pUpdCategories
(@CategoryName nvarchar(100),
 @CategoryID int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

EXEC pUpdCategories
	@CategoryName = 'Banana',
	@CategoryID = 1


Create Procedure pDelCategories
(@CategoryID int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsProducts
(@ProductName nvarchar(100),
@CategoryID int,
@UnitPrice money)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdProduct
(@ProductID int,
@ProductName nvarchar(100),
@CategoryID int,
@UnitPrice money)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    UPDATE PRODUCT
	SET ProductName = @ProductName,
		CategoryID = @CategoryID,
		UnitPrice = @UnitPrice
	WHERE ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelProduct
(@ProductID int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsInventory
(@InventoryDate date,
@ProductID int,
@Count int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdInventory
(@InventoryID int,
@InventoryDate date,
@ProductID int,
@Count int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelInventory
(@InventoryID int)
/* Author: <YourNameHere>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
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
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


