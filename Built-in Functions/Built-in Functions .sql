
SELECT CONCAT(FirstName, ' ', LastName) AS 'Full Name' FROM Employees

SELECT SUBSTRING('SoftUni', 5, 3) AS 'Substring Text' --Uni

SELECT REPLACE('SoftUni', 'Soft', 'Hard') AS 'Replaced Text' --HardUni

SELECT LEFT('SoftUni', 4) AS 'Shortened Left' --Soft

SELECT RIGHT('SoftUni', 3) AS 'Shortened Right' --Uni

SELECT LOWER('Lower text') AS 'Lowered' --lower text

SELECT UPPER('Uppered text') AS 'Uppered' --UPPERED TEXT

SELECT REVERSE('Reverse') AS 'Reversed' --esreveR

SELECT FORMAT(GETDATE(), 'dd-MMMM-yyyy', 'en-EN') AS 'Date' --03-June-2024

USE Demo
SELECT CustomerID,
	   FirstName,
	   LastName,
	   LEFT(PaymentNumber, 6) + '**********'
       FROM Customers

USE Demo
SELECT (A*H)/2 AS Area FROM Demo.dbo.Triangles2

SELECT PI() AS 'Pi Value' --3.14...

SELECT ABS(5) AS 'Absolute of Positive'--5
SELECT ABS(-5) AS 'Absolute of Negative' --5

SELECT SQRT(4) AS 'Square Root' --2
SELECT SQUARE(4) AS 'Power of 2' --16

USE Demo
SELECT Id,
	   SQRT(SQUARE(X1-X2)+SQUARE(Y1-Y2))
	   AS Length
	   FROM Lines

SELECT POWER(2, 3) AS 'Power of Given Number' --8

SELECT ROUND(50.325416814, 2) AS 'Rounded Number' --50.330000000

SELECT FLOOR(50.50) AS 'Floored' --50

SELECT CEILING(50.50) AS 'Ceiled' --51

USE Demo
SELECT CEILING(
	  (CEILING(
	  CAST(Quantity AS float) / BoxCapacity) / PalletCapacity)) 
	  AS 'Number of pallets' 
	  FROM Products

SELECT SIGN(50) AS 'Sign of positive' -- 1
SELECT SIGN(-50) AS 'Sign of negative' -- -1
SELECT SIGN(0) AS 'Sign of zero' -- 0

SELECT RAND() AS 'Random Number' --Random Number from 0 to 1
SELECT RAND() * 10 AS 'Random from 0 - 10' --Random Number from 0 to 10
SELECT CAST(RAND() * 10 AS int) AS 'Random int from 0 - 10' --Random Whole Number from 0 to 10

SELECT DATEPART(year ,GETDATE()) AS 'Year' --2024
SELECT DATEPART(month ,GETDATE()) AS 'Month' --6
SELECT DATEPART(day ,GETDATE()) AS 'Day' --3

USE Demo
SELECT InvoiceId, Total,
	DATEPART(QUARTER, InvoiceDate) AS Quarter,
	DATEPART(MONTH, InvoiceDate) AS Month,
	DATEPART(YEAR, InvoiceDate) AS Year,
	DATEPART(DAY, InvoiceDate) AS Day
	FROM Invoices

USE Softuni
SELECT EmployeeID, FirstName, LastName,
	DATEDIFF(YEAR, HireDate, '2017/01/25')
	AS [Years In Service]
	FROM Employees

SELECT EOMONTH(GETDATE()) AS 'Last Day of Month' --31

SELECT CAST(11.925 AS int) --11
SELECT CONVERT(int, 11.925) --11

USE SoftUni
SELECT EmployeeID, FirstName, LastName
 FROM Employees
ORDER BY EmployeeID
 OFFSET (10 * (1 - 1)) ROWS
 FETCH NEXT 10 ROWS ONLY

USE SoftUni
SELECT EmployeeID, FirstName, LastName
 FROM Employees
WHERE FirstName LIKE 'Ro%'

