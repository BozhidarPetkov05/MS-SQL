CREATE DATABASE DataStorage
USE DataStorage

--P01. One-To-One Relationship
CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101, 1),
	PassportNumber VARCHAR(32) NOT NULL
)

CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY(1, 1),
	FirstName VARCHAR(32) NOT NULL,
	Salary DECIMAL(10, 2),
	PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports
VALUES('N34FG21B'),
	  ('K65LO4R7'),
	  ('ZE657QP2')

INSERT INTO Persons
VALUES('Roberto', 43300.00, 102),
	  ('Tom', 56100.00, 103),
	  ('Yana', 60200.00, 101)

--P02. One-To-Many Relationship
CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(50) UNIQUE NOT NULL,
	EstablishedOn DATETIME2 NOT NULL
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers
VALUES('BMW', '07/03/1916'),
	  ('Tesla', '01/01/2003'),
	  ('Lada', '01/05/1966')

INSERT INTO Models
VALUES('X1', 1),
	  ('i6', 1),
	  ('Model S', 2),
	  ('Model X', 2),
	  ('Model 3', 2),
	  ('Nova', 3)

--P03. Many-To-Many Relationship
CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(32) NOT NULL
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(32) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
	CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID)
)

INSERT INTO Students
VALUES('Mila'),
	  ('Toni'),
	  ('Ron')

INSERT INTO Exams
VALUES('SpringMVC'),
	  ('Neo4j'),
	  ('Oracle 11g')

INSERT INTO StudentsExams
VALUES(1, 101),
	  (1, 102),
	  (2, 101),
	  (3, 103),
	  (2, 102),
	  (2, 103)

--P04. Self-Referencing
CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	ManagerID INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES(101, 'John', NULL),
	  (106, 'Greta', 101),
	  (105, 'Mark', 101),
	  (104, 'Ted', 105),
	  (102, 'Maya', 106),
	  (103, 'Silvia', 106)

--P05. Online Store Database
CREATE DATABASE OnlineStore
USE OnlineStore

CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Birthday DATETIME2 NOT NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems
(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
	CONSTRAINT PK_OrderedItems PRIMARY KEY(OrderID, ItemID)
)

--P06. University Database
CREATE DATABASE University
USE University

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(64)
)

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber VARCHAR(64) NOT NULL,
	StudentName VARCHAR(64) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME2 NOT NULL,
	PaymentAmount DECIMAL(6, 2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR(64) NOT NULL
)

CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	CONSTRAINT PK_Agenda PRIMARY KEY(StudentID, SubjectID)
)

--P07. SoftUni Design
--E/R Diagram of the SoftUni Database

--P08. Geography Design
--E/R Diagram of the Geography Database

--P09. Peaks in Rila
SELECT MountainRange, PeakName, Elevation FROM Peaks
JOIN Mountains ON Peaks.MountainID = Mountains.Id
WHERE MountainId = 17
ORDER BY Elevation DESC
--17

SELECT * FROM Mountains