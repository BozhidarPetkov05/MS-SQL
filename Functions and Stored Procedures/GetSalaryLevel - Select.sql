SELECT 
	FirstName,
	LastName,
	Salary,
	dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees