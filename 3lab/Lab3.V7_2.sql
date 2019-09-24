USE Sergey_Shepelevich;
GO

-- 1
ALTER TABLE dbo.PersonPhone
ADD
    OrdersCount INT,
    CardType NVARCHAR(50),
    IsSuperior AS IIF (CardType = 'SuperiorCard', 1, 0);
GO

-- 2
CREATE TABLE #PersonPhone
(
    BusinessEntityID INT NOT NULL PRIMARY KEY,
    PhoneNumber NVARCHAR(25) NOT NULL,
    PhoneNumberTypeID BIGINT NULL,
    ModifiedDate DATETIME,
    PostalCode NVARCHAR(15) DEFAULT ('0'),
    OrdersCount INT,
    CardType NVARCHAR(50)
);
GO

--3
WITH Orders_CTE (CreditCardID, OrdersCount)
AS
(
    SELECT
        CreditCardID,
        COUNT(*) AS OrdersCount
    FROM
        AdventureWorks2012.Sales.SalesOrderHeader
    GROUP BY
        CreditCardID
)
INSERT INTO #PersonPhone
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        PostalCode,
        OrdersCount,
        CardType
    )
SELECT 
	dbo.PersonPhone.BusinessEntityID,
    dbo.PersonPhone.PhoneNumber,
    dbo.PersonPhone.PhoneNumberTypeID,
    dbo.PersonPhone.ModifiedDate,
    dbo.PersonPhone.PostalCode,
    Orders_CTE.OrdersCount,
    AdventureWorks2012.Sales.CreditCard.CardType
FROM dbo.PersonPhone
JOIN AdventureWorks2012.Sales.PersonCreditCard 
	ON (dbo.PersonPhone.BusinessEntityID = AdventureWorks2012.Sales.PersonCreditCard.BusinessEntityID)
JOIN AdventureWorks2012.Sales.CreditCard
    ON (AdventureWorks2012.Sales.PersonCreditCard.CreditCardID = CreditCard.CreditCardID)
JOIN Orders_CTE
    ON (CreditCard.CreditCardID = Orders_CTE.CreditCardID);

-- 4
DELETE
FROM
    dbo.PersonPhone
WHERE
    BusinessEntityID = 297;

-- 5
MERGE dbo.PersonPhone AS TARGET
USING #PersonPhone AS source
ON (TARGET.BusinessEntityID = source.BusinessEntityID)
WHEN MATCHED THEN
	UPDATE 
	SET OrdersCount = source.OrdersCount, CardType = source.CardType
WHEN NOT MATCHED BY TARGET THEN
	INSERT
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        OrdersCount,
        CardType
    )
    VALUES
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        OrdersCount,
        CardType
    )
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;
GO