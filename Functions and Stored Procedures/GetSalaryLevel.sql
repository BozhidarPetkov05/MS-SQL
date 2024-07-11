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