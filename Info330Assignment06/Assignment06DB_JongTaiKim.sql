--**********************************************************************************************--
-- Title: Assigment06 - Midterm
-- Author: JongTaiKim
-- Desc: This file demonstrates how to design and create, 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2018-11-10,JongTaiKim,Created File
--***********************************************************************************************--
Begin Try
	Use Master,
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_JongTaiKim')
	 Begin 
	  Alter Database [Assignment06DB_JongTaiKim] set Single_user With Rollback Immediate,
	  Drop Database Assignment06DB_JongTaiKim,
	 End
	Create Database Assignment06DB_JongTaiKim,
End Try
Begin Catch
	Print Error_Number(),
End Catch
Go
Use Assignment06DB_JongTaiKim,

-- Create Tables (Module 01)-- 
Create Table Students 
([StudentID] [int] IDENTITY(1,1) not null,
 [StudentNumber] [nvarchar](100) not null,
 [StudentFirstName] [nvarchar](100) not null,
 [StudentLastName] [nvarchar](100) not null ,
 [StudentEmail] [nvarchar](100) not null,
 [StudentPhone] [nvarchar](100),
 [StudentAddress1] [nvarchar](100) not null,
 [StudentAddress2] [nvarchar](100),
 [StudentCity] [nvarchar](100) not null,
 [StudentStateCode] [nvarchar](100) not null, 
 [StudentZipCode] [nvarchar](100) not null 
),
Go
 
Create Table Courses
([CourseID] [int] IDENTITY(1,1),
 [CourseName] [nvarchar](100) not null,
 [CourseStartDate] [date],
 [CourseEndDate] [date],
 [CourseStartTime] [time],
 [CourseEndTime] [time],
 [CourseCurrentPrice] [money] 
),
Go

Create Table Enrollment
([EnrollmentID] [int] IDENTITY(1,1), 
 [StudentID] [int],
 [CourseID] [int],
 [EnrollmentDateTime] [datetime] not null,
 [EnrollmentPrice] [money] not null
),
Go

-- Add Constraints (Module 02) -- 
Begin --Students
	Alter Table Students
	 Add Constraint pkStudents
	  Primary Key (StudentID)

	Alter Table Students
	 Add Constraint ukStudentsI
	  Unique (StudentNumber, StudentEmail)

	Alter Table Students
	 Add Constraint ckStudentsPhoneFormat
	  Check (StudentPhone Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')

	Alter Table Students
	 Add Constraint ckStudentsZipFormat
	  Check (StudentZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or StudentZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
End
Go

Begin --Courses
	Alter Table Courses
	 Add Constraint pkCourses
	  Primary Key (CourseID)

	Alter Table Courses
	 Add Constraint ukCourses
	  Unique (CourseName)

	Alter Table Courses
	 Add Constraint ckCoursesEndDateGreaterStartDate
	  Check (CourseEndDate > CourseStartDate)

	Alter Table Courses
	 Add Constraint ckCoursesEndTimeGreaterStartTime
	  Check (CourseEndTime > CourseStartTime)
End
Go

Create Function fCheckEnrollmentLessThanStart
(@EnrollmentDateTime datetime)
Returns int
As
 Begin
  Declare @CourseStartDate datetime
	Select @CourseStartDate = CourseStartDate From Courses Join Enrollment On Courses.CourseID = Enrollment.CourseID
  If @EnrollmentDateTime < @CourseStartDate
   return 1
  return 0
 End
Go 

Begin -- Enrollment
	Alter Table Enrollment
	 Add Constraint pkEnrollment
	  Primary Key (EnrollmentID)

	Alter Table Enrollment
	 Add Constraint fkEnrollmentToStudents
	  Foreign Key (StudentID) references Students(StudentID)

	Alter Table Enrollment
	 Add Constraint fkEnrollmentToCourses
	  Foreign Key (CourseID) references Courses(CourseID)

	Alter Table Enrollment
	 Add Constraint dfEnrollmentDateTime
	  Default getdate() For EnrollmentDateTime

	Alter Table Enrollment
	 Add Constraint ckEnrollmentDateTimeLessThanStartDate
	  Check (dbo.fCheckEnrollmentLessThanStart(EnrollmentDateTime) = 1)

End
Go


-- Add Views (Module 03 and 04) -- 
Create View vStudents
As
	Select
	 [StudentID],
	 [StudentNumber],
	 [StudentFirstName],
	 [StudentLastName],
	 [StudentEmail],
	 [StudentPhone],
	 [StudentAddress1],
	 [StudentAddress2],
	 [StudentCity],
	 [StudentStateCode], 
	 [StudentZipCode]
	From Students
Go

Create View vCourses
As
	Select
	 [CourseID],
	 [CourseName],
	 [CourseStartDate],
	 [CourseEndDate],
	 [CourseStartTime],
	 [CourseEndTime],
	 [CourseCurrentPrice]
	From Courses
Go

Create View vEnrollment
As
	Select
	 [EnrollmentID], 
	 [StudentID],
	 [CourseID],
	 [EnrollmentDateTime],
	 [EnrollmentPrice]
	From Enrollment
Go

-- Reporting View for whole data
Create View vEnrollmentTracker
As
	Select
	 [CourseName],
	 [CourseStartDate],
	 [CourseEndDate],
	 [CourseStartTime],
	 [CourseEndTime],
	 [CourseCurrentPrice],
	 [StudentFirstName],
	 [StudentLastName],
	 [StudentNumber],
	 [StudentEmail],
	 [StudentPhone],
	 [StudentAddress1],
	 [StudentAddress2],
	 [StudentCity],
	 [StudentStateCode], 
	 [StudentZipCode],
	 [EnrollmentDateTime],
	 [EnrollmentPrice]
	 From Enrollment
	 Join Courses
	  On Enrollment.CourseID = Courses.CourseID
	 Join Students
	  On Enrollment.StudentID = Students.StudentID
Go



-- Add Stored Procedures (Module 04 and 05) --
Create Procedure pInsStudents
	(@StudentNumber nvarchar(100),
	 @StudentFirstName nvarchar(100),
	 @StudentLastName nvarchar(100),
	 @StudentEmail nvarchar(100),
	 @StudentPhone nvarchar(100),
	 @StudentAddress1 nvarchar(100),
	 @StudentAddress2 nvarchar(100),
	 @StudentCity nvarchar(100),
	 @StudentStateCode nvarchar(100), 
	 @StudentZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes inserting data too students
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Insert Into Students 
	 (StudentNumber, StudentFirstName, StudentLastName, StudentEmail, StudentPhone, StudentAddress1, StudentAddress2, StudentCity, StudentStateCode, StudentZipCode)
	Values 
	(@StudentNumber, @StudentFirstName, @StudentLastName, @StudentEmail, @StudentPhone, @StudentAddress1, @StudentAddress2, @StudentCity, @StudentStateCode, @StudentZipCode)
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go

Create Procedure pUpdStudents
	(@StudentID int, 
	 @StudentNumber nvarchar(100),
	 @StudentFirstName nvarchar(100),
	 @StudentLastName nvarchar(100),
	 @StudentEmail nvarchar(100),
	 @StudentPhone nvarchar(100),
	 @StudentAddress1 nvarchar(100),
	 @StudentAddress2 nvarchar(100),
	 @StudentCity nvarchar(100),
	 @StudentStateCode nvarchar(100), 
	 @StudentZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes updating data in students table
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Update Students
	Set StudentNumber = @StudentNumber,
		StudentFirstName = @StudentFirstName,
		StudentLastName = @StudentLastName,
		StudentEmail = @StudentEmail,
		StudentPhone = @StudentPhone,
		StudentAddress1 = @StudentAddress1,
		StudentAddress2 = @StudentAddress2,
		StudentCity = @StudentCity,
		StudentStateCode = @StudentStateCode,
		StudentZipCode = @StudentZipCode
	Where StudentID = @StudentID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pDelStudents
(@StudentID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting data from student table
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Delete From Students
	Where StudentID = @StudentID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pInsCourses
(@CourseName nvarchar(100),
 @CourseStartDate date,
 @CourseEndDate date,
 @CourseStartTime time,
 @CourseEndTime time,
 @CourseCurrentPrice money)
/* Author: Jong Tai Kim
** Desc: Processes inserting data to courses
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Insert Into Courses (CourseName, CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, CourseCurrentPrice)
	Values (@CourseName, @CourseStartDate, @CourseEndDate, @CourseStartTime, @CourseEndTime, @CourseCurrentPrice)
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pUpdCourses
(@CourseID int,
 @CourseName nvarchar(100),
 @CourseStartDate date,
 @CourseEndDate date,
 @CourseStartTime time,
 @CourseEndTime time,
 @CourseCurrentPrice money)
/* Author: Jong Tai Kim
** Desc: Processes updating data of courses table
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Update Courses
	Set CourseName = @CourseName, 
		CourseStartDate = @CourseStartDate,
		CourseEndDate = @CourseEndDate,
		CourseStartTime = @CourseStartTime,
		CourseEndTime = @CourseEndTime,
		CourseCurrentPrice = @CourseCurrentPrice
	Where CourseID = @CourseID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pDelCourses
(@CourseID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting courses
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Delete From Courses
	Where CourseID = @CourseID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pInsEnrollment
(@StudentID int,
 @CourseID int,
 @EnrollmentDateTime datetime,
 @EnrollmentPrice money)
/* Author: Jong Tai Kim
** Desc: Processes inserting data into enrollment table
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Insert Into Enrollment (StudentID, CourseID, EnrollmentDateTime, EnrollmentPrice)
	Values (@StudentID, @CourseID, @EnrollmentDateTime, @EnrollmentPrice)
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pUpdEnrollment
(@EnrollmentID int, 
 @StudentID int,
 @CourseID int,
 @EnrollmentDateTime datetime,
 @EnrollmentPrice money)
/* Author: Jong Tai Kim
** Desc: Processes updating data in enrollment
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Update Enrollment
	Set StudentID = @StudentID,
		CourseID = @CourseID,
		EnrollmentDateTime = @EnrollmentDateTime,
		EnrollmentPrice = @EnrollmentPrice
	Where EnrollmentID = @EnrollmentID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go


Create Procedure pDelEnrollment
(@EnrollmentID int)
/* Author: Jong Tai Kim
** Desc: Processes <Desc text>
** Change Log: When,Who,What
** <2018-11-10>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0,
  Begin Try
   Begin Transaction, 
    Delete From Enrollment
	Where EnrollmentID = @EnrollmentID
   Commit Transaction,
   Set @RC = +1,
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction,
   Print Error_Message(),
   Set @RC = -1
  End Catch
  Return @RC,
 End -- Body
go

-- Set Permissions (Module 06) --
Deny Select, Insert, Update, Delete On Students To Public
Deny Select, Insert, Update, Delete On Courses To Public
Deny Select, Insert, Update, Delete On Enrollment To Public

Grant Select On vStudents To Public
Grant Select On vCourses To Public
Grant Select On vEnrollment To Public

Grant Exec On pInsStudents To Public
Grant Exec On pUpdStudents To Public
Grant Exec On pDelStudents To Public
Grant Exec On pInsCourses To Public
Grant Exec On pUpdCourses To Public
Grant Exec On pDelCourses To Public
Grant Exec On pInsEnrollment To Public
Grant Exec On pUpdEnrollment To Public
Grant Exec On pDelEnrollment To Public

--< Test Views and Sprocs >-- 
-- Testing pInsStudents

-- actual data
Declare @Status int,
Exec @Status = pInsStudents @StudentNumber = 'B-Smith-071', 
							@StudentFirstName = 'Bob', 
							@StudentLastName = 'Smith', 
							@StudentEmail = 'Bsmith@HipMail.com', 
							@StudentPhone = '206-111-2222', 
							@StudentAddress1 = '123 Main St.', 
							@StudentAddress2 = '', 
							@StudentCity ='Seattle', 
							@StudentStateCode = 'WA', 
							@StudentZipCode = '98001'
Select [pInsStudents Status] = @Status,
Select * From vStudents
Go

Declare @Status int,
Exec @Status = pInsStudents @StudentNumber = 'S-Jones-003', 
							@StudentFirstName = 'Sue', 
							@StudentLastName = 'Jones', 
							@StudentEmail = 'SueJones@YaYou.com', 
							@StudentPhone = '206-231-4321', 
							@StudentAddress1 = '333 1st Ave.', 
							@StudentAddress2 = '', 
							@StudentCity ='Seattle', 
							@StudentStateCode = 'WA', 
							@StudentZipCode = '98001',
Select [pInsStudents Status] = @Status,
Select * From vStudents
Go

-- For testing update and delete later
Declare @Status int,
Exec @Status = pInsStudents @StudentNumber = 'J-James-099', 
							@StudentFirstName = 'John', 
							@StudentLastName = 'James', 
							@StudentEmail = 'JJames@gmail.com', 
							@StudentPhone = '425-123-1357', 
							@StudentAddress1 = '257 11th St.', 
							@StudentAddress2 = 'N404', 
							@StudentCity ='Seattle', 
							@StudentStateCode = 'WA', 
							@StudentZipCode = '98001',
Select [pInsStudents Status] = @Status,
Select * From vStudents
Go



-- Testing pInsCourses
Declare @Status int,
Exec @Status = pInsCourses @CourseName = 'SQL1 - Winter 2017',
							@CourseStartDate = '20170110',
							@CourseEndDate = '20170124',
							@CourseStartTime = '18:00:00', 
							@CourseEndTime = '20:50:00',
							@CourseCurrentPrice = '399',
Select [pInsCourses Status] = @Status,
Select * From vCourses
Go

Declare @Status int,
Exec @Status = pInsCourses @CourseName = 'SQL2 - Winter 2017',
							@CourseStartDate = '20170131',
							@CourseEndDate = '20170214',
							@CourseStartTime = '18:00:00', 
							@CourseEndTime = '20:50:00',
							@CourseCurrentPrice = '399',
Select [pInsCourses Status] = @Status,
Select * From vCourses
Go

-- For testing update and delete later
Declare @Status int,
Exec @Status = pInsCourses @CourseName = 'SQL3 - Winter 2017',
							@CourseStartDate = '20170217',
							@CourseEndDate = '20170304',
							@CourseStartTime = '19:00:00', 
							@CourseEndTime = '21:50:00',
							@CourseCurrentPrice = '419',
Select [pInsCourses Status] = @Status,
Select * From vCourses
Go

-- Testing pInsEnrollment
Declare @Status int,
Exec @Status = pInsEnrollment @StudentID = 1,
								@CourseID = 1,
								@EnrollmentDateTime = '20170103',
								@EnrollmentPrice = '399',
Select [pInsEnrollment Status] = @Status,
Select * From vEnrollment
Go

Declare @Status int,
Exec @Status = pInsEnrollment @StudentID = 2,
								@CourseID = 1,
								@EnrollmentDateTime = '20161214',
								@EnrollmentPrice = '349',
Select [pInsEnrollment Status] = @Status,
Select * From vEnrollment
Go

Declare @Status int,
Exec @Status = pInsEnrollment @StudentID = 2,
								@CourseID = 2,
								@EnrollmentDateTime = '20161214',
								@EnrollmentPrice = '349',
Select [pInsEnrollment Status] = @Status,
Select * From vEnrollment
Go

Declare @Status int,
Exec @Status = pInsEnrollment @StudentID = 1,
								@CourseID = 2,
								@EnrollmentDateTime = '20170112',
								@EnrollmentPrice = '399',
Select [pInsEnrollment Status] = @Status,
Select * From vEnrollment
Go


-- Just for testing purpose!
Declare @Status int,
Exec @Status = pInsEnrollment @StudentID = 3,
								@CourseID = 3,
								@EnrollmentDateTime = '20170120',
								@EnrollmentPrice = '400',
Select [pInsEnrollment Status] = @Status,
Select * From vEnrollment
Go



-- Testing pUpdStudents
Declare @Status int,
Exec @Status = pUpdStudents @StudentID = 3, 
							@StudentNumber = 'J-James-099', 
							@StudentFirstName = 'John', 
							@StudentLastName = 'James', 
							@StudentEmail = 'JJames@gmail.com', 
							@StudentPhone = '425-111-2222', 
							@StudentAddress1 = '257 11th St.', 
							@StudentAddress2 = 'N418', 
							@StudentCity ='Seattle', 
							@StudentStateCode = 'WA', 
							@StudentZipCode = '98105',
Select [pUpdStudents Status] = @Status,
Select * From vStudents
Go

-- Testing pUpdCourses
Declare @Status int,
Exec @Status = pUpdCourses @CourseID = 3,
						   @CourseName = 'SQL3 - Winter 2017',
						   @CourseStartDate = '20170218',
					       @CourseEndDate = '20170305',
						   @CourseStartTime = '19:00:00', 
						   @CourseEndTime = '22:00:00',
						   @CourseCurrentPrice = '420',
Select [pUpdCourses Status] = @Status,
Select * From vCourses
Go

-- Testing pUpdEnrollment
Declare @Status int, -- status should be -1
Exec @Status = pUpdEnrollment @EnrollmentID = 5, 
							  @StudentID = 3,
							  @CourseID = 3,
							  @EnrollmentDateTime = '20170220',
							  @EnrollmentPrice = '400',
Select [pUpdEnrollment Status] = @Status,
Select * From vEnrollment
Go


Declare @Status int, -- should work
Exec @Status = pUpdEnrollment @EnrollmentID = 5, 
							  @StudentID = 3,
							  @CourseID = 3,
							  @EnrollmentDateTime = '20170130',
							  @EnrollmentPrice = '400',
Select [pUpdEnrollment Status] = @Status,
Select * From vEnrollment
Go


-- Testing pDelEnrollment
Declare @Status int, 
Exec @Status = pDelEnrollment @EnrollmentID = 5
Select [pDelEnrollment Status] = @Status,
Select * From vEnrollment
Go


-- Testing pDelStudents
Declare @Status int,
Exec @Status = pDelStudents @StudentID = 3,
Select [pDelStudents Status] = @Status,
Select * From vStudents
Go

-- Testing pDelCourses
Declare @Status int,
Exec @Status = pDelCourses @CourseID = 3
Select [pDelCourses Status] = @Status,
Select * From vCourses
Go

Select * From vEnrollmentTracker -- this should look very similar to the data given in assignment excel file
Go

