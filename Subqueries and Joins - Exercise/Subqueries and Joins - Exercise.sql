USE Softuni

--P01. Employee Address
SELECT TOP(5) EmployeeID, JobTitle, a.AddressID, a.AddressText 
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY AddressID ASC

--P02. Addresses with Towns
SELECT TOP(50) FirstName, LastName, t.[Name] AS Town, a.AddressText 
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY FirstName, LastName

--P03. Sales Employees
SELECT EmployeeID, FirstName, LastName, d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY EmployeeID 

--P04. Employee Departments
SELECT TOP(5) EmployeeID, FirstName, Salary, d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE Salary > 15000
ORDER BY d.DepartmentID

--P05. Employees Without Projects
SELECT TOP(3) e.EmployeeID, FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY EmployeeID

--P06. Employees Hired After
SELECT FirstName, LastName, HireDate, d.[Name] AS DeptName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE (d.[Name] = 'Sales' OR d.[Name] = 'Finance') 
AND HireDate > '1999-01-01'
ORDER BY HireDate

--P07. Employees With Project
SELECT TOP(5) e.EmployeeID, FirstName, p.[Name] AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13' AND EndDate IS NULL
ORDER BY EmployeeID

--P08. Employee 24
SELECT ep.EmployeeID, e.FirstName, [ProjectName] = 
CASE
	WHEN DATEPART(YEAR, StartDate) > 2004 THEN NULL
	ELSE [Name]
END
FROM EmployeesProjects AS ep
JOIN Employees AS e ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--P09. Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS ManagerName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID = 3 OR e.ManagerID = 7
ORDER BY e.EmployeeID

--P10. Employees Summary
SELECT TOP(50) e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName, 
			   CONCAT_WS(' ',m.FirstName, m.LastName) AS ManagerName,
			   d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--P11. Min Average Salary
SELECT MIN(dt.AvgSalary) AS MinAvgSalary
FROM
(SELECT AVG(Salary) AS AvgSalary 
FROM Employees
GROUP BY DepartmentID) AS dt

USE Geography

--P12. Highest Peaks in Bulgaria
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON m.Id = mc.MountainId
JOIN Peaks AS p ON m.Id = p.MountainId
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--P13. Count Mountain Ranges
SELECT CountryCode, COUNT(m.MountainRange)
FROM MountainsCountries AS mc
JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE mc.CountryCode IN ('BG', 'RU', 'US')
GROUP BY mc.CountryCode

--P14. Countries With or Without Rivers
SELECT TOP(5) c.CountryName, r.RiverName FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--P15. Continents and Currencies
SELECT rankedCurrencies.ContinentCode, rankedCurrencies.CurrencyCode, rankedCurrencies.Count
FROM (
SELECT c.ContinentCode, c.CurrencyCode, COUNT(c.CurrencyCode) AS [Count], DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
FROM Countries AS c
GROUP BY c.ContinentCode, c.CurrencyCode) AS rankedCurrencies
WHERE rankedCurrencies.rank = 1 and rankedCurrencies.Count > 1

--P16. Countries Without any Mountains
SELECT COUNT(c.ContinentCode) AS [Count] FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE m.MountainRange IS NULL

--P17. Highest Peak and Longest River by Country
SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.[Length]) AS LongestRiverLength FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT OUTER JOIN Peaks AS p ON p.MountainId = mc.MountainId
LEFT OUTER JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT OUTER JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName

--P18. Highest Peak Name and Elevation by Country
SELECT TOP (5) WITH TIES c.CountryName, ISNULL(p.PeakName, '(no highest peak)') AS 'HighestPeakName', ISNULL(MAX(p.Elevation), 0) AS 'HighestPeakElevation', ISNULL(m.MountainRange, '(no mountain)')
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId
GROUP BY c.CountryName, p.PeakName, m.MountainRange
ORDER BY c.CountryName, p.PeakName


