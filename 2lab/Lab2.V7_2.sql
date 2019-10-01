USE Sergey_Shepelevich;
GO

IF EXISTS (
	SELECT * FROM sys.types st
	WHERE st.name = N'Phone' )
	BEGIN
		DROP TYPE Phone
	END;
GO

CREATE TYPE Phone FROM NVARCHAR(25) NOT NULL
GO

--a
CREATE TABLE PersonPhone (
	BusinessEntityID INT NOT NULL,
	PhoneNumber Phone NOT NULL,
	PhoneNumberTypeID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL
);
GO

--b
ALTER TABLE PersonPhone
	ADD CONSTRAINT PK_PersonPhone PRIMARY KEY (BusinessEntityID, PhoneNumber);
GO

--c
ALTER TABLE PersonPhone
	ADD PostalCode NVARCHAR(15) CONSTRAINT CK_Postal_code CHECK(PostalCode LIKE '[^a-zA-Z]' );
GO

--d
ALTER TABLE PersonPhone
	ADD CONSTRAINT DF_PostalCode DEFAULT 0 FOR PostalCode;
GO

--e
INSERT INTO PersonPhone (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate
)
SELECT 
		a.BusinessEntityID,
		a.PhoneNumber,
		a.PhoneNumberTypeID,
		a.ModifiedDate
	FROM AdventureWorks2012.Person.PersonPhone AS a
	INNER JOIN AdventureWorks2012.Person.PhoneNumberType AS b
	ON a.PhoneNumberTypeID = b.PhoneNumberTypeID
	WHERE b.Name = 'Cell'
GO

--f
ALTER TABLE PersonPhone
	ALTER COLUMN PhoneNumberTypeID BIGINT NULL;
GO