USE AdventureWorks2012;
GO

/*1*/
SELECT a.BusinessEntityID, b.JobTitle, MAX(a.RateChangeDate) AS LastRateDate
FROM HumanResources.EmployeePayHistory AS a
INNER JOIN HumanResources.Employee AS b ON a.BusinessEntityID = b.BusinessEntityID
GROUP BY a.BusinessEntityID, b.JobTitle;
GO

/*2*/
SELECT  employees.BusinessEntityID,
		employees.JobTitle,
		departments.Name AS DepName,
		departments.StartDate,
		departments.EndDate,
		YEAR(ISNULL(departments.EndDate, GETDATE())) - YEAR(departments.StartDate) AS 'Years'
FROM HumanResources.Employee AS employees
INNER JOIN (
	SELECT b.BusinessEntityID, b.DepartmentID,b.StartDate,b.EndDate, c.Name
	FROM HumanResources.EmployeeDepartmentHistory AS b
	INNER JOIN HumanResources.Department AS c ON b.DepartmentID = c.DepartmentID
) AS departments ON employees.BusinessEntityID = departments.BusinessEntityID
GO

/*3*/
SELECT  employees.BusinessEntityID,
		employees.JobTitle,
		departments.Name AS DepName,
		departments.GroupName,
		DepGroup = 
		CASE CHARINDEX(' ', departments.GroupName, 1)
			WHEN 0 THEN departments.GroupName -- empty or single word
			ELSE SUBSTRING(departments.GroupName, 1, CHARINDEX(' ', departments.GroupName, 1) - 1) -- multi-word
		END
FROM HumanResources.Employee AS employees
INNER JOIN (
	SELECT b.BusinessEntityID, b.DepartmentID, b.StartDate, b.EndDate, c.Name, c.GroupName
	FROM HumanResources.EmployeeDepartmentHistory AS b
	INNER JOIN HumanResources.Department AS c ON b.DepartmentID = c.DepartmentID
) AS departments ON employees.BusinessEntityID = departments.BusinessEntityID
GO