CREATE LOGIN mechanic_Mike
WITH PASSWORD='Mike123!';

CREATE USER mechanic
FOR LOGIN mechanic_Mike;

GRANT SELECT, INSERT, DELETE
ON [Equipment] TO mechanic;
GO

CREATE LOGIN landlord_Trevor
WITH PASSWORD='Trevor1967!';

CREATE USER landlord
FOR LOGIN landlord_Trevor;

GRANT SELECT, INSERT, DELETE
ON [Building] TO landlord;
GO

CREATE LOGIN HR_department_Martha
WITH PASSWORD='Samsung2023!';

CREATE USER HR_department_menager
FOR LOGIN HR_department_Martha;

GRANT SELECT, INSERT, DELETE
ON [Performer] TO HR_department_menager;
GO

EXECUTE AS LOGIN = 'mechanic_Mike';

PRINT 'Switched to mechanic_Mike'

SELECT *
FROM [dbo].[Performance] P

SELECT *
FROM [dbo].[Equipment] E

PRINT 'Switched back'

REVERT
GO

EXECUTE AS LOGIN = 'landlord_Trevor';

PRINT 'Switched to landlord_Trevor'

SELECT *
FROM [dbo].[Performance] P

SELECT *
FROM [dbo].[Building] B

PRINT 'Switched back'

REVERT
GO

EXECUTE AS LOGIN = 'HR_department_Martha';

PRINT 'Switched to HR_department_Martha'

SELECT *
FROM [dbo].[Performance] P

SELECT *
FROM [dbo].[Performer] P

PRINT 'Switched back'

REVERT
GO

CREATE ROLE manager;
CREATE ROLE visitor;

ALTER SCHEMA [Public_side] TRANSFER [Conference];
ALTER SCHEMA [Public_side] TRANSFER [Building];
ALTER SCHEMA [Public_side] TRANSFER [Performer];
ALTER SCHEMA [Public_side] TRANSFER [Performance];
ALTER SCHEMA [Public_side] TRANSFER [Quarter];
ALTER SCHEMA [Public_side] TRANSFER [Section];
ALTER SCHEMA [Private_side] TRANSFER [Tool];
ALTER SCHEMA [Private_side] TRANSFER [Equipment];

GRANT SELECT
ON SCHEMA::Public_side
TO visitor;

GRANT SELECT, INSERT, DELETE, UPDATE
ON SCHEMA::Public_side
TO manager;

GRANT SELECT, INSERT, DELETE, UPDATE
ON SCHEMA::Private_side
TO manager;
GO

CREATE LOGIN manager_Tymothy
WITH PASSWORD='Tymothy0978';

CREATE USER manager_Tymothy
FOR LOGIN manager_Tymothy;

ALTER ROLE manager
ADD MEMBER manager_Tymothy;
GO

CREATE LOGIN visitor_Andrew
WITH PASSWORD='Andrew777';

CREATE USER visitor_Andrew
FOR LOGIN visitor_Andrew;

ALTER ROLE visitor
ADD MEMBER visitor_Andrew;
GO

EXECUTE AS LOGIN = 'manager_Tymothy';

PRINT 'Switched to manager_Tymothy'

SELECT *
FROM [Public_side].[Performance] P

SELECT *
FROM [Private_side].[Tool] P

PRINT 'Switched back'

REVERT
GO

EXECUTE AS LOGIN = 'visitor_Andrew';

PRINT 'Switched to visitor_Andrew'

SELECT *
FROM [Public_side].[Performance] P

SELECT *
FROM [Private_side].[Tool] P

PRINT 'Switched back'

REVERT
GO

CREATE LOGIN VIP_visitor_Stan
WITH PASSWORD='VIPS317';

CREATE USER VIP_visitor_Stan
FOR LOGIN VIP_visitor_Stan;

GRANT SELECT
ON [Private_side].[Tool] TO VIP_visitor_Stan;

ALTER ROLE visitor
ADD MEMBER VIP_visitor_Stan;

DENY SELECT
ON [Public_side].[Building]
TO VIP_visitor_Stan;
GO

EXECUTE AS LOGIN = 'VIP_visitor_Stan';

PRINT 'Switched to VIP_visitor_Stan'

SELECT *
FROM [Public_side].[Performance] P

SELECT *
FROM [Public_side].[Building] B

SELECT *
FROM [Private_side].[Tool] T


PRINT 'Switched back'

REVERT
GO

EXEC sp_droprolemember 'visitor', 'VIP_visitor_Stan';
GO

EXECUTE AS LOGIN = 'VIP_visitor_Stan';

PRINT 'Switched to VIP_visitor_Stan'

SELECT *
FROM [Public_side].[Performance] P

SELECT *
FROM [Public_side].[Building] B

SELECT *
FROM [Private_side].[Tool] T


PRINT 'Switched back'

REVERT
GO

DROP USER IF EXISTS visitor_Andrew;
DROP ROLE IF EXISTS visitor;

ALTER SCHEMA [dbo] TRANSFER [Public_side].[Conference];
ALTER SCHEMA [dbo] TRANSFER [Public_side].[Building];
ALTER SCHEMA [dbo] TRANSFER [Public_side].[Performer];
ALTER SCHEMA [dbo] TRANSFER [Public_side].[Performance];
ALTER SCHEMA [dbo] TRANSFER [Public_side].[Quarter];
ALTER SCHEMA [dbo] TRANSFER [Public_side].[Section];
ALTER SCHEMA [dbo] TRANSFER [Private_side].[Tool];
ALTER SCHEMA [dbo] TRANSFER [Private_side].[Equipment];
GO