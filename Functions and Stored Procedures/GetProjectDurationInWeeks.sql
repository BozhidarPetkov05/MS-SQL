CREATE FUNCTION udf_GetProjectDurationInWeeks(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @duration INT
	IF(@EndDate IS NULL)
	BEGIN
		SET @EndDate = GETDATE()
	END
	SET @duration = DATEDIFF(WEEK, @StartDate, @EndDate)
	RETURN @duration
END
