USE SoftUni
--Problem: Addresses with Towns
SELECT TOP 50 
  e.FirstName, 
  e.LastName, 
  t.[Name] AS Town, 
  a.AddressText 
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

--Problem: Sales Employees
SELECT e.EmployeeID, 
	   e.FirstName,
	   e.LastName,
	   d.[Name] AS [Department Name]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID 
WHERE e.DepartmentID = 3
ORDER BY e.EmployeeID

--Problem: Employees Hired After
SELECT e.FirstName, 
	   e.LastName, 
	   e.HireDate, 
	   d.[Name] AS Deptname 
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1999-01-01'
AND d.[Name] IN ('Sales', 'Finance')
ORDER BY HireDate

--Problem: Employee Summary
SELECT TOP(50) e.EmployeeID, 
	   CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName,
	   CONCAT_WS(' ', em.FirstName, em.LastName) AS ManagerName,
	   d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
JOIN Employees AS em ON e.ManagerID = em.EmployeeID
ORDER BY EmployeeID

--Problem: Min Average Salary
SELECT MIN(dt.AvgSalary) AS MinAvgSalary
FROM
(SELECT AVG(Salary) AS AvgSalary 
FROM Employees
GROUP BY DepartmentID) AS dt


