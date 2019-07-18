--**********************************************************************************************--
-- Title: Assigment08 - MileStone 02
-- Author: JongTaiKim
-- Desc: This file demonstrates how to design and create, 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2018-11-20,JongTaiKim,Created File
-- 2018-11-27, Jong Tai Kim, Fixes datatype of State and ZipCode of Patients, Clinics and Doctors and time format
-- 2018-11-27, JongTaiKim, add output in insert sproc
--***********************************************************************************************--
Begin Try
	Use Master
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_JongTaiKim')
	 Begin 
	  Alter Database [Assignment08DB_JongTaiKim] set Single_user With Rollback Immediate
	  Drop Database Assignment08DB_JongTaiKim;
	 End
	Create Database Assignment08DB_JongTaiKim;
End Try
Begin Catch
	Print Error_Number()
End Catch
Go
Use Assignment08DB_JongTaiKim


-- Create Tables
Create Table Patients 
([PatientID] [int] IDENTITY(1,1) not null,
 [PatientFirstName] [nvarchar](100) not null,
 [PatientLastName] [nvarchar](100) not null,
 [PatientPhoneNumber] [nvarchar](100) not null,
 [PatientAddress] [nvarchar](100) not null,
 [PatientCity] [nvarchar](100) not null,
 [PatientState] [nchar](2) not null, 
 [PatientZipCode] [nvarchar](10) not null 
);
Go
 
Create Table Doctors
([DoctorID] [int] IDENTITY(1,1),
 [DoctorFirstName] [nvarchar](100) not null,
 [DoctorLastName] [nvarchar](100) not null,
 [DoctorPhoneNumber] [nvarchar](100) not null,
 [DoctorAddress] [nvarchar](100) not null,
 [DoctorCity] [nvarchar](100) not null,
 [DoctorState] [nchar](2) not null, 
 [DoctorZipCode] [nvarchar](10) not null 
);
Go

Create Table Clinics
([ClinicID] [int] IDENTITY(1,1),
 [ClinicName] [nvarchar](100) not null,
 [ClinicPhoneNumber] [nvarchar](100) not null,
 [ClinicAddress] [nvarchar](100) not null,
 [ClinicCity] [nvarchar](100) not null,
 [ClinicState] [nchar](2) not null, 
 [ClinicZipCode] [nvarchar](10) not null 
);
Go

Create Table Appointments
([AppointmentID] [int] IDENTITY(1,1), 
 [ClinicID] [int] not null,
 [DoctorID] [int] not null,
 [PatientID] [int] not null,
 [AppointmentDateTime] [datetime] not null
);
Go

-- Alter Tables (Add Constraints)
Begin -- Patients
	Alter Table Patients
	 Add Constraint pkPatients
	  Primary Key (PatientID)

	Alter Table Patients
	 Add Constraint ckPatientsPhoneFormat
	  Check (PatientPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	
	Alter Table Patients
	 Add Constraint ckPatientsZipcodeFormat
	  Check (PatientZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or 
	         PatientZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
End
Go

Begin -- Doctors
	Alter Table Doctors
	 Add Constraint pkDoctors
	  Primary Key (DoctorID)

	Alter Table Doctors
	 Add Constraint ckDoctorsPhoneFormat
	  Check (DoctorPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')

	Alter Table Doctors
	 Add Constraint ckDoctorsZipcodeFormat
	  Check (DoctorZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or 
	         DoctorZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')

End
Go

Begin -- Clinics
	Alter Table Clinics
	 Add Constraint pkClinics
	  Primary Key (ClinicID)

	Alter Table Clinics
	 Add Constraint ckClinicsPhoneFormat
	  Check (ClinicPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')

	Alter Table Clinics
	 Add Constraint ckClinicsZipcodeFormat
	  Check (ClinicZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or 
	         ClinicZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')

	Alter Table Clinics
	 Add Constraint ukClinicsName
	  Unique (ClinicName)
End
Go


Begin -- Appointments
	Alter Table Appointments
	 Add Constraint pkAppointments
	  Primary Key (AppointmentID)

	Alter Table Appointments
	 Add Constraint fkAppointmentsToClinics
	  Foreign Key (ClinicID) references Clinics(ClinicID)

	Alter Table Appointments
	 Add Constraint fkAppointmentsToDoctors
	  Foreign Key (DoctorID) references Doctors(DoctorID)

	Alter Table Appointments
	 Add Constraint fkAppointmentsToPatients
	  Foreign Key (PatientID) references Patients(PatientID)
End
Go


-- Create Views

Create View vPatients
As
	Select
	 PatientID,
	 PatientFirstName,
	 PatientLastName,
	 PatientPhoneNumber,
	 PatientAddress,
	 PatientCity,
	 PatientState,
	 PatientZipCode
	From Patients
Go

Create View vDoctors
As
	Select
	 DoctorID,
	 DoctorFirstName,
	 DoctorLastName,
	 DoctorPhoneNumber,
	 DoctorAddress,
	 DoctorCity,
	 DoctorState,
	 DoctorZipCode
	From Doctors
Go

Create View vClinics
As
	Select
	 ClinicID,
	 ClinicName,
	 ClinicPhoneNumber,
	 ClinicAddress,
	 ClinicCity,
	 ClinicState,
	 ClinicZipCode
	From Clinics
Go

Create View vAppointments
As
	Select
	 AppointmentID,
	 ClinicID,
	 DoctorID,
	 PatientID,
	 AppointmentDateTime
	From Appointments
Go

Create View vAppointmentsByPatientsDoctorsAndClinics
As
	Select
	 AppointmentID,
	 AppointmentDate = Format(Cast(AppointmentDateTime as date), 'd', 'en-US'),
	 AppointmentTime = Format(AppointmentDateTime, 'hh:mm'),
	 PatientID = Patients.PatientID,
	 PatientName = PatientFirstName + ' ' + PatientLastName,
	 PatientPhoneNumber,
	 PatientAddress,
	 PatientCity,
	 PatientState,
	 PatientZipCode,
	 DoctorID = Doctors.DoctorID,
	 DoctorName = DoctorFirstName + ' ' + DoctorLastName,
	 DoctorPhoneNumber,
	 DoctorAddress,
	 DoctorCity,
	 DoctorState,
	 DoctorZipCode,
	 ClinicID = Clinics.ClinicID,
	 ClinicName,
	 ClinicPhoneNumber,
	 ClinicAddress,
	 ClinicCity,
	 ClinicState,
	 ClinicZipCode	 
	From Appointments
	Join Clinics
	 On Appointments.ClinicID = Clinics.ClinicID
	Join Doctors
	 On Appointments.DoctorID = Doctors.DoctorID
	Join Patients
	 On Appointments.PatientID = Patients.PatientID
Go

-- Create Stored Procedures


Create Procedure pInsPatients
(@PatientID int Output,
 @PatientFirstName nvarchar(100),
 @PatientLastName nvarchar(100),
 @PatientPhoneNumber nvarchar(100),
 @PatientAddress nvarchar(100),
 @PatientCity nvarchar(100),
 @PatientState nvarchar(100),
 @PatientZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes inserting data into patients table
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
	Insert Into Patients(PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, 
						 PatientCity, PatientState, PatientZipCode)
	Values (@PatientFirstName, @PatientLastName, @PatientPhoneNumber, @PatientAddress,
			@PatientCity, @PatientState, @PatientZipCode)
	Set @PatientID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
Go

Create Procedure pUpdPatients
(@PatientID int,
 @PatientFirstName nvarchar(100),
 @PatientLastName nvarchar(100),
 @PatientPhoneNumber nvarchar(100),
 @PatientAddress nvarchar(100),
 @PatientCity nvarchar(100),
 @PatientState nvarchar(100),
 @PatientZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes updating data in patients
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
	Update Patients
	Set PatientFirstName = @PatientFirstName,
		PatientLastName = @PatientLastName,
		PatientPhoneNumber = @PatientPhoneNumber,
		PatientAddress = @PatientAddress,
		PatientCity = @PatientCity,
		PatientState = @PatientState,
		PatientZipCode = @PatientZipCode
	Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pDelPatients
(@PatientID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting data from patients
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
	Delete From Patients
	Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pInsDoctors
(@DoctorID int Output,
 @DoctorFirstName nvarchar(100),
 @DoctorLastName nvarchar(100),
 @DoctorPhoneNumber nvarchar(100),
 @DoctorAddress nvarchar(100),
 @DoctorCity nvarchar(100),
 @DoctorState nvarchar(100),
 @DoctorZipCode nvarchar(100)
 )
/* Author: Jong Tai Kim
** Desc: Processes inserting data into doctors
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
    Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, 
					     DoctorCity, DoctorState, DoctorZipCode)
	Values (@DoctorFirstName, @DoctorLastName, @DoctorPhoneNumber, @DoctorAddress, 
			@DoctorCity, @DoctorState, @DoctorZipCode)
	Set @DoctorID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pUpdDoctors
(@DoctorID int,
 @DoctorFirstName nvarchar(100),
 @DoctorLastName nvarchar(100),
 @DoctorPhoneNumber nvarchar(100),
 @DoctorAddress nvarchar(100),
 @DoctorCity nvarchar(100),
 @DoctorState nvarchar(100),
 @DoctorZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes updating data in doctors
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
    Update Doctors
	Set DoctorFirstName = @DoctorFirstName,
		DoctorLastName = @DoctorLastName,
		DoctorPhoneNumber = @DoctorPhoneNumber,
		DoctorAddress = @DoctorAddress,
		DoctorCity = @DoctorCity,
		DoctorState = @DoctorState,
		DoctorZipCode = @DoctorZipCode
	Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pDelDoctors
(@DoctorID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting data from doctors
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
	Delete From Doctors
	Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pInsClinics
(@ClinicID int Output,
 @ClinicName nvarchar(100),
 @ClinicPhoneNumber nvarchar(100),
 @ClinicAddress nvarchar(100),
 @ClinicCity nvarchar(100),
 @ClinicState nvarchar(100),
 @ClinicZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes inserting data into clinics
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
	Insert Into Clinics(ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode)
	Values (@ClinicName, @ClinicPhoneNumber, @ClinicAddress, @ClinicCity, @ClinicState, @ClinicZipCode)
    Set @ClinicID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pUpdClinics
(@ClinicID int, 
 @ClinicName nvarchar(100),
 @ClinicPhoneNumber nvarchar(100),
 @ClinicAddress nvarchar(100),
 @ClinicCity nvarchar(100),
 @ClinicState nvarchar(100),
 @ClinicZipCode nvarchar(100))
/* Author: Jong Tai Kim
** Desc: Processes updating data in clinics
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
    Update Clinics
	Set ClinicName = @ClinicName,
		ClinicPhoneNumber = @ClinicPhoneNumber,
		ClinicAddress = @ClinicAddress,
		ClinicCity = @ClinicCity,
		ClinicState = @ClinicState,
		ClinicZipCode = @ClinicZipCode
	Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pDelClinics
(@ClinicID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting data from clinics
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
    Delete From Clinics
	Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go


Create Procedure pInsAppointments
(@AppointmentID int Output,
 @ClinicID int, 
 @DoctorID int,
 @PatientID int,
 @AppointmentDateTime datetime)
/* Author: Jong Tai Kim
** Desc: Processes inserting data to appointments
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction
    Insert Into Appointments(ClinicID, DoctorID, PatientID, AppointmentDateTime)
	Values(@ClinicID, @DoctorID, @PatientID, @AppointmentDateTime)
    Set @AppointmentID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pUpdAppointments
(@AppointmentID int,
 @ClinicID int, 
 @DoctorID int,
 @PatientID int,
 @AppointmentDateTime datetime)
/* Author: Jong Tai Kim
** Desc: Processes updating data to appointments
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
    Update Appointments
	Set ClinicID = @ClinicID,
		DoctorID = @DoctorID,
		PatientID = @PatientID,
		AppointmentDateTime = @AppointmentDateTime
	Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

Create Procedure pDelAppointments
(@AppointmentID int)
/* Author: Jong Tai Kim
** Desc: Processes deleting data from appointments
** Change Log: When,Who,What
** <2018-11-23>,Jong Tai Kim,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0
  Begin Try
   Begin Transaction 
    Delete From Appointments
	Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC
 End -- Body
Go

-- Set Permissions

-- DB Permission!
-- treat public as users (patients)

Deny Select, Insert, Update, Delete On Patients To Public
Deny Select, Insert, Update, Delete On Doctors To Public
Deny Select, Insert, Update, Delete On Clinics To Public
Deny Select, Insert, Update, Delete On Appointments To Public


-- users can see any information related to clinics and doctors
Grant Select On vPatients To Public
Grant Select On vDoctors To Public
Grant Select On vClinics To Public
Grant Select On vAppointments To Public
Grant Select On vAppointmentsByPatientsDoctorsAndClinics To Public

-- users cannot make any doctor and clinic information
Grant Exec On pInsPatients To Public
Grant Exec On pUpdPatients To Public
Grant Exec On pDelPatients To Public
Grant Exec On pInsClinics To Public
Grant Exec On pUpdClinics To Public
Grant Exec On pDelClinics To Public
Grant Exec On pInsDoctors To Public
Grant Exec On pUpdDoctors To Public
Grant Exec On pDelDoctors To Public
Grant Exec On pInsAppointments To Public
Grant Exec On pUpdAppointments To Public
Grant Exec On pDelAppointments To Public


-- Test Sproc 

-- Testing Insertion
Declare @Status int
Declare @NewPatientID int 
Exec @Status = pInsPatients @PatientID = @NewPatientID Output,
							@PatientFirstName = 'Bob',
							@PatientLastName = 'Ross',
							@PatientPhoneNumber = '425-1111-2222',
							@PatientAddress = '123 Main St',
							@PatientCity = 'Seattle', 
							@PatientState = 'WA',
							@PatientZipCode = '98105'
Select [pInsPatients Status] = @Status
Select [pInsPatients ID] = @NewPatientID
Select * From vPatients

-- Declare @Status int
Declare @NewDoctorID int
Exec @Status = pInsDoctors @DoctorID = @NewDoctorID Output,
						   @DoctorFirstName = 'Sam',
						   @DoctorLastName = 'Smith',
						   @DoctorPhoneNumber = '425-1111-1234',
						   @DoctorAddress = '7777 7th Ave',
						   @DoctorCity = 'Seattle', 
						   @DoctorState = 'WA',
						   @DoctorZipCode = '98105'
Select [pInsDoctors Status] = @Status
Select [pInsDoctors ID] = @NewDoctorID
Select * From vDoctors


-- Declare @Status int
Declare @NewClinicID int
Exec @Status = pInsClinics @ClinicID = @NewClinicID Output,
						   @ClinicName = 'General Clinic',
						   @ClinicPhoneNumber = '425-1020-3040',
						   @ClinicAddress = '1024 4th St',
						   @ClinicCity = 'Seattle', 
						   @ClinicState = 'WA',
						   @ClinicZipCode = '98195'
Select [pInsClinics Status] = @Status
Select [pInsClinics ID] = @NewClinicID
Select * From vClinics


-- Declare @Status int
Declare @NewClinicID2 int
Exec @Status = pInsClinics @ClinicID = @NewClinicID2 Output,
						   @ClinicName = 'General Clinic2',
						   @ClinicPhoneNumber = '425-1020-3040',
						   @ClinicAddress = '1024 4th St',
						   @ClinicCity = 'Seattle', 
						   @ClinicState = 'WA',
						   @ClinicZipCode = '98195'
Select [pInsClinics Status] = @Status
Select [pInsClinics ID] = @NewClinicID
Select * From vClinics



--Declare @Status int
Declare @NewAppointmentID int
Exec @Status = pInsAppointments @AppointmentID = @NewAppointmentID Output,
								@ClinicID = @NewClinicID,
								@DoctorID = @NewDoctorID,
								@PatientID = @NewPatientID,
								@AppointmentDateTime = '20181125 13:00:00'
Select [pInsAppointments Status] = @Status
Select [pInsAppointments ID] = @NewAppointmentID
Select * From vAppointments

-- Testing Update
-- Declare @Status int
Exec @Status = pUpdPatients @PatientID = @NewPatientID,
							@PatientFirstName = 'Robert',
							@PatientLastName = 'Ross',
							@PatientPhoneNumber = '425-1111-2222',
							@PatientAddress = '123 Main St E311',
							@PatientCity = 'Seattle', 
							@PatientState = 'WA',
							@PatientZipCode = '98105'
Select [pUpdPatients Status] = @Status
Select * From vPatients


--Declare @Status int
Exec @Status = pUpdDoctors @DoctorID = @NewDoctorID,
						   @DoctorFirstName = 'Sam',
						   @DoctorLastName = 'Smith',
						   @DoctorPhoneNumber = '425-1111-1234',
						   @DoctorAddress = '7778 7th Ave',
						   @DoctorCity = 'Seattle', 
						   @DoctorState = 'WA',
						   @DoctorZipCode = '98105'
Select [pUpdDoctors Status] = @Status
Select * From vDoctors


-- Declare @Status int
Exec @Status = pUpdClinics @ClinicID = @NewClinicID,
						   @ClinicName = 'General Clinic',
						   @ClinicPhoneNumber = '425-1020-3040',
						   @ClinicAddress = '1030 4th St',
						   @ClinicCity = 'Seattle', 
						   @ClinicState = 'WA',
						   @ClinicZipCode = '98195'
Select [pUpdClinics Status] = @Status
Select * From vClinics



--Declare @Status int;
Exec @Status = pUpdAppointments @AppointmentID = @NewAppointmentID,
								@ClinicID = @NewClinicID2,
								@DoctorID = @NewDoctorID,
								@PatientID = @NewPatientID,
								@AppointmentDateTime = '20181126 13:30:00'
Select [pUpdAppointments Status] = @Status
Select * From vAppointments

-- Testing Delete
-- Declare @Status int
Exec @Status = pDelAppointments @AppointmentID = @NewAppointmentID
Select [pDelAppointments Status] = @Status


--Declare @Status int
Exec @Status = pDelPatients @PatientID = @NewPatientID
Select [pDelPatients Status] = @Status


--Declare @Status int
Exec @Status = pDelDoctors @DoctorID = @NewDoctorID
Select [pDelDoctors Status] = @Status


--Declare @Status int
Exec @Status = pDelClinics @ClinicID = @NewClinicID
Select [pDelClinics Status] = @Status


--Declare @Status int
Exec @Status = pDelClinics @ClinicID = @NewClinicID2
Select [pDelClinics Status] = @Status
Go

Select * From vPatients
Select * From vDoctors
Select * From vClinics
Select * From vAppointments
Select * From vAppointmentsByPatientsDoctorsAndClinics
Go


