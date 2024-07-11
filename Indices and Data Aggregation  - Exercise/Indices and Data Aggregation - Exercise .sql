USE Gringotts

--P01. Records’ Count
SELECT COUNT(Id) AS [Count] 
FROM WizzardDeposits

--P02. Longest Magic Wand
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

--P03. Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

--P04. Smallest Deposit Group Per Magic Wand Size
SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--P05. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

--P06. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--P07. Deposits Filter
SELECT 
	DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE 
	MagicWandCreator = 'Ollivander family'
GROUP BY 
	DepositGroup
HAVING 
	SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

--P08. Deposit Charge
SELECT 
	DepositGroup, MagicWandCreator, MIN(DepositCharge)
FROM WizzardDeposits
GROUP BY 
	DepositGroup, MagicWandCreator
ORDER BY 
	MagicWandCreator, DepositGroup

--P09. Age Groups
SELECT AgeGroup, COUNT(*) AS WizardCount 
FROM
(
	SELECT
		CASE
			WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN Age > 60 THEN '[61+]'
		END AS AgeGroup
	FROM WizzardDeposits 
) AS NestedQuery
GROUP BY AgeGroup

--P10. First Letter
SELECT SUBSTRING(FirstName, 1, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY SUBSTRING(FirstName, 1, 1)

--P11. Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY 
	DepositGroup DESC,
	IsDepositExpired ASC

--P12. Rich Wizard, Poor Wizard
SELECT SUM([Difference]) AS SumDifference FROM
(SELECT FirstName AS 'Host Wizard',
	   DepositAmount AS 'Host Wizard Deposit',
	   LEAD(FirstName) OVER (ORDER BY Id) AS 'Guest Wizard',
	   LEAD(DepositAmount) OVER (ORDER BY Id) AS 'Guest Wizard Deposit',
	   [Difference] = DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id)
FROM WizzardDeposits) AS SubQuery

USE SoftUni
--P13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary 
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--P14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary 
FROM Employees
WHERE HireDate > '2000-01-01'
GROUP BY DepartmentID
HAVING DepartmentID = 2 OR DepartmentID = 5 OR DepartmentID = 7

--P15. Employees Average Salaries
SELECT * INTO RichEmployees
FROM Employees
WHERE Salary > 30000

DELETE 
FROM RichEmployees
WHERE ManagerID = 42

UPDATE RichEmployees 
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM RichEmployees
GROUP BY DepartmentID

--P16. Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--P17. Employees Count Salaries
SELECT COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

--P18. 3rd Highest Salary
SELECT DepartmentId, ThirdHighestSalary
FROM
	(SELECT 
		DepartmentID,
		MAX(Salary) AS ThirdHighestSalary,
		DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRanking
	FROM Employees
	GROUP BY DepartmentID, Salary) AS SubQuery
WHERE SubQuery.SalaryRanking = 3

--P19. Salary Challenge
SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID
FROM Employees AS e
WHERE e.Salary >(SELECT AVG(e2.Salary)
				FROM Employees AS e2
				WHERE e.DepartmentID = e2.DepartmentID)
ORDER BY e.DepartmentID
