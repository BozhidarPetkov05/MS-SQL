USE SoftUni
--P01. Find Names of All Employees by First Name
SELECT FirstName, LastName
FROM Employees
WHERE LEFT(FirstName, 2) = 'SA'

--P02. Find Names of All Employees by Last Name
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

--P03. Find First Names of All Employees
SELECT FirstName 
FROM Employees
WHERE DepartmentID IN (3, 10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--P04. Find All Employees Except Engineers
SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--P05. Find Towns with Name Length
SELECT [Name] 
FROM Towns
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name] ASC

--P06. Find Towns Starting With
SELECT TownID, [Name] 
FROM Towns
WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name] ASC

--P07. Find Towns Not Starting With
SELECT TownID, [Name] 
FROM Towns
WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name] ASC

--P08. Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName 
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

--P09. Length of Last Name
SELECT FirstName, LastName 
FROM Employees
WHERE LEN(LastName) = 5

--P10. Rank Employees by Salary
SELECT EmployeeID, FirstName, LastName, Salary, 
DENSE_RANK() OVER
(PARTITION BY Salary ORDER BY EmployeeID) AS Rank
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--P11. Find All Employees with Rank 2
WITH CTE_RankedEmployees AS
(
	SELECT EmployeeID, FirstName, LastName, Salary, 
	DENSE_RANK() OVER
	(PARTITION BY Salary ORDER BY EmployeeID) AS Rank
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000
)
SELECT * 
FROM CTE_RankedEmployees
WHERE [Rank] = 2
ORDER BY Salary DESC

USE Geography
--P12. Countries Holding 'A' 3 or More Times
SELECT CountryName, IsoCode
FROM Countries
WHERE CountryName LIKE '%a%a%a%' 
ORDER BY IsoCode ASC

--P13. Mix of Peak and River Names
SELECT PeakName, RiverName,
LOWER(CONCAT(SUBSTRING(PeakName, 1, LEN(PeakName)-1), RiverName)) AS Mix
FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

Use Diablo
--P14. Games From 2011 and 2012 Year
SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE DATEPART(YEAR, [Start]) BETWEEN 2011 AND 2012
ORDER BY [Start] ASC,
		 [Name] ASC

--P15. User Email Providers
SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailProvider
FROM Users
ORDER BY EmailProvider ASC, 
		 Username

--P16. Get Users with IP Address Like Pattern
SELECT Username, IpAddress 
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--P17. Show All Games with Duration & Part of the Day
SELECT [Name], [Part of the Day] = 
CASE
	WHEN DATEPART(hour, [Start]) < 12 THEN 'Morning'
	WHEN DATEPART(hour, [Start]) >= 12 AND DATEPART(hour, [Start]) < 18 THEN 'Afternoon'
	WHEN DATEPART(hour, [Start]) >= 18 AND DATEPART(hour, [Start]) < 24 THEN 'Evening'
END,
Duration = 
CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration > 3 AND Duration <= 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'
END
FROM Games
ORDER BY [Name] ASC,
		 Duration ASC,
		 [Part of the Day] ASC

USE Orders
--P18. Orders Table
SELECT ProductName, OrderDate, 
    DATEADD(DAY, 3, OrderDate) AS [Pay Due],
    DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
    FROM Orders

