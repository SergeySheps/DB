USE AdventureWorks2012;
GO

DROP PROCEDURE dbo.getEmpCountByShiftName
GO

CREATE PROCEDURE dbo.getEmpCountByShiftName
    @ShiftsNames NVARCHAR(50)
AS
	DECLARE @query NVARCHAR(1000);
	
	SET @query = 'SELECT DepName,' + @ShiftsNames + '
	FROM
	(
		SELECT
		    Department.Name AS DepName,
		    Shift.Name AS ShiftName
		FROM
		    HumanResources.Department
		    JOIN HumanResources.EmployeeDepartmentHistory
		        ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
		    JOIN HumanResources.Shift
		        ON EmployeeDepartmentHistory.ShiftID = Shift.ShiftID
		WHERE
		    EndDate IS NULL
	) AS source
	PIVOT
	(
	    COUNT(ShiftName)
	    FOR ShiftName
	    IN (' + @ShiftsNames + ')
	) AS PivotTable'

	EXEC sp_executesql @query
GO

EXECUTE dbo.getEmpCountByShiftName '[Day],[Evening],[Night]'
