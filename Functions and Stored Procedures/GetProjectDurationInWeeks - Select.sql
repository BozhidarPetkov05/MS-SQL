SELECT
	[Name],
	dbo.udf_GetProjectDurationInWeeks(StartDate, EndDate) AS [Duration in Weeks]
	FROM [SoftUni].[dbo].[Projects]