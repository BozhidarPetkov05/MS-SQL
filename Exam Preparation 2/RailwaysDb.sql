CREATE DATABASE RailwaysDb
USE RailwaysDb

--P01. DDL
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE RailwayStations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	TownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Trains
(
	Id INT PRIMARY KEY IDENTITY,
	HourOfDeparture VARCHAR(5) NOT NULL,
	HourOfArrival VARCHAR(5) NOT NULL,
	DepartureTownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id),
	ArrivalTownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE TrainsRailwayStations
(
	TrainId INT NOT NULL,
	RailwayStationId INT NOT NULL,
	PRIMARY KEY (TrainId, RailwayStationId), 
	FOREIGN KEY (TrainId) REFERENCES Trains(Id),
	FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)
)

CREATE TABLE MaintenanceRecords
(
	Id INT PRIMARY KEY IDENTITY,
	DateOfMaintenance DATE NOT NULL,
	Details VARCHAR(2000) NOT NULL,
	TrainId INT NOT NULL FOREIGN KEY REFERENCES Trains(Id)
)

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(18, 2) NOT NULL,
	DateOfDeparture DATE NOT NULL,
	DateOfArrival DATE NOT NULL,
	TrainId INT NOT NULL FOREIGN KEY REFERENCES Trains(Id),
	PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id)
)

--P02. Insert
INSERT INTO Trains
VALUES ('07:00', '19:00', 1, 3),
	   ('08:30', '20:30', 5, 6),
	   ('09:00', '21:00', 4, 8),
	   ('06:45', '03:55', 27, 7),
	   ('10:15', '12:15', 15, 5)

INSERT INTO TrainsRailwayStations
VALUES (36, 1),
	   (36, 4),
	   (36, 31),
	   (36, 57),
	   (36, 7),
	   (37, 13),
	   (37, 54),
	   (37, 60),
	   (37, 16),
	   (38, 10),
	   (38, 50),
	   (38, 52),
	   (38, 22),
	   (39, 68),
	   (39, 3),
	   (39, 31),
	   (39, 19),
	   (40, 41),
	   (40, 7),
	   (40, 52),
	   (40, 13)

INSERT INTO Tickets
VALUES(90.00, '2023-12-01', '2023-12-01', 36, 1),
	  (115.00, '2023-08-02', '2023-08-02', 37, 2),
	  (160.00, '2023-08-03', '2023-08-03', 38, 3),
	  (255.00, '2023-09-01', '2023-09-02', 39, 21),
	  (95.00, '2023-09-02', '2023-09-03', 40, 22)

--P03. Update
UPDATE Tickets
SET DateOfDeparture = DATEADD(DAY, 7, DateOfDeparture),
	DateOfArrival = DATEADD(DAY, 7, DateOfArrival)
WHERE DATEPART(MONTH, DateOfDeparture) > 10

--P04. Delete
DELETE
FROM TrainsRailwayStations
WHERE TrainId = 7

DELETE
FROM MaintenanceRecords
WHERE TrainId = 7

DELETE 
FROM Tickets
WHERE TrainId = 7

DELETE
FROM Trains
WHERE DepartureTownId IN
(SELECT Id FROM Towns WHERE [Name] = 'Berlin')

--P05. Tickets by Price and Date Departure
SELECT 
	DateOfDeparture, 
	Price AS TicketPrice
FROM Tickets
ORDER BY TicketPrice,
		 DateOfDeparture DESC

--P06. Passengers with their Tickets
SELECT 
	p.[Name] AS PassengerName,
	ti.Price AS TicketPrice,
	ti.DateOfDeparture,
	tr.Id AS TrainID
FROM Tickets AS ti
JOIN Trains AS tr ON ti.TrainId = tr.Id
JOIN Passengers AS p ON ti.PassengerId = p.Id
ORDER BY 
	TicketPrice DESC,
	p.[Name] ASC

--P07. Railway Stations without Passing Trains
SELECT 
	t.[Name] AS TownName, 
	s.[Name] AS RailwayStation
FROM RailwayStations AS s
JOIN Towns AS t ON s.TownId = t.Id
WHERE NOT EXISTS
	(SELECT 1 FROM TrainsRailwayStations WHERE RailwayStationId = s.Id)
ORDER BY
	t.[Name] ASC,
	s.[Name] ASC

--P08. First 3 Trains Between 08:00 and 08:59
SELECT TOP(3)
	tr.Id AS TrainId,
	tr.HourOfDeparture,
	ti.Price AS TicketPrice,
	t.[Name] AS Destination
FROM Trains AS tr
JOIN Tickets AS ti ON tr.Id = ti.TrainId
JOIN Towns AS t ON tr.ArrivalTownId = t.Id
WHERE 
	CAST(tr.HourOfDeparture AS TIME) BETWEEN '08:00' AND '08:59'
	AND ti.Price> 50.00
ORDER BY 
	ti.Price ASC

--P09. Count of Passengers Paid More Than Average
SELECT 
	t.[Name] AS TownName,
	COUNT(p.Id) AS PassengersCount
FROM Passengers AS p
JOIN Tickets AS ti ON p.Id = ti.PassengerId
JOIN Trains AS tr ON ti.TrainId = tr.Id
JOIN Towns AS t ON t.Id = tr.ArrivalTownId
WHERE ti.Price > (76.99)
GROUP BY t.[Name]
ORDER BY t.[Name] ASC

--P10. Maintenance Inspection with Town and Station
SELECT 
	tr.Id AS TrainID,
	t.[Name] AS DepartureTown,
	mr.Details
FROM Trains AS tr
JOIN Towns AS t ON tr.DepartureTownId = t.Id
JOIN MaintenanceRecords AS mr ON mr.TrainId = tr.Id
WHERE mr.Details LIKE '%inspection%'
ORDER BY tr.Id

--P11. Towns with Trains
CREATE FUNCTION udf_TownsWithTrains(@name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @result INT;

	SELECT @result = COUNT(tr.Id)
	FROM Trains AS tr
	JOIN Towns AS t ON tr.DepartureTownId = t.Id
	JOIN Towns AS ta ON tr.ArrivalTownId = ta.Id
	WHERE 
		t.[Name] = @name OR ta.[Name] = @name

	RETURN @result
END

--P12. Search Passengers travelling to Specific Town
CREATE PROCEDURE usp_SearchByTown(@townName VARCHAR(50))
AS
BEGIN
	SELECT 
		p.[Name] AS PassengerName,
		ti.DateOfDeparture,
		tr.HourOfDeparture
 	FROM Passengers AS p
	JOIN Tickets AS ti ON p.Id = ti.PassengerId
	JOIN Trains AS tr ON tr.Id = ti.TrainId
	JOIN Towns AS t ON t.Id = tr.ArrivalTownId
	WHERE t.[Name] = @townName
	ORDER BY
		ti.DateOfDeparture DESC,
		PassengerName
END