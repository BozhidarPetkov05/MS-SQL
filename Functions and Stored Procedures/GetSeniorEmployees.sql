CREATE OR ALTER PROCEDURE usp_GetSeniorEmployees
AS
SELECT
	FirstName,
	LastName,
	HireDate,
	DATEDIFF(Year, HireDate, GETDATE()) AS Years
FROM Employees
WHERE DATEDIFF(Year, HireDate, GETDATE()) > 20