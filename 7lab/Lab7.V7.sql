USE AdventureWorks2012;
GO

-- 1
DECLARE @xml XML

SET @xml = (
    SELECT
        Product.ProductID AS '@ID',
        Product.Name AS 'Name',
        ProductModel.ProductModelID AS 'Model/@ID',
        ProductModel.Name AS 'Model/Name'
    FROM
        Production.Product
        JOIN Production.ProductModel 
		ON Product.ProductModelID = ProductModel.ProductModelID
    FOR XML
        PATH ('Product'),
		ROOT ('Products')
)

SELECT @xml

-- 2
CREATE TABLE #ProductTemp (
    ProductID INT,
    ProductName NVARCHAR(50),
    ProductModelID INT,
    ProductModelName NVARCHAR(50)
)

INSERT INTO #ProductTemp (
    ProductID,
    ProductName,
    ProductModelID,
    ProductModelName
)
SELECT
    ProductID = xmlNode.value('@ID', 'INT'),
    ProductName = xmlNode.value('Name[1]', 'NVARCHAR(50)'),
    ProductModelID = xmlNode.value('Model[1]/@ID', 'INT'),
    ProductModelName = xmlNode.value('Model[1]/Name[1]', 'NVARCHAR(50)')
FROM
    @xml.nodes('/Products/Product') AS xml(xmlNode)
GO

SELECT * FROM #ProductTemp

