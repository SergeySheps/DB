CREATE DATABASE Sergey_Shepelevich;
GO

USE Sergey_Shepelevich;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (
	OrderNum INT NULL);
GO

BACKUP DATABASE Sergey_Shepelevich
TO DISK = 'D://Sergey_Shepelevich.bak'
WITH
	NAME = 'Sergey_Shepelevich.bak'; 
GO

USE master;
GO

DROP DATABASE Sergey_Shepelevich;
GO

RESTORE DATABASE Sergey_Shepelevich   
FROM DISK = 'D://Sergey_Shepelevich.bak'   
	WITH 
		FILE=1, 
		RECOVERY; 
GO

USE Sergey_Shepelevich;
GO

