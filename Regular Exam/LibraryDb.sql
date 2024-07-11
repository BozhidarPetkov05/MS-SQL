CREATE DATABASE LibraryDb
USE LibraryDb

--P01. DDL
CREATE TABLE Genres
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Contacts
(
	Id INT PRIMARY KEY IDENTITY,
	Email NVARCHAR(100),
	PhoneNumber NVARCHAR(20),
	PostAddress NVARCHAR(200),
	Website NVARCHAR(50)
)

CREATE TABLE Libraries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	ContactId INT NOT NULL,
	FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	ContactId INT NOT NULL,
	FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(100) NOT NULL,
	YearPublished INT NOT NULL,
	ISBN NVARCHAR(13) UNIQUE NOT NULL,
	AuthorId INT NOT NULL,
		FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
	GenreId INT NOT NULL,
		FOREIGN KEY (GenreId) REFERENCES Genres(Id)
)

CREATE TABLE LibrariesBooks
(
	LibraryId INT NOT NULL,
	BookId INT NOT NULL,
	PRIMARY KEY(LibraryId, BookId),
	FOREIGN KEY (LibraryId) REFERENCES Libraries(Id),
	FOREIGN KEY (BookId) REFERENCES Books(Id)
)

--P02. Insert
INSERT INTO Contacts(Email, PhoneNumber, PostAddress, Website)
VALUES
	(NULL, NULL, NULL, NULL),
	(NULL, NULL, NULL, NULL),
	('stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
	('suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com')

INSERT INTO Authors([Name], ContactId)
VALUES
	('George Orwell', 21),
	('Aldous Huxley', 22),
	('Stephen King', 23),
	('Suzanne Collins', 24)

INSERT INTO Books(Title, YearPublished, ISBN, AuthorId, GenreId)
VALUES
	('1984', 1949, '9780451524935', 16, 2),
	('Animal Farm', 1945, '9780451526342', 16, 2),
	('Brave New World', 1932, '9780060850524', 17, 2),
	('The Doors of Perception', 1954, '9780060850531', 17, 2),
	('The Shining', 1977, '9780307743657', 18, 9),
	('It', 1986, '9781501142970', 18, 9),
	('The Hunger Games', 2008, '9780439023481', 19, 7),
	('Catching Fire', 2009, '9780439023498', 19, 7),
	('Mockingjay', 2010, '9780439023511', 19, 7)

INSERT INTO LibrariesBooks(LibraryId, BookId)
VALUES
	(1, 36),
	(1, 37),
	(2, 38),
	(2, 39),
	(3, 40),
	(3, 41),
	(4, 42),
	(4, 43),
	(5, 44)

--P03. Update
UPDATE Contacts
SET Website = CONCAT('www.', 'janeausten', '.com')
WHERE Website IS NULL AND Id = 9
UPDATE Contacts
SET Website = CONCAT('www.', 'marktwain', '.com')
WHERE Website IS NULL AND Id = 10
UPDATE Contacts
SET Website = CONCAT('www.', 'charlesdickens', '.com')
WHERE Website IS NULL AND Id = 11
UPDATE Contacts
SET Website = CONCAT('www.', 'leotolstoy', '.com')
WHERE Website IS NULL AND Id = 12
UPDATE Contacts
SET Website = CONCAT('www.', 'hermanmelville', '.com')
WHERE Website IS NULL AND Id = 13
UPDATE Contacts
SET Website = CONCAT('www.', 'victorhugo', '.com')
WHERE Website IS NULL AND Id = 14
UPDATE Contacts
SET Website = CONCAT('www.', 'fyodordostoevsky', '.com')
WHERE Website IS NULL AND Id = 15
UPDATE Contacts
SET Website = CONCAT('www.', 'georgeorwell', '.com')
WHERE Website IS NULL AND Id = 21
UPDATE Contacts
SET Website = CONCAT('www.', 'aldoushuxley', '.com')
WHERE Website IS NULL AND Id = 22

--P04. Delete
DELETE FROM LibrariesBooks
WHERE BookId = 1

DELETE FROM Books
WHERE AuthorId = (SELECT Id FROM Authors WHERE [Name] = 'Alex Michaelides' )

DELETE FROM Authors
WHERE [Name] = 'Alex Michaelides' 

--P05. Chronological Order
SELECT Title AS 'Book Title', ISBN, YearPublished AS YearReleased 
FROM Books
ORDER BY
	YearPublished DESC,
	Title ASC

--P06. Books by Genre
SELECT b.Id, b.Title, b.ISBN, g.[Name] AS Genre
FROM Books AS b
JOIN Genres AS g ON b.GenreId = g.Id
WHERE g.[Name] = 'Biography' OR g.[Name] = 'Historical Fiction'
ORDER BY 
	g.[Name] ASC,
	b.Title ASC

--P07. Missing Genre
SELECT l.[Name] AS [Library], c.Email
FROM Libraries AS l
JOIN Contacts AS c ON l.ContactId = c.Id
WHERE NOT EXISTS (
    SELECT 1
    FROM LibrariesBooks AS lb
    JOIN Books AS b ON lb.BookId = b.Id
    JOIN Genres AS g ON b.GenreId = g.Id
    WHERE lb.LibraryId = l.Id AND g.[Name] = 'Mystery'
)
GROUP BY l.[Name], c.Email
ORDER BY l.[Name] ASC

--P08. First 3 Books
SELECT TOP(3) b.Title, b.YearPublished AS [Year], g.[Name] AS Genre
FROM Books AS b
JOIN Genres AS g ON b.GenreId = g.Id
WHERE (YearPublished > 2000 AND Title LIKE '%a%')
OR (YearPublished < 1950 AND g.[Name] LIKE '%Fantasy%')
ORDER BY
	b.Title ASC,
	b.YearPublished DESC

--P09. Authors from UK
SELECT a.[Name] AS Author, c.Email, c.PostAddress AS [Address]
FROM Authors AS a
JOIN Contacts AS c ON a.ContactId = c.Id
WHERE PostAddress LIKE '%UK%'
ORDER BY
	a.[Name] ASC

--P10. Fictions in Denver
SELECT a.[Name] AS Author, b.Title, l.[Name] AS [Library], c.PostAddress AS 'Library Address'
FROM Books AS b
JOIN Genres AS g ON g.Id = b.GenreId
JOIN LibrariesBooks AS lb ON b.Id = lb.BookId
JOIN Libraries AS l ON l.Id = lb.LibraryId
JOIN Contacts AS c ON c.Id = l.ContactId
JOIN Authors AS a On b.AuthorId = a.Id
WHERE g.[Name] = 'Fiction' AND c.PostAddress LIKE '%Denver%'
ORDER BY
	b.Title ASC

--P11. Authors with Books
CREATE FUNCTION udf_AuthorsWithBooks(@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
RETURN
(
	SELECT COUNT(*)
	FROM Authors AS a
	JOIN Books AS b ON a.Id = b.AuthorId
	WHERE a.[Name] = @name
)
END

--P12. Search by Genre
CREATE PROCEDURE usp_SearchByGenre(@genreName NVARCHAR(30))
AS 
BEGIN
	SELECT b.Title, b.YearPublished AS [Year], b.ISBN, a.[Name] AS Author, g.[Name] AS Genre
	FROM Books AS b
	JOIN Genres AS g ON b.GenreId = g.Id
	JOIN Authors AS a ON b.AuthorId = a.Id
	WHERE g.[Name] = @genreName
	ORDER BY
		b.Title ASC
END