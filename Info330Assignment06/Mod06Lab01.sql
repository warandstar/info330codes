--*************************************************************************--
-- Title: Mod06 Labs Database 
-- Author: JongTaiKim
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,JongTaiKim,Created File
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

-- Step 2: Create the table
--Run the following SQL code into a code window to create a table;
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go


-- Step 3: Create a base view for the table
--Create and run SQL code into a code window to create a base view for the table;
--Step 4: Create an insert stored procedure
--Use the provided stored procedure template to create code an insert procedure for the table.
Create View vCategories 
As
 Select
  CategoryID,
  CategoryName
 From Categories
Go


Select * From vCategories
Go

Create Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: <JongTaiKim>
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2017-01-01>,<Your Name Here>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into Categories
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
 --Testing Code:
 Declare @Status int;
 Exec @Status = pInsCategories @CategoryName = 'CatA';
 Print @Status;
 Go
--Step 5: Test the View and Stored Procedure
--Test your code by executing the stored procedure and selecting the view.
-- Checked

--Step 6: Set permissions
--Deny the public role all access to the table, allow select permissions on the view, and allow execute permissions on the stored procedure.
Deny Select, Insert, Update, Delete On Categories To Public
Grant Select On vCategories To Public
Grant Exec On pInsCategories To Public
Go 

--Note: If you are using the iSchool SQL Server you can test your permissions with the WebUser login (password = 'sql'), by creating a user account in your database.

Backup Database MyLabsDB_JongTaiKim To Disk = 'C:\Users\Jong Tai Kim\Desktop\info330'
Go


-- Lab 03

CREATE TABLE [dbo].[DimProducts](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductCategoryName] [nvarchar](100) NOT NULL,
	[ProductStdPrice] [Decimal](18,4) NOT NULL,
	[ProductIsDiscontinued] [nchar](1) NOT NULL -- ('y or n')
)
Go

Declare @BitTest bit = 1, @DecimalTest money = $1.99;
Select iif(@BitTest = 1, 'y', 'n'); -- Convert Bit to Character


Create Proc pETLDimProducts
as
Truncate Table DimProducts; -- Clear table of current data

Insert Into DimProducts
(ProductID, ProductName, ProductCategoryName, ProductStdPrice, ProductIsDiscontinued)
Select 
  ProductID = ProductId
, ProductName = Cast(ProductName as nvarchar(100)) -- Convert to nVarchar(100)
, ProductCategoryName = Cast(CategoryName as nvarchar(100)) -- Convert to nVarchar(100)
, ProductStdPrice = Cast(UnitPrice as decimal(18,4))
, ProductIsDiscontinued = iif(Discontinued = 1, 'y', 'n')-- Convert to character ('y' or 'n')
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
 On p.CategoryID = c.CategoryID
Go


Exec pETLDimProducts
Select * From DimProducts
