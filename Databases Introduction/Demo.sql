CREATE TABLE People
(
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50) 
)

SELECT * FROM People
WHERE FirstName = 'Pesho'

INSERT INTO People
	  (Id, FirstName, LastName)
VALUES(2, 'Ivan', 'Ivanov'),
	(3, 'Pesho', 'Peshov'),
	(4, 'Gosho', 'Goshov')

ALTER TABLE People
ADD Email VARCHAR(100)
