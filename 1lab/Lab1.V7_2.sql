USE AdventureWorks2012;
GO

/*1*/
SELECT COUNT(GroupName) [DepartmentCount] 
FROM [AdventureWorks2012].[HumanResources].[Department]
WHERE GroupName='Executive General and Administration';
GO

/*2*/
SELECT TOP 5 [BusinessEntityID]
      ,[JobTitle]
      ,[BirthDate]
      ,[Gender] 
FROM [AdventureWorks2012].[HumanResources].[Employee] 
ORDER BY BirthDate DESC
GO

/*3*/
SELECT [BusinessEntityID]
     ,[JobTitle]
     ,[Gender] 
	 ,[HireDate]
	 ,REPLACE([LoginID], 'adventure-works', 'adventure-works2012') [LoginID]
FROM [AdventureWorks2012].[HumanResources].[Employee] 
WHERE Gender='F' 
AND DATENAME(dw,HireDate)='Tuesday' 
GO
 
  