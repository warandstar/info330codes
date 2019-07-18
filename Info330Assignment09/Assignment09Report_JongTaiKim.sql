--**********************************************************************************************--
-- Title: Assigment08 - MileStone 03
-- Author: JongTaiKim
-- Desc: Make reporting views 
-- Change Log: When,Who,What
-- 2018-12-01,JongTaiKim,Created File
--***********************************************************************************************--


-- Task 2: Making Reporting Views

Use Assignment08DB_JongTaiKim
Go
Begin Try
	IF EXISTS(select * FROM sys.views where name = 'vPatientToWhichClinic')
	 Begin 
	  Drop View vPatientToWhichClinic;
	 End
End Try
Begin Catch
	Print Error_Number()
End Catch
Go
-- Present the patients' appointments in which clinic in where at when with which doctor 
Create View vPatientToWhichClinic
As
	Select
	 PatientName = PatientFirstName + ' ' + PatientLastName,
	 DoctorName = DoctorFirstName + ' ' + DoctorLastName,
	 ClinicName,
	 ClinicAddress = ClinicAddress + ', ' + ClinicCity + ', ' + ClinicState + ', ' + ClinicZipCode,
	 AppointmentDate = Format(Cast(AppointmentDateTime as date), 'd', 'en-US'),
	 AppointmentTime = Format(Cast(AppointmentDateTime as time), 'hh\:mm')
	From Appointments
	Join Clinics
	 On Appointments.ClinicID = Clinics.ClinicID
	Join Doctors
	 On Appointments.DoctorID = Doctors.DoctorID
	Join Patients
	 On Appointments.PatientID = Patients.PatientID
Go

Select * From vPatientToWhichClinic
Go

