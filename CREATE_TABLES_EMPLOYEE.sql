
/*
CREATE TABLES, INSERT VALUES
*/




Create Table EmployeeDemographics (
	EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50)
)


Create Table EmployeeSalary (
	EmployeeID int,
	JobTitle varchar(50), 
	Salary int
)


Create Table WareHouseEmployeeDemographics (
	EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50)
)


Insert into EmployeeDemographics VALUES
	(1001, 'Jim', 'Halpert', 30, 'Male'),
	(1002, 'Pam', 'Beasley', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela', 'Martin', 31, 'Female'),
	(1005, 'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Michael', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
	(1009, 'Kevin', 'Malone', 31, 'Male'),
	(1011, 'Ryan', 'Howard', 26, 'Male'),
	(NULL, 'Holly', 'Flax', NULL, NULL),
	(1013, 'Darryl', 'Philbin', NULL, 'Male')


Insert Into EmployeeSalary VALUES
	(1001, 'Salesman', 45000),
	(1002, 'Receptionist', 36000),
	(1003, 'Salesman', 63000),
	(1004, 'Accountant', 47000),
	(1005, 'HR', 50000),
	(1006, 'Regional Manager', 65000),
	(1007, 'Supplier Relations', 41000),
	(1008, 'Salesman', 48000),
	(1009, 'Accountant', 42000),
	(1010, 'Teacher', 35000)


Insert into WareHouseEmployeeDemographics VALUES
	(1013, 'Darryl', 'Philbin', NULL, 'Male'),
	(1050, 'Roy', 'Anderson', 31, 'Male'),
	(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
	(1052, 'Val', 'Johnson', 31, 'Female')


DROP TABLE EmployeeSalary
DROP TABLE EmployeeDemographics


--JOIN EmployeeDemographics and EmployeeSalary

SELECT *
FROM [Let's Begin].dbo.EmployeeDemographics
Inner Join [Let's Begin].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

SELECT *
FROM [Let's Begin].dbo.EmployeeDemographics
Full Outer Join [Let's Begin].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--Calculate Salary Raise

SELECT FirstName, LastName, JobTitle, Salary,
CASE 
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .1)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
	ELSE Salary + (Salary *.03)
END AS SalaryAfterRaise
FROM [Let's Begin].dbo.EmployeeDemographics
Join [Let's Begin].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID



--JOIN EmployeeDemographics and WareHouseEmployeeDemographics

SELECT *
FROM [Let's Begin].dbo.EmployeeDemographics
Full Outer Join [Let's Begin].dbo.WareHouseEmployeeDemographics
		ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID


--UNION EmployeeDemographics and WareHouseEmployeeDemographics

SELECT *
FROM [Let's Begin].dbo.EmployeeDemographics
UNION 
SELECT *
FROM [Let's Begin].dbo.WareHouseEmployeeDemographics


SELECT *
FROM [Let's Begin].dbo.EmployeeDemographics
UNION ALL
SELECT *
FROM [Let's Begin].dbo.WareHouseEmployeeDemographics
ORDER BY EmployeeID

