--*************************************************************************--
-- Title: Mod05 Labs Database 
-- Author: Jong Tai Kim
-- Desc: This file demonstrates how to process data in a database
-- Change Log: 
-- 2018-11-01,Jong Tai Kim,Created File
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

Create Table Contacts 
( ContactID int identity Primary Key
, ContactFirstName nvarchar(100)
, ContactLastName nvarchar(100)
, ContactEmail nvarchar(100)
);
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Renate', 'Kerfut', 'rkerfut0@flavors.me');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Dix', 'Hurleston', 'dhurleston1@hp.com');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Brit', 'Polo', 'bpolo2@cbc.ca');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Greta', 'Fyfield', 'gfyfield3@nydailynews.com');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Renato', 'Cowdray', 'rcowdray4@rediff.com');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Bobette', 'Carty', 'bcarty5@youtu.be');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Mayor', 'O''Scully', 'moscully6@abc.net.au');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Gianna', 'Mathan', 'gmathan7@de.vu');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Mariquilla', 'Thomazin', 'mthomazin8@booking.com');
insert into Contacts (ContactFirstName, ContactLastName, ContactEmail) values ('Ambrose', 'Ferroli', 'aferroli9@sourceforge.net');

SELECT * FROM Contacts


-- LAB05

Select * From Northwind.dbo.[Order Details];
Select * From Northwind.dbo.[Products];
Select * From Northwind.dbo.[Categories];

Select CategoryID, ProductName, Sum(Quantity) as [Total By Product]
 Into #QtyByProduct
 From Northwind.dbo.[Order Details] as OD 
  Join Northwind.dbo.[Products] as P
   On OD.ProductID = P.ProductID
  Group By P.CategoryID, P.ProductName
  Order By 1,2;

Select C.CategoryID, C.CategoryName, Sum(Quantity) as [Total By Category]
 Into #QtyByCategory
 From Northwind.dbo.[Order Details] as OD 
  Join Northwind.dbo.[Products] as P
   On OD.ProductID = P.ProductID
  Join Northwind.dbo.[Categories] as C
   On P.CategoryID = C.CategoryID
  Group By C.CategoryID, C.CategoryName
  Order By 1,2;

Select 
 C.CategoryName,
 P.ProductName,
 C.[Total By Category],
 P.[Total By Product]
 From #QtyByCategory as C
 Join #QtyByProduct as P
  On C.CategoryID = P.CategoryID
 Order by C.CategoryName, P.ProductName


