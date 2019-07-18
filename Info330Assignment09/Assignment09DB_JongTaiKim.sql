--**********************************************************************************************--
-- Title: Assigment08 - MileStone 03
-- Author: JongTaiKim
-- Desc: Make a Sample Data on Patients Appointment database using mockaroo and hard code. 
-- Change Log: When,Who,What
-- 2018-12-01,JongTaiKim,Created File
--***********************************************************************************************--

-- Task 1: Basic Sample Data into tables using mockaroo

Use Assignment08DB_JongTaiKim
Go

Delete From Appointments;
DBCC CHECKIDENT ('Appointments', RESEED, 0);
Delete From Clinics;
DBCC CHECKIDENT ('Clinics', RESEED, 0);
Delete From Patients;
DBCC CHECKIDENT ('Patients', RESEED, 0);
Delete From Doctors;
DBCC CHECKIDENT ('Doctors', RESEED, 0);
Go


Insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) 
Values  ('Vasilis', 'Sans', '253-244-2248', '7821 Mendota Center', 'Seattle', 'WA', '98166'), 
		('Zacharia', 'Foster-Smith', '206-549-8332', '6 Barby Place', 'Seattle', 'WA', '98195'),
		('Aubree', 'Caldero', '425-238-6584', '5691 Main Road', 'Seattle', 'WA', '98133'),
		('Filippo', 'O'' Lone', '206-920-0387', '45955 Ridgeway Junction', 'Seattle', 'WA', '98109'),
		('Milissent', 'Kryszka', '425-713-2407', '5249 Ridgeway Circle', 'Seattle', 'WA', '98133'),
		('Annette', 'Castagnaro', '206-885-4222', '67681 Oriole Crossing', 'Bellevue', 'WA', '98008'),
		('Patsy', 'Jerromes', '206-953-2127', '8 Randy Drive', 'Seattle', 'WA', '98140'),
		('Kristy', 'Columbell', '253-388-7111', '7929 Spohn Crossing', 'Seattle', 'WA', '98148'),
		('Salmon', 'Ege', '360-371-9296', '18 Di Loreto Street', 'Kent', 'WA', '98042'),
		('Halsey', 'Wedlake', '425-893-0929', '93468 Blaine Drive', 'Everett', 'WA', '98206');

Insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) 
Values  ('Town', 'Tarpey', '425-859-7212', '0 Summerview Place', 'Seattle', 'WA', '98140'),
		('Bing', 'Schelle', '425-383-9997', '04 Clarendon Junction', 'Seattle', 'WA', '98133'),
		('Penni', 'Belcher', '206-163-4692', '8 Merchant Center', 'Seattle', 'WA', '98175'),
		('Jordan', 'Seczyk', '425-677-4165', '2523 Lindbergh Hill', 'Seattle', 'WA', '98140'), 
		('Harley', 'Ghest', '206-242-1553', '27 Hoepker Hill', 'Seattle', 'WA', '98140'),
		('Fleur', 'Millard', '253-524-2198', '768 Garrison Way', 'Seattle', 'WA', '98166'),
		('Evita', 'Rhodef', '206-235-2690', '8442 Waxwing Alley', 'Seattle', 'WA', '98185'),
		('Bev', 'Seggie', '206-132-5621', '804 Moland Street', 'Seattle', 'WA', '98195'),
		('Eyde', 'Herley', '206-918-0291', '04 Mcguire Alley', 'Seattle', 'WA', '98175'), 
		('Berke', 'Snar', '425-939-6070', '1 Pawling Parkway', 'Bellevue', 'WA', '98008');


Insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) 
Values  ('Dental Clinic', '425-912-4237', '14832 Merchant Hill', 'Seattle', 'WA', '98158'),
		('Vision Clinic', '206-428-4494', '55 Northwestern Pass', 'Seattle', 'WA', '98127'),
		('Pediatric Clinic', '360-817-5198', '2593 American Point', 'Seattle', 'WA', '98104'),
		('Chiropractic Clinic', '206-920-0272', '06 Forest Dale Center', 'Seattle', 'WA', '98195'),
		('Mental Clinic', '360-305-1237', '1337 Eastwood Parkway', 'Seattle', 'WA', '98158');

Insert into Appointments (ClinicID, DoctorID, PatientID, AppointmentDateTime) 
Values (1, 1, 8, '2018-11-26 09:00'),
(3, 8, 3, '2018-11-26 13:30'),
(5, 2, 10, '2018-11-27 14:00'),
(3, 9, 6, '2018-11-29 10:00'),
(2, 5, 9, '2018-11-30 11:30'),
(1, 3, 7, '2018-11-28 15:00'),
(5, 7, 2, '2018-11-29 16:00'),
(4, 10, 4, '2018-11-27 15:30'),
(2, 6, 10, '2018-11-28 09:30'),
(4, 4, 1, '2018-11-30 10:30');
Go

Select * From vPatients
Select * From vDoctors
Select * From vClinics
Select * From vAppointments
Go

