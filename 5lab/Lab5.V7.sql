USE AdventureWorks2012;
GO

--1
CREATE FUNCTION Sales.getLatestUSDRate (@currencyCode NCHAR(3))
RETURNS MONEY AS 
BEGIN
	DECLARE @latestUSDRate MONEY

	SELECT TOP 1 @latestUSDRate = EndOfDayRate FROM Sales.CurrencyRate
	WHERE ToCurrencyCode = @currencyCode AND FromCurrencyCode = 'USD'
    ORDER BY CurrencyRateDate DESC

	RETURN @latestUSDRate
END
GO

-- 2
CREATE FUNCTION
    Purchasing.getOrderDetails(@productId INT)
RETURNS
    TABLE
AS
RETURN
	(SELECT
        *
    FROM
        Purchasing.PurchaseOrderDetail
    WHERE
        ProductID = @productId
        AND OrderQty > 1000)
GO

-- 3
SELECT * FROM Production.Product
CROSS APPLY Purchasing.getOrderDetails(Product.ProductID)
GO

SELECT * FROM Production.Product
OUTER APPLY Purchasing.getOrderDetails(Product.ProductID)
GO

--4
DROP FUNCTION
    Purchasing.getOrderDetails
GO

CREATE FUNCTION
    Purchasing.getOrderDetails(@ProductId INT)
RETURNS
    @OrderDetails TABLE
    (
        PurchaseOrderID INT,
        PurchaseOrderDetailID INT,
        DueDate DATETIME,
        OrderQty SMALLINT,
        ProductID INT,
        UnitPrice MONEY,
        LineTotal MONEY,
        ReceivedQty DECIMAL(8,2),
        RejectedQty DECIMAL(8,2),
        StockedQty DECIMAL(9,2),
        ModifiedDate DATETIME
    )
AS
BEGIN
    INSERT INTO
        @OrderDetails
        (
            PurchaseOrderID,
            PurchaseOrderDetailID,
            DueDate,
            OrderQty,
            ProductID,
            UnitPrice,
            LineTotal,
            ReceivedQty,
            RejectedQty,
            StockedQty,
            ModifiedDate
        )
    SELECT
        PurchaseOrderID,
        PurchaseOrderDetailID,
        DueDate,
        OrderQty,
        ProductID,
        UnitPrice,
        LineTotal,
        ReceivedQty,
        RejectedQty,
        StockedQty,
        ModifiedDate
    FROM
        Purchasing.PurchaseOrderDetail
    WHERE
        ProductID = @ProductId
        AND OrderQty > 1000
    RETURN
END
GO
