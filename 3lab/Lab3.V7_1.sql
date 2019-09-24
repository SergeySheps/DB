USE AdventureWorks2012;
GO

-- 1
ALTER TABLE Sergey_Shepelevich.dbo.PersonPhone
	ADD City NVARCHAR(30);
GO

-- 2
DECLARE @PersonPhoneVariable TABLE
(
    BusinessEntityID INT NOT NULL,
    PhoneNumber Phone NOT NULL,
    PhoneNumberTypeID BIGINT NULL,
    ModifiedDate DATETIME,
    PostalCode NVARCHAR(15) DEFAULT ('0'),
    City NVARCHAR(30)
);

INSERT INTO
    @PersonPhoneVariable
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        PostalCode,
        City
    )
SELECT
    Sergey_Shepelevich.dbo.PersonPhone.BusinessEntityID,
    Sergey_Shepelevich.dbo.PersonPhone.PhoneNumber,
    Sergey_Shepelevich.dbo.PersonPhone.PhoneNumberTypeID,
    Sergey_Shepelevich.dbo.PersonPhone.ModifiedDate,
    IIF (Person.Address.PostalCode LIKE '[a-zA-Z]', '0', Person.Address.PostalCode ),
    Person.Address.City
FROM
	Sergey_Shepelevich.dbo.PersonPhone
    LEFT JOIN Person.BusinessEntityAddress
        ON (Sergey_Shepelevich.dbo.PersonPhone.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID)
    LEFT JOIN Person.Address
        ON (Person.BusinessEntityAddress.AddressID = Person.Address.AddressID);

-- 3
UPDATE
    Sergey_Shepelevich.dbo.PersonPhone
SET
    Sergey_Shepelevich.dbo.PersonPhone.PostalCode = PersonPhoneVariable.PostalCode,
    Sergey_Shepelevich.dbo.PersonPhone.City = PersonPhoneVariable.City,
    Sergey_Shepelevich.dbo.PersonPhone.PhoneNumber= 
		CASE CHARINDEX('1 (11)', PersonPhoneVariable.PhoneNumber)
			WHEN 0 THEN '1 (11) ' + PersonPhoneVariable.PhoneNumber
			ELSE PersonPhoneVariable.PhoneNumber
		END
FROM
    Sergey_Shepelevich.dbo.PersonPhone
    JOIN @PersonPhoneVariable AS PersonPhoneVariable
        ON (Sergey_Shepelevich.dbo.PersonPhone.BusinessEntityID = PersonPhoneVariable.BusinessEntityID);
GO

-- 4
DELETE
    phoneTable
FROM
    Sergey_Shepelevich.dbo.PersonPhone AS phoneTable
    JOIN Person.Person
        ON (phoneTable.BusinessEntityID = Person.Person.BusinessEntityID)
WHERE
    PersonType = 'EM';
GO

-- 5
ALTER TABLE Sergey_Shepelevich.dbo.PersonPhone
DROP COLUMN City;
ALTER TABLE Sergey_Shepelevich.dbo.PersonPhone
DROP CONSTRAINT
    PK_PersonPhone,
    DF_PostalCode,
    CK_Postal_code;
GO

-- 6
DROP TABLE
    Sergey_Shepelevich.dbo.PersonPhone;
GO