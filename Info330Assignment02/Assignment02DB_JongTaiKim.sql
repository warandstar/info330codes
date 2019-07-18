--*************************************************************************--
-- Title: Info 330 Assignment 02 DB
-- Author: Jong Tai Kim
-- Desc: Applying Module 02 skills by designing databases with proper constraints and view
-- Change Log: 
-- 2018-10-13, Jong Tai Kim, create the script
--**************************************************************************--


CREATE DATABASE Assignment02DB_JongTaiKim;
Go

USE Assignment02DB_JongTaiKim;
Go

/*

	DROP TABLE OrderDetails;
	GO

	DROP TABLE Product;
	GO

	DROP TABLE SubCategory;
	GO

	DROP TABLE Category;
	GO

	DROP TABLE Customer;
	GO
*/

/*
	Required for database:
	Customer Infomation
	Product Information: one (subcategory) to many (product) relation
	SubCategory Infomation
	Category Infomation: one (category) to many (subcategory) relation 
	Order Information: can be a bridge between customer and product
*/


--	Stores customer data, such as their first name and last name
--  'Aaron' and 'Adams' are example of non-primary key data. 
-- customer's first and last name should not be null
CREATE TABLE Customer (
	CustomerId int Primary Key,
	CustomerFirstName varchar(50) not null,
	CustomerLastName varchar(50) not null
)
GO


-- Stores products' category data such as category name
-- 'Accessories' is example of non-primary key data 
-- category name should be not null
CREATE TABLE Category (
	CategoryId int Primary Key,
	CategoryName varchar(100) not null
)
GO

-- Stores products' subcategory, and linked to the related category
-- 'Tires and Tubes' is example of non-key-related data.
-- subcategory name should be not null 
-- categoryid is refering to category table's primary key
CREATE TABLE SubCategory (
	SubCategoryId int Primary Key,
	CategoryId int not null Foreign Key references Category(CategoryId),
	SubCategoryName varchar(100) not null
)
GO


-- Stores products data such as product name
-- Product can be described by itself and its category
-- for simplicity, only having subcategory as reference since subcategory is related to category. 
-- 'Road Tire Tube' would be an example of non-key-related product data. 
-- product name should not be null. 
CREATE TABLE Product (
	ProductId int Primary Key,
	SubCategoryId int not null Foreign Key references SubCategory(SubCategoryId),
	ProductName varchar(200) not null
)
GO

-- Serves as bridge table between customer table and product table
-- Stores order information such as dates, prices, and quantities. 
-- '10302007', '$3.99', '1' would be example of data. 
-- customer and product id are refering to customer table's and product table's primary key
-- if not specified, date would refer to today's date and check if date is within possible range
-- price should not be null, check if the price is positive
-- quantity is not null and check if the quantity is positive
-- the order of primary key is just to visualize easily-- "a customer" "orders" "some product"
CREATE TABLE OrderDetails (
	CustomerId int not null Foreign Key references Customer(CustomerId),
	OrderDetailsId int not null, 	
	ProductId int not null Foreign Key references Product(ProductId),
	OrderDate date Default getdate() check (OrderDate <= getdate()),
	OrderPrice money not null check (OrderPrice > 0.00),
	OrderQty int not null check(OrderQty > 0),
Primary Key(CustomerId, OrderDetailsId, ProductId)
)
GO

/*
	DROP VIEW vCustomer;
	GO

	DROP VIEW vCategory;
	GO

	DROP VIEW vSubCategory;
	GO

	DROP VIEW vProduct;
	GO

	DROP VIEW vOrderDetails;
	GO
*/ 



-- Presents the Customer table data in database
-- considered combining first and last names into one but not efficient according to lecture notes. 
CREATE VIEW vCustomer AS
	SELECT 
	 CustomerId,
	 CustomerFirstName,
	 CustomerLastName
	FROM Customer;
GO

-- Presents the Category table data in database
CREATE VIEW vCategory AS
	SELECT
	 CategoryId,
	 CategoryName
	FROM Category;
GO

-- Presents the SubCategory table in database
-- maybe redundant with category, but feels necessary to seperate those 
-- since both have different subjects as category and subcategory even if they are one-to-many. 
-- i.e) category has category name and subcategory has subcategory name 
-- such that having combined table will make harder for other people to try to understand our implementation
-- so I think that combined table would be bad habit if this database were very complicated. 
CREATE VIEW vSubCategory AS
	SELECT
	 SubCategoryId,
	 CategoryId,
	 SubCategoryName
	FROM SubCategory;
GO

-- Presents the Product table in database
-- the design choice for this view is justified by same reason as vSubCategory.  
CREATE VIEW vProduct AS
	SELECT
	 ProductId,
	 SubCategoryId,
	 ProductName
	FROM Product;
Go

-- Presents the OrderDetails table in database
CREATE VIEW vOrderDetails AS
	SELECT	 	 
	 CustomerId,
	 OrderDetailsId,
	 ProductId,
	 OrderDate,
	 OrderPrice,
	 OrderQty
	FROM OrderDetails;
Go
