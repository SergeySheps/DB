USE AdventureWorks2012;
GO

-- 1
CREATE TABLE Sales.CurrencyHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action NVARCHAR(20) CHECK(Action IN ('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL,
	SourceID NVARCHAR(30) NOT NULL,
	UserName NVARCHAR(50)
);
GO

--2
CREATE TRIGGER currencyAfterInsert ON Sales.Currency
FOR INSERT
AS
	DECLARE @sourceID NVARCHAR(30);

	SELECT @sourceID = inserted.Name FROM inserted;

	INSERT INTO Sales.CurrencyHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('INSERT', GETDATE(), @sourceID, CURRENT_USER);

	PRINT 'after insert trigger: success';
GO

CREATE TRIGGER currencyAfterUpdate ON Sales.Currency
FOR UPDATE
AS
	DECLARE @sourceID NVARCHAR(30);

	SELECT @sourceID = inserted.Name FROM inserted;

	INSERT INTO Sales.CurrencyHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('UPDATE', GETDATE(), @sourceID, CURRENT_USER);

	PRINT 'after update trigger: success';
GO

CREATE TRIGGER currencyAfterDelete ON Sales.Currency
FOR DELETE
AS
	DECLARE @sourceID NVARCHAR(30);

	SELECT @sourceID = deleted.Name FROM deleted;

	INSERT INTO Sales.CurrencyHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('DELETE', GETDATE(), @sourceID, CURRENT_USER);

	PRINT 'after delete trigger: success';
GO

--3
CREATE VIEW Sales.ViewCurrency 
WITH ENCRYPTION 
AS SELECT * FROM Sales.Currency;

--4
INSERT INTO Sales.Currency(CurrencyCode, ModifiedDate, Name)
	VALUES('TST', GETDATE(), 'Hello!!!')
GO

UPDATE Sales.Currency
	SET ModifiedDate= GETDATE(), Name= 'Hello!!!123'
	WHERE CurrencyCode='TST'
GO

DELETE FROM Sales.Currency
	WHERE CurrencyCode='TST'
GO