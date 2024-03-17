DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Showtime;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Theater;
DROP TABLE IF EXISTS Cinema;
 
CREATE TABLE Cinema (
CinemaID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Address VARCHAR(255) NOT NULL,
Phone VARCHAR(20)
);
CREATE TABLE Theater (
TheaterID INT PRIMARY KEY,
CinemaID INT,
Name VARCHAR(50) NOT NULL,
Capacity INT NOT NULL,
ScreenType VARCHAR(50),
FOREIGN KEY (CinemaID) REFERENCES Cinema(CinemaID)
);
CREATE TABLE Movie (
MovieID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
Director VARCHAR(100),
ReleaseDate DATE,
DurationMinutes INT,
Rating VARCHAR(5)
);
CREATE TABLE Showtime (
ShowtimeID INT PRIMARY KEY,
MovieID INT,
TheaterID INT,
ShowDateTime DATETIME NOT NULL,
Price DECIMAL(5,2) NOT NULL,
FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID)
);
CREATE TABLE Customer (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100),
PhoneNumber VARCHAR(20)
);
CREATE TABLE Ticket (
TicketID INT PRIMARY KEY,
ShowtimeID INT,
SeatNumber VARCHAR(10) NOT NULL,
PurchasedDateTime DATETIME NOT NULL,
CustomerID INT,
FOREIGN KEY (ShowtimeID) REFERENCES Showtime(ShowtimeID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE Review (
ReviewID INT PRIMARY KEY,
MovieID INT,
CustomerID INT,
ReviewText TEXT,
Rating INT CHECK (Rating >= 1 AND Rating <= 5),
ReviewDate DATETIME NOT NULL,
FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE Employee (
EmployeeID INT PRIMARY KEY,
CinemaID INT,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Position VARCHAR(50),
HireDate DATE,
FOREIGN KEY (CinemaID) REFERENCES Cinema(CinemaID)
);
 
INSERT INTO Cinema (CinemaID, Name, Address, Phone)
VALUES
(1, 'Cinema Paradiso', 'Via Roma 123', '06 1234567'),
(2, 'Cinema inferno', 'Via Napoli 222', '+ 06 8574635');
INSERT INTO Theater (TheaterID, CinemaID, Name, Capacity, ScreenType)
VALUES
(1, 1, 'Sala 1', 100, '2D'),
(2, 1, 'Sala 2', 80, '3D'),
(3, 2, 'Sala 3', 150, 'IMAX'),
(4, 2, 'Sala 4', 120, '2D');
INSERT INTO Movie (MovieID, Title, Director, ReleaseDate, DurationMinutes, Rating)
VALUES
(1, 'The Shawshank Redemption', 'Frank Darabont', '1994-09-23', 142, '4'),
(2, 'Inception', 'Christopher Nolan', '2010-07-16', 148, '4'),
(3, 'Pulp Fiction', 'Quentin Tarantino', '1994-10-14', 154, '5');
INSERT INTO Showtime (ShowtimeID, MovieID, TheaterID, ShowDateTime, Price)
VALUES
(1, 1, 1, '2024-03-2 18:00:00', 10.00),
(2, 2, 3, '2024-03-2 20:00:00', 12.50),
(3, 3, 2, '2024-03-2 19:30:00', 11.00);
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, PhoneNumber)
VALUES
(1, 'Mario', 'Rossi', 'mrossi@example.com', '3334657889'),
(2, 'Valerio', 'Bianchi', 'valbianch@example.com', '336970699'),
(3, 'Pippo', 'Franco', 'valbianch@example.com', '336970699');
INSERT INTO Ticket (TicketID, ShowtimeID, SeatNumber, PurchasedDateTime, CustomerID)
VALUES
(1, 1, 'A1', '2024-03-01 15:30:00', 1),
(2, 2, 'B5', '2024-03-01 10:45:00', 2),
(3, 2, 'B7', '2024-03-01 10:46:00', 3),
(4, 3, 'B7', '2024-03-01 10:46:00', 3);
INSERT INTO Review (ReviewID, MovieID, CustomerID, ReviewText, Rating, ReviewDate)
VALUES
(1, 1, 1, 'Bellissimo film,uno dei migliori!', 5, '2024-03-01 09:15:00'),
(2, 2, 2, 'Film dell''anno.', 4, '2024-03-01 22:30:00');
INSERT INTO Employee (EmployeeID, CinemaID, FirstName, LastName, Position, HireDate)
VALUES
(1, 1, 'Franco', 'Rossi', 'Manager', '2020-01-15'),
(2, 2, 'Luca', 'Gialli', 'Cassiere', '2022-03-01');
CREATE VIEW FilmsInProgrammation AS
	SELECT Movie.Title, ShowDateTime,Price,Rating FROM Movie
	JOIN Showtime ON Movie.MovieID = Showtime.MovieID

CREATE VIEW AvaibleSeatsForShow AS 
	SELECT s.ShowtimeID,s.MovieID,s.Price,t.Capacity AS TotalSeats, 
	t.Capacity - COUNT(tk.TicketID) AS AvaibleSeats
	FROM Showtime s 
	JOIN Theater t ON s.TheaterID = t.TheaterID
	LEFT JOIN Ticket tk ON s.ShowtimeID = tk.ShowtimeID 
	GROUP BY s.ShowtimeID,s.MovieID,s.TheaterID,s.ShowDateTime,s.Price,t.Capacity

CREATE VIEW TotalEarningsPerMovie AS
	SELECT Title ,SUM(Price) AS 'Totale Generato' 
		FROM Movie
		JOIN ShowTime ON Movie.movieID = ShowTime.MovieID
		JOIN Ticket ON ShowTime.ShowTimeID = Ticket.ShowTimeID
	GROUP BY Title

CREATE VIEW RecentReviews AS 
	SELECT Movie.Title,Review.Rating, Review.ReviewText, Review.ReviewDate 
	FROM Movie
	JOIN Review ON Movie.MovieID = Review.MovieID;

SELECT * FROM RecentReviews
	ORDER BY ReviewDate DESC

CREATE PROCEDURE PurchaseTicket
    @TicketID INT,
    @ShowTimeID INT,
    @SeatNumber VARCHAR(10),
    @CustomerID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

		 DECLARE @RowCount INT;
			SELECT @RowCount = COUNT(*) FROM Ticket WHERE SeatNumber = @SeatNumber;

        IF @RowCount = 0
			BEGIN
				INSERT INTO Ticket (TicketID, ShowtimeID, SeatNumber, PurchasedDateTime, CustomerID)
				VALUES (@TicketID, @ShowTimeID, @SeatNumber, CURRENT_TIMESTAMP, @CustomerID);
            
				PRINT 'Biglietto comprato';
			END
        ELSE
			BEGIN
				PRINT 'Il posto selezionato è già occupato.';
			END

        COMMIT TRANSACTION;
    END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			PRINT 'Si è verificato un errore durante l''acquisto del biglietto: ' + ERROR_MESSAGE();
		END CATCH
END;


EXEC PurchaseTicket @TicketID=5,@ShowTimeID=3,@SeatNumber='B6',@CustomerID=3
SELECT * FROM Ticket

CREATE PROCEDURE UpdateMovieSchedule
    @MovieID INT,
    @ShowDateTime DATETIME = NULL,
    @DeleteShowtime BIT = 0
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @DeleteShowtime = 1
        BEGIN
            DELETE FROM Ticket
            WHERE ShowtimeID IN (SELECT ShowtimeID FROM Showtime WHERE MovieID = @MovieID);

            DELETE FROM Showtime WHERE MovieID = @MovieID;
            PRINT 'Gli spettacoli del film sono stati eliminati dall''agenda.';
        END
        ELSE
        BEGIN
            IF @ShowDateTime IS NOT NULL
            BEGIN
                UPDATE Showtime
                SET ShowDateTime = @ShowDateTime
                WHERE MovieID = @MovieID;
                PRINT 'Gli orari degli spettacoli del film sono stati aggiornati.';
            END
            ELSE
            BEGIN
                PRINT 'Nessuna modifica agli orari degli spettacoli è stata effettuata.';
            END
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Si è verificato un errore durante l''aggiornamento degli orari degli spettacoli: ' + ERROR_MESSAGE();
    END CATCH
END;


EXEC UpdateMovieSchedule @DeleteShowTime=1,@MovieID=1,@ShowDateTime='2024-03-03 18:30:00'


SELECT * FROM Showtime

CREATE PROCEDURE InsertNewMovie 
    @MovieID INT,
    @Title VARCHAR(255),
    @Director VARCHAR(100),
    @ReleaseDate DATE = NULL,
    @DurationMinutes INT,
    @Rating VARCHAR(5)
AS
BEGIN 
    DECLARE @DefaultReleaseDate VARCHAR(255) = 'Il film deve essere ancora rilasciato';

    BEGIN TRY
        BEGIN TRANSACTION;

			IF @MovieID IS NULL
				THROW 50001,'Inserisci un MovieID',1;
			IF @Title IS NULL
				THROW 50002,'Inserisci un Titolo',1;
			IF @Director IS NULL
				THROW 50003,'Inserisci un Director',1;
			IF @ReleaseDate IS NULL
				SET @ReleaseDate = @DefaultReleaseDate;
				INSERT INTO Movie (MovieID, Title, Director, ReleaseDate, DurationMinutes, Rating)
				VALUES (@MovieID, @Title, @Director, @ReleaseDate, @DurationMinutes, @Rating);

				PRINT 'Nuovo film inserito con successo.';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Si è verificato un errore durante l''inserimento del nuovo film: ' + ERROR_MESSAGE();
    END CATCH
END;


EXEC InsertNewMovie @MovieID =7,@Title='Pippo',@Director='Pippo',@ReleaseDate=NUll,@DurationMinutes=140,@Rating=5
SELECT * FROM Movie
