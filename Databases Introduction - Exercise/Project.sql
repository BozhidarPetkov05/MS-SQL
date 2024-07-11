--P01. Create Database
CREATE DATABASE Minions

--P02. Create Tables
CREATE TABLE Minions
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(50),
	Age INT
)
CREATE TABLE Towns
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(50)
)

--P03. Alter Minions Table
ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

--P04. Insert Records in Both Tables
INSERT INTO Towns
VALUES(1, 'Sofia'),
	  (2, 'Plovdiv'),
	  (3, 'Varna')

INSERT INTO Minions (Id, [Name], Age, TownId)
VALUES(1, 'Kevin', 22, 1),
	  (2, 'Bob', 15, 3),
	  (3, 'Steward', NULL, 2)

--P05. Truncate Table Minions
TRUNCATE TABLE Minions

--P06. Drop All Tables
DROP TABLE Minions
DROP TABLE Towns

--P07. Create Table People
CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(200),
	Picture VARBINARY(MAX),
	Height DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	Gender CHAR(1) NOT NULL,
		CHECK(Gender in('m', 'f')),
	Birthdate DATETIME2 NOT NULL,
	Biography VARCHAR(MAX)
)

INSERT INTO People ([Name], Gender, Birthdate)
VALUES('Gosho', 'm', '1998-05-05'),
	  ('Tosho', 'm', '1898-02-05'),
	  ('Yorgo', 'm', '1918-03-05'),
      ('Donka', 'f', '1998-05-04'),
      ('Konka', 'f', '1998-01-09')

--P08. Create Table Users
CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATETIME2,
	IsDeleted BIT 
)

INSERT INTO Users (Username, [Password])
VALUES ('Pe6o', '123456'),
	   ('To6o', '654321'),
	   ('Rango', '000000'),
	   ('Gu6tera', '999999'),
	   ('Grigorio', '9517538264')

--P09. Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC07FF67D98F

ALTER TABLE Users
ADD CONSTRAINT PK_UsersTable PRIMARY KEY(Id, Username)

--P10. Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT CHK_PasswordIsAtleastFiveSymbols
	CHECK(LEN(Password) >= 5)

--P11. Set Default Value of a Field
UPDATE Users
SET LastLoginTime = GETDATE()

--P12. Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_UsersTable

ALTER TABLE Users
ADD CONSTRAINT CHK_UsernameAtleastThreeSymbols
	CHECK(LEN(Username) >= 3)

--P13. Movies Database
CREATE DATABASE Movies

CREATE TABLE Directors
(
    Id int IDENTITY ,
    DirectorName nvarchar(50) NOT NULL,
    Notes nvarchar(MAX)
)

CREATE TABLE Genres
(
    Id int IDENTITY,
    GenereName nvarchar(50) NOT NULL,
    Notes nvarchar(MAX)
)

CREATE TABLE Categories 
(
    Id int IDENTITY,
    CategoryName nvarchar(50) NOT NULL,
    Notes nvarchar(MAX)
)

CREATE TABLE Movies
(
    Id int IDENTITY,
    Title nvarchar(50),
    DirectorId int,
    CopyrightYear  int,
    Length int,
    GenreId int,
    CatgoryId int,
    Rating int, 
    Notes nvarchar(MAX)
)

ALTER TABLE Directors
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Genres
ADD CONSTRAINT PK_Genres
PRIMARY KEY (Id)

ALTER TABLE Categories
ADD CONSTRAINT PK_Categories
PRIMARY KEY (Id)

ALTER TABLE Movies
ADD CONSTRAINT PK_Movies
PRIMARY KEY (Id)

INSERT INTO Directors(DirectorName,Notes)
VALUES ('Pesho', 'Пешо е добър служител'), 
('Mitko','Митко е най-добрия'),
('Калин', 'Отличникът'),
('Калина', 'Не'),
('Явор', 'Връзкар')

INSERT INTO Genres (GenereName, Notes)
VALUES ('Asen', 'klklkl'),
('Kaloqn', ' lrlllll'),
('Simeon', 'Aheloi'),
('Boris', 'Покръстителят'),
('Крум', 'Крумовите закони')

INSERT INTO Categories (CategoryName,Notes)
VALUES ('HISTORY', 'Отличен филм'),
('Action', 'Oscar'),
('History','lklllllk'),
('drama', 'lkooooopo' ),
('Triller', 'llkllkklk')

INSERT INTO Movies (Title,DirectorId,CopyrightYear,Length,GenreId,CatgoryId,Rating,Notes)
VALUES(' King' ,5,1999,78,1,5,10,'otlichen'),
('RRIRIR',4,2000,90,2,4,9,'otlichen'),
('plpppo',3,1980,100,3,3,5,'otlichen'),
('kkiklo',2,1890,20,4,2,10,'iopkll'),
('ukukkk',1,1990,120,5,1,10,'plpppp')

--P14. Car Rental Database
CREATE DATABASE CarRental

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Category VARCHAR(50) NOT NULL,
	DailyRate INT,
	WeeklyRate INT,
	MonthlyRate INT,
	WeekendRate int
)
CREATE TABLE Cars
(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber VARCHAR(50) NOT NULL,
	Make VARCHAR(50),
    Model VARCHAR(50),
	CarYear INT,
	CategoryId INT,
	Doors INT,
	Picture VARBINARY(MAX),
	CarCondition varchar(50),
	Available BIT
)
CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50),
	Notes VARCHAR(MAX)
)
CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber INT NOT NULL,
	FullName VARCHAR(50),
	[Address] VARCHAR(50),
	City VARCHAR(50),
	ZipCode int,
	Notes VARCHAR(MAX)
)
 
CREATE TABLE RentalOrders 
(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT NOT NULL,
	CustomerId INT,
	CarId INT NOT NULL,
	CarCondition VARCHAR(50),
	TankLevel INT,
	KilometrageStart INT,
	KilometrageEnd INT,
	TotalKilometrage INT,
	StartDate DATETIME2,
	EndDate DATETIME2,
	TotalDays INT,
	RateApplied INT,
	TaxRate INT,
	OrderStatus VARCHAR(50),
	Notes VARCHAR(MAX)
)
INSERT INTO Cars(PlateNumber)
VALUES ('123'),('1234'),('12345');
INSERT INTO Categories(Category)
VALUES ('Classic'),('Limuzine'),('Sport');
INSERT INTO Customers(DriverLicenceNumber)
VALUES ('2232'),('232323'),('111');
INSERT INTO Employees(FirstName, LastName)
VALUES ('Ivan', 'Ivanov'),('Ivan1', 'Ivanov1'), ('Ivan2', 'Ivanov2');
INSERT INTO RentalOrders(EmployeeId, CarId)
VALUES (1, 1),(1, 2), (2, 3)


--P15. Hotel Database
CREATE DATABASE Hotel

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Title VARCHAR(50),
Notes VARCHAR(MAX)
)
 
INSERT INTO Employees
VALUES
('Velizar', 'Velikov', 'Receptionist', 'Nice customer'),
('Ivan', 'Ivanov', 'Concierge', 'Nice one'),
('Elisaveta', 'Bagriana', 'Cleaner', 'Poetesa')
 
CREATE TABLE Customers(
Id INT PRIMARY KEY IDENTITY NOT NULL,
AccountNumber BIGINT,
FirstName VARCHAR(50),
LastName VARCHAR(50),
PhoneNumber VARCHAR(15),
EmergencyName VARCHAR(150),
EmergencyNumber VARCHAR(15),
Notes VARCHAR(100)
)
 
INSERT INTO Customers
VALUES
(123456789, 'Ginka', 'Shikerova', '359888777888', 'Sistry mi', '7708315342', 'Kinky'),
(123480933, 'Chaika', 'Stavreva', '359888777888', 'Sistry mi', '7708315342', 'Lawer'),
(123454432, 'Mladen', 'Isaev', '359888777888', 'Sistry mi', '7708315342', 'Wants a call girl')
 
CREATE TABLE RoomStatus(
Id INT PRIMARY KEY IDENTITY NOT NULL,
RoomStatus BIT,
Notes VARCHAR(MAX)
)
 
INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES
(1,'Refill the minibar'),
(2,'Check the towels'),
(3,'Move the bed for couple')
 
CREATE TABLE RoomTypes(
RoomType VARCHAR(50) PRIMARY KEY,
Notes VARCHAR(MAX)
)
 
INSERT INTO RoomTypes (RoomType, Notes)
VALUES
('Suite', 'Two beds'),
('Wedding suite', 'One king size bed'),
('Apartment', 'Up to 3 adults and 2 children')
 
CREATE TABLE BedTypes(
BedType VARCHAR(50) PRIMARY KEY,
Notes VARCHAR(MAX)
)
 
INSERT INTO BedTypes
VALUES
('Double', 'One adult and one child'),
('King size', 'Two adults'),
('Couch', 'One child')
 
CREATE TABLE Rooms (
RoomNumber INT PRIMARY KEY IDENTITY NOT NULL,
RoomType VARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType),
BedType VARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType),
Rate DECIMAL(6,2),
RoomStatus NVARCHAR(50),
Notes NVARCHAR(MAX)
)
 
INSERT INTO Rooms (Rate, Notes)
VALUES
(12,'Free'),
(15, 'Free'),
(23, 'Clean it')
 
CREATE TABLE Payments(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
PaymentDate DATE,
AccountNumber BIGINT,
FirstDateOccupied DATE,
LastDateOccupied DATE,
TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
AmountCharged DECIMAL(14,2),
TaxRate DECIMAL(8, 2),
TaxAmount DECIMAL(8, 2),
PaymentTotal DECIMAL(15, 2),
Notes VARCHAR(MAX)
)
 
INSERT INTO Payments (EmployeeId, PaymentDate, AmountCharged)
VALUES
(1, '12/12/2018', 2000.40),
(2, '12/12/2018', 1500.40),
(3, '12/12/2018', 1000.40)
 
CREATE TABLE Occupancies(
Id  INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
DateOccupied DATE,
AccountNumber BIGINT,
RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
RateApplied DECIMAL(6,2),
PhoneCharge DECIMAL(6,2),
Notes VARCHAR(MAX)
)
 
INSERT INTO Occupancies (EmployeeId, RateApplied, Notes) VALUES
(1, 55.55, 'too'),
(2, 15.55, 'much'),
(3, 35.55, 'typing')


--P16. Create SoftUni Database
CREATE DATABASE SoftUni
USE SoftUni

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(60)
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	AddressText VARCHAR(MAX),
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)
CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(60)
)
CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(60) NOT NULL,
	MiddleName VARCHAR(60),
	LastName VARCHAR(60) NOT NULL,
	JobTitle VARCHAR(60) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATETIME2 NOT NULL,
	Salary DECIMAL(10, 2) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)
--P17. Backup Database

--P18. Basic Insert
INSERT INTO Departments
VALUES('Software Development'),
	  ('Engineering'),
	  ('Quality Assurance'),
	  ('Sales'),
	  ('Marketing')

INSERT INTO Towns
VALUES('Sofia'),
	  ('Plovdiv'),
	  ('Varna'),
	  ('Burgas')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 1, '2013-02-01', 3500),
	  ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 2, '2004-02-01', 4000),
	  ('Maria', 'Petrova', 'Ivanova', 'Intern', 3, '2016-08-28', 525.25),
	  ('Georgi', 'Terziev', 'Ivanov', 'CEO', 4, '2007-12-09', 3000),
	  ('Petar', 'Pan', 'Pan', 'Intern', 5, '2016-08-28', 599.88)

--P19. Basic Select All Fields
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--P20. Basic Select All Fields and Order Them
SELECT * FROM Towns ORDER BY [Name]
SELECT * FROM Departments ORDER BY [Name]
SELECT * FROM Employees ORDER BY Salary DESC

--P21. Basic Select Some Fields
SELECT [Name] FROM Towns ORDER BY [Name]
SELECT [Name] FROM Departments ORDER BY [Name]
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

--P22. Increase Employees Salary
UPDATE Employees
SET Salary = Salary * 1.1
SELECT Salary FROM Employees

--P23. Decrease Tax Rate
UPDATE Payments
SET TaxRate = TaxRate - 0.03 * TaxRate
SELECT TaxRate FROM Payments

--P24. Delete All Records
TRUNCATE TABLE Occupancies