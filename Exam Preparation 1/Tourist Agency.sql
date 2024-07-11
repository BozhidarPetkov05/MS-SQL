CREATE DATABASE TouristAgency
USE TouristAgency

--P01. DDL
CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(50) NOT NULL,
	Price DECIMAL(18, 2) NOT NULL,
	BedCount INT NOT NULL
		CHECK(BedCount > 0 AND BedCount <= 10)
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DestinationId INT NOT NULL FOREIGN KEY REFERENCES Destinations(Id)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Email VARCHAR(80),
	CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Bookings
(
	Id INT PRIMARY KEY IDENTITY,
	ArrivalDate DATETIME2 NOT NULL,
	DepartureDate DATETIME2 NOT NULL,
	AdultsCount INT NOT NULL
		CHECK(AdultsCount >= 1 AND AdultsCount <= 10),
	ChildrenCount INT NOT NULL
		CHECK(ChildrenCount >= 0 AND ChildrenCount <= 9),
	TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id),
	HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id),
	RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id)
)

CREATE TABLE HotelsRooms
(
	HotelId INT NOT NULL,
	RoomId INT NOT NULL,
	CONSTRAINT PK_HotelsRooms PRIMARY KEY (HotelId, RoomId),
	CONSTRAINT FK_HotelsRooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id), 
	CONSTRAINT FK_HotelsRooms_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

--P02. Insert
INSERT INTO Tourists
	VALUES('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
		  ('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
		  ('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
		  ('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
		  ('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

INSERT INTO Bookings
	VALUES('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
		  ('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
		  ('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
		  ('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
		  ('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)

--P03. Update
UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE ArrivalDate >= '2023-12-01' AND ArrivalDate <= '2023-12-31'

UPDATE Tourists
SET Email = NULL
WHERE [Name] LIKE '%MA%'

--P04. Delete
BEGIN TRANSACTION
	DECLARE @TouristToDelete TABLE (Id INT)

	INSERT INTO @TouristToDelete(Id)
		SELECT Id 
		FROM Tourists
		WHERE [Name] LIKE '%Smith%'

	DELETE FROM Bookings
	WHERE TouristId IN (SELECT Id FROM @TouristToDelete)

	DELETE FROM Tourists
	WHERE Id IN (SELECT Id FROM @TouristToDelete)
COMMIT

--P05. Bookings by Price of Room and Arrival Date
SELECT 
	FORMAT(ArrivalDate, 'yyyy-MM-dd') AS ArrivalDate, 
	AdultsCount, ChildrenCount 
FROM Bookings AS b
JOIN Rooms AS r ON b.RoomId = r.Id
ORDER BY r.Price DESC,
		 b.ArrivalDate

--P06. Hotels by Count of Bookings
SELECT h.Id, h.[Name]
FROM Hotels AS h
JOIN HotelsRooms AS hr ON hr.HotelId = h.Id
JOIN Rooms AS r ON r.Id = hr.RoomId
JOIN Bookings AS b ON b.HotelId = h.Id 
		AND r.[Type] = 'VIP Apartment'
GROUP BY h.Id, h.[Name]
ORDER BY COUNT(*) DESC

--P07. Tourists without Bookings
SELECT t.Id, t.[Name], t.PhoneNumber
FROM Tourists AS t
LEFT JOIN Bookings AS b ON t.Id = b.TouristId
WHERE b.HotelId IS NULL
ORDER BY [Name]

--P08. First 10 Bookings
SELECT TOP(10) h.[Name] AS HotelName, d.[Name] AS DestinationName, c.[Name] AS CountryName 
FROM Bookings AS b
JOIN Hotels AS h ON b.HotelId = h.Id
JOIN Destinations AS d ON h.DestinationId = d.Id
JOIN Countries AS c ON d.CountryId = c.Id
WHERE ArrivalDate < '2023-12-31'
	AND h.Id % 2 <> 0
ORDER BY CountryName,
		 ArrivalDate

--P09. Tourists booked in Hotels
SELECT h.[Name] AS HotelName, r.Price AS RoomPrice
FROM Tourists AS t
JOIN Bookings AS b ON b.TouristId = t.Id
JOIN Rooms AS r ON b.RoomId = r.Id
JOIN Hotels AS h ON h.Id = b.HotelId
WHERE t.[Name] NOT LIKE '%EZ' 
ORDER BY r.Price DESC

--P10. Hotels Revenue
SELECT 
	h.[Name] AS HotelName,
	SUM(Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)) AS HotelRevenue
FROM Bookings AS b
JOIN Hotels AS h ON b.HotelId = h.Id
JOIN Rooms AS r ON b.RoomId = r.Id
GROUP BY h.[Name]
ORDER BY HotelRevenue DESC

--P11. Rooms with Tourists
CREATE FUNCTION udf_RoomsWithTourists(@name VARCHAR(50))
RETURNS INT
AS
BEGIN
RETURN
(
	SELECT SUM(b.ChildrenCount + b.AdultsCount)
	FROM Bookings AS b
	JOIN Rooms AS r ON r.Id = b.RoomId
	WHERE r.[Type] = @name
)
END

--P12. Search for Tourists from a Specific Country
CREATE PROCEDURE usp_SearchByCountry(@country VARCHAR(50))
AS
BEGIN
	SELECT t.[Name], t.PhoneNumber, t.Email, COUNT(*) AS CountOf
	FROM Tourists AS t
	JOIN Bookings AS b ON b.TouristId = t.Id
	JOIN Countries AS c ON c.Id = t.CountryId
	JOIN Rooms AS r ON r.Id = b.RoomId
	WHERE c.[Name] = @country
	GROUP BY b.TouristId, t.[Name], t.PhoneNumber, t.Email
	ORDER BY t.[Name], COUNT(*) DESC
END



