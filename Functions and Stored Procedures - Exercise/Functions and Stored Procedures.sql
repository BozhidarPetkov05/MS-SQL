USE SoftUni

--P01. Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary > 35000
END

--Test
EXEC usp_GetEmployeesSalaryAbove35000

--P02. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @salary DECIMAL(18, 4)
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @salary
END

--Test
EXEC usp_GetEmployeesSalaryAboveNumber 50000

--P03. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith @letter VARCHAR(MAX)
AS
BEGIN
	SELECT [Name] AS Town
	FROM Towns
	WHERE [Name] LIKE CONCAT(@letter, '%')
END

--Test
EXEC usp_GetTownsStartingWith 'b'

--P04. Employees from Town
CREATE PROC usp_GetEmployeesFromTown @townName VARCHAR(MAX)
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID
	JOIN Towns AS t ON t.TownID = a.TownID
	WHERE t.[Name] = @townName
END

--Test
EXEC usp_GetEmployeesFromTown 'Sofia'

--P05. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @result NVARCHAR(10)
	IF(@Salary < 30000)
	BEGIN
		SET @result = 'Low'
	END
	ELSE IF(@Salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @result = 'Average'
	END
	ELSE
	BEGIN
		SET @result = 'High'
	END
	RETURN @result
END

--P06. Employees by Salary Level
CREATE PROCEDURE usp_EmployeesBySalaryLevel @level VARCHAR(MAX)
AS
BEGIN
	IF(@level = 'Low')
	BEGIN
		SELECT FirstName, LastName
		FROM Employees
		WHERE dbo.ufn_GetSalaryLevel(Salary) = 'Low'
	END
	ELSE IF(@level = 'Average')
	BEGIN
		SELECT FirstName, LastName
		FROM Employees
		WHERE dbo.ufn_GetSalaryLevel(Salary) = 'Average'
	END
	ELSE IF(@level = 'High')
	BEGIN
		SELECT FirstName, LastName
		FROM Employees
		WHERE dbo.ufn_GetSalaryLevel(Salary) = 'High'
	END
END

--Test
EXEC usp_EmployeesBySalaryLevel 'High'

--P07. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	DECLARE @WordLength INT = LEN(@word)
	DECLARE @Iterator INT = 1
	
	WHILE(@Iterator <= @WordLength)
	BEGIN
		IF(CHARINDEX(SUBSTRING(@word, @Iterator, 1), @setOfLetters) = 0)
			RETURN 0
		SET @Iterator += 1
	END
	RETURN 1 
END

--P08. Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

USE Bank
--P09. Find Full Name
CREATE PROC usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT_WS(' ', FirstName, LastName) AS [Full Name]
	FROM AccountHolders
END

--Test
EXEC usp_GetHoldersFullName

--P10. People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan @number DECIMAL(18, 4)
AS
BEGIN
	SELECT FirstName, LastName
	FROM AccountHolders AS ah
	JOIN Accounts AS a ON ah.Id = a.AccountHolderId
	GROUP BY a.AccountHolderId, FirstName, LastName
	HAVING SUM(Balance) > @number
	ORDER BY FirstName, LastName
END

--Test
EXEC usp_GetHoldersWithBalanceHigherThan 50000

--P11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN
	RETURN @sum * (POWER((1 + @yearlyInterestRate), @numberOfYears))
END

--P12. Calculating Interest
CREATE PROC	usp_CalculateFutureValueForAccount(@accountId INT, @interestRate FLOAT)
AS
BEGIN
	DECLARE @term INT = 5
	SELECT a.Id, FirstName, LastName, Balance AS [Current Balance],
	dbo.ufn_CalculateFutureValue(Balance, @interestRate, @term) AS [Balance in 5 years]
	FROM AccountHolders AS ah
	JOIN Accounts AS a ON a.AccountHolderId = ah.Id
	WHERE a.Id = @accountId
END

--Test
EXEC usp_CalculateFutureValueForAccount 1, 0.1

USE Diablo
--P13. Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@gameName varchar(max))
RETURNS @returnedTable TABLE
(
SumCash money
)
AS
BEGIN
	DECLARE @result money

	SET @result = 
	(SELECT SUM(ug.Cash) AS Cash
	FROM
		(SELECT Cash, GameId, ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
		FROM UsersGames
		WHERE GameId = (SELECT Id FROM Games WHERE Name = @gameName)
		) AS ug
	WHERE ug.RowNumber % 2 != 0
	)

	INSERT INTO @returnedTable SELECT @result
	RETURN
END
