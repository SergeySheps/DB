USE AdventureWorks2012;
GO

-- 1
CREATE VIEW Sales.ViewCurrency2
WITH SCHEMABINDING
AS
SELECT 
	currencyRate.CurrencyRateID,
	currencyRate.CurrencyRateDate,
	currencyRate.FromCurrencyCode,
	currency.Name,
	currency.CurrencyCode,
	currencyRate.AverageRate,
	currencyRate.EndOfDayRate
FROM Sales.Currency AS currency
INNER JOIN Sales.CurrencyRate AS currencyRate
	ON currency.CurrencyCode = currencyRate.ToCurrencyCode
GO


CREATE UNIQUE CLUSTERED INDEX IX_CurrencyRateID
	ON Sales.ViewCurrency2 (CurrencyRateID)
GO

--2
CREATE TRIGGER InsteadViewCurrency2Trigger ON Sales.ViewCurrency2
	INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @currencyCode NVARCHAR(50);

	--delete
	IF NOT EXISTS (SELECT * FROM inserted)
		BEGIN 
			SELECT @currencyCode = deleted.CurrencyCode FROM deleted;

			DELETE
			FROM Sales.CurrencyRate
			WHERE ToCurrencyCode = @currencyCode;
			
			DELETE 
			FROM Sales.Currency
			WHERE CurrencyCode = @currencyCode
		END;
	--insert
	ELSE IF NOT EXISTS (SELECT * FROM deleted)
		BEGIN
			IF NOT EXISTS (
				SELECT * 
				FROM Sales.Currency AS sc 
				JOIN inserted ON inserted.CurrencyCode = sc.CurrencyCode)
			BEGIN
				INSERT INTO Sales.Currency (
					CurrencyCode,
					Name,
					ModifiedDate)
				SELECT 
					CurrencyCode,
					Name,
					GETDATE()
				FROM inserted
			END
			ELSE
				UPDATE
				    Sales.Currency
				SET
				    Name = inserted.Name,
				    ModifiedDate = GETDATE()
				FROM
				    inserted
				WHERE
				    Currency.CurrencyCode = inserted.CurrencyCode

			INSERT INTO Sales.CurrencyRate(
				CurrencyRateDate,
				FromCurrencyCode,
				ToCurrencyCode,
				AverageRate,
				EndOfDayRate,
				ModifiedDate)
			SELECT 
				CurrencyRateDate,
				FromCurrencyCode,
				CurrencyCode,
				AverageRate,
				EndOfDayRate,
				GETDATE()
			FROM inserted
		END;
		--update
	ELSE
		BEGIN
			UPDATE Sales.Currency
			SET 
				Name = inserted.Name,
				ModifiedDate = GETDATE()
			FROM Sales.Currency AS currencies
			JOIN inserted ON inserted.CurrencyCode = currencies.CurrencyCode

			UPDATE Sales.CurrencyRate
			SET 
				CurrencyRateDate= inserted.CurrencyRateDate,
				AverageRate= inserted.AverageRate,
				EndOfDayRate= inserted.EndOfDayRate,
				ModifiedDate= GETDATE()
			FROM Sales.CurrencyRate AS currencyRates
			JOIN inserted ON inserted.CurrencyRateID = currencyRates.CurrencyRateID
		END;
END;

--3
INSERT INTO Sales.ViewCurrency2(
	CurrencyRateDate,
	FromCurrencyCode,
	CurrencyCode,
	Name,
	AverageRate,
	EndOfDayRate)
VALUES(GETDATE(), 'USD','TST', 'TEST1', 2.01, 1.65)
GO

UPDATE Sales.ViewCurrency2
SET 
	Name='TERT',
	AverageRate = 2.33,
	EndOfDayRate=3.1
WHERE CurrencyCode = 'TST'
GO

DELETE 
FROM Sales.ViewCurrency2
WHERE CurrencyCode = 'TST'
GO

--SELECT * FROM Sales.Currency WHERE CurrencyCode = 'TST'        --for testing
--SELECT * FROM Sales.CurrencyRate WHERE ToCurrencyCode = 'TST'  --for testing