USE Bank

--P01. Create Table Logs
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT,
	OldSum DECIMAL(10, 4),
	NewSum DECIMAL(10, 4),
)

CREATE OR ALTER TRIGGER tr_LogAccountChange
ON Accounts
FOR UPDATE
AS
	INSERT INTO Logs(AccountId, NewSum, OldSum)
	SELECT i.Id, i.Balance, d.Balance FROM inserted AS i
	JOIN deleted AS d ON i.Id = d.Id
	WHERE i.Balance <> d.Balance
GO

--Test
UPDATE Accounts 
SET Balance = Balance - 1000 WHERE Id = 8 

SELECT * FROM Logs

--P02. Create Table Emails
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY,
	Recipient INT NOT NULL,
	[Subject] NVARCHAR(MAX) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL
)

CREATE OR ALTER TRIGGER tr_EmailNotification
ON Logs
FOR INSERT
AS
	INSERT INTO NotificationEmails (Recipient, [Subject], Body)
	SELECT  
		i.AccountId,
		CONCAT_WS(' ', 'Balance change for account:', i.AccountId),
		CONCAT_WS(' ', 'On', GETDATE(), 'your balance was changed from', i.OldSum, 'to', i.NewSum)
	FROM inserted AS i
GO

--Test
UPDATE Accounts
SET Balance = Balance - 1000 WHERE Id = 10 

SELECT * FROM NotificationEmails

--P03. Deposit Money
CREATE OR ALTER PROCEDURE usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(18, 4))
AS
BEGIN
	IF @MoneyAmount > 0
	BEGIN
		UPDATE Accounts
		SET Balance = Balance + @MoneyAmount WHERE Id = @AccountId
	END
END

--Test
EXEC usp_DepositMoney 1, 10
SELECT * FROM Logs
SELECT * FROM NotificationEmails