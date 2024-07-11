--P02. Find All the Information About Departments
SELECT * FROM Departments

--P03. Find all Department Names
SELECT [Name] FROM Departments

--P04. Find Salary of Each Employee
SELECT FirstName, LastName, Salary FROM Employees

--P05. Find Full Name of Each Employee
SELECT FirstName, MiddleName, LastName FROM Employees

--P06. Find Email Address of Each Employee
SELECT CONCAT(FirstName, '.', LastName, '@softuni.bg') AS 'Full Email Address'
FROM Employees

--P07. Find All Different Employee’s Salaries
SELECT DISTINCT Salary FROM Employees

--P08. Find all Information About Employees
SELECT * FROM Employees 
WHERE JobTitle = 'Sales Representative'

--P09. Find Names of All Employees by Salary in Range
SELECT FirstName, LastName, JobTitle FROM Employees 
WHERE Salary BETWEEN 20000 AND 30000

--P10. Find Names of All Employees
SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) 
AS 'Full Name' FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

--P11. Find All Employees Without a Manager
SELECT FirstName, LastName FROM Employees
WHERE ManagerID IS NULL

--P12. Find All Employees with Salary More Than
SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

--P13. Find 5 Best Paid Employees
SELECT TOP(5) FirstName, LastName FROM Employees
ORDER BY Salary DESC

--P14. Find All Employees Except Marketing
SELECT FirstName, LastName FROM Employees
WHERE DepartmentID <> 4

--P15. Sort Employees Table
SELECT * FROM Employees
ORDER BY Salary DESC,
FirstName ASC,
LastName DESC,
MiddleName ASC

--P16. Create View Employees with Salaries
CREATE VIEW V_EmployeesSalaries AS 
(
	SELECT FirstName, LastName, Salary FROM Employees
)

--P17. Create View Employees with Job Titles
CREATE VIEW V_EmployeeNameJobTitle AS
(
	SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS 'Full Name', JobTitle 
	FROM Employees
)

--P18. Distinct Job Titles
SELECT DISTINCT JobTitle FROM Employees

--P19. Find First 10 Started Projects
SELECT TOP(10) * FROM Projects
ORDER BY StartDate ASC,
		 [Name] ASC

--P20. Last 7 Hired Employees
SELECT TOP(7) FirstName, LastName, HireDate FROM Employees 
ORDER BY HireDate DESC

--P21. Increase Salaries
UPDATE Employees
SET Salary = Salary + Salary * 0.12
WHERE DepartmentID = 1 OR DepartmentID = 2 OR DepartmentID = 4 OR DepartmentID = 11
SELECT Salary FROM Employees

--P22. All Mountain Peaks
SELECT PeakName FROM Peaks
ORDER BY PeakName ASC

--P23. Biggest Countries by Population
SELECT TOP(30) CountryName, [Population] FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY [Population] DESC,
		 CountryName ASC

--P24. Countries and Currency (Euro / Not Euro)
SELECT CountryName, CountryCode,
CASE 
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
END AS CurrencyCode
FROM Countries
ORDER BY CountryName ASC

--P25. All Diablo Characters
SELECT [Name] FROM Characters
ORDER BY [Name] ASC