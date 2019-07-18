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


--Q1: Add data to the Categories

BEGIN TRY
	BEGIN TRAN
		INSERT INTO dbo.Categories
		(CategoryName)
		VALUES
		('Fruits')
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
END CATCH


--Question 2: How would you add data to the Products table?
BEGIN TRY
	BEGIN TRAN
		INSERT INTO dbo.Products
		(ProductName, CategoryID, UnitPrice)
		VALUES
		('Apple', 1, 0.99)
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
END CATCH

--Question 3: How would you update data in the Products table?

BEGIN TRY
	BEGIN TRAN
		UPDATE dbo.Products
		SET UnitPrice = 1.5
		WHERE ProductID = 1
		If(@@ROWCOUNT > 1) RaisError('Do not change more than one row!', 15,1);
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
END CATCH

--Question 4: How would you delete data from the Categories table?

BEGIN TRY
	BEGIN TRAN
		DELETE FROM dbo.Products
		WHERE ProductID = 1
		
		DELETE FROM dbo.Categories
		WHERE CategoryID = 1
		If(@@ROWCOUNT > 1) RaisError('Do not change more than one row!', 15,1);
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT Error_Message()
END CATCH


--Lab02
--Question 1: How would you add data to the Product table using a store procedure?
CREATE PROC pInsProduct
(@ProductName varchar(50),
@CategoryID int,
@UnitPrice money)
AS
	BEGIN TRY
		BEGIN TRAN
		 INSERT INTO dbo.Products (ProductName, CategoryID, UnitPrice)
		  Values (@ProductName, @CategoryID, @UnitPrice)
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		PRINT ERROR_MESSAGE()
	END CATCH
GO

EXEC pInsProduct
	@ProductName = 'Apple',
	@CategoryID = null,
	@UnitPrice = 1.59
GO
--Question 2: How would you update data in the Products table using a store procedure?
CREATE PROC pUpdProduct
(@ProductID int,
@ProductName varchar(50),
@CategoryID int,
@UnitPrice money)
AS
	BEGIN TRY
		BEGIN TRAN
		 UPDATE dbo.Products 
		 SET ProductName = @ProductName,
			 CategoryID = @CategoryID,
			 UnitPrice = @UnitPrice
		 WHERE ProductID = @ProductID
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		PRINT ERROR_MESSAGE()
	END CATCH
GO

--Question 3: How would you delete data from the Products table using a store procedure?
Create Procedure pDelProducts
(@ProductID int)
/* Author: Jong Tai Kim
** Desc: Processing too delete data from the product
** Change Log:
** <2018-10-30>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    DELETE FROM Products
	WHERE ProductID = @ProductID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 1) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go


