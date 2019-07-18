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


Select * From Northwind.dbo.Orders as o;
Select * From Northwind.dbo.[Order Details] as od;
Select * From Northwind.dbo.Products as p;
Select * From Northwind.dbo.Categories as c;
Go

Select o.OrderID, o.OrderDate 
 From Northwind.dbo.Orders as o;
Select od.OrderID, od.ProductID, od.Quantity, od.UnitPrice as [OrderedPrice] 
 From Northwind.dbo.[Order Details] as od;
Select p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice as [StandardPrice] 
 From Northwind.dbo.Products as p;
Select c.CategoryID, c.CategoryName 
 From Northwind.dbo.Categories as c;
Go

use Northwind;
go
Select TABLE_NAME, Column_Name, Data_Type, CHARACTER_MAXIMUM_LENGTH 
FROM INFORMATION_SCHEMA.Columns 
Where table_name in ('Orders','Order Details','Products','Categories') 
 And COLUMN_NAME in ('OrderID', 'OrderDate','Quantity','UnitPrice'
                    ,'ProductID','ProductName','UnitPrice'
                    ,'CategoryID','CategoryName');
Go


Use MyLabsDB_JongTaiKim;
go

