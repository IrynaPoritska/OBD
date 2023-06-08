--TASK1
--OR WITH SORTING
SELECT *
FROM [Tool] T
WHERE T.name='Microphone' OR T.name='Spotlight'
ORDER BY T.name DESC
GO

--AND WITH SORTING
SELECT *
FROM [Performer] P
WHERE P.surname='Smith' AND P.id=2
ORDER BY P.name ASC
GO

--TASK2
--EXPRESION COUNT()
SELECT COUNT(P.id) AS amount, P.surname 
FROM [Performer] P
GROUP BY P.surname
GO

--TASK3
--OR WITH SORTING AND MULTIPLE TABLES
SELECT *
FROM [Bulding] B
RIGHT JOIN [Quarter] Q ON Q.bulding_id=B.id
WHERE B.id=1 OR B.id=2
ORDER BY Q.id DESC
GO

--AND WITH SORTING AND MULTIPLE TABLES
SELECT P.id AS performance_id, T.name AS tool_name
FROM [Performance] P
INNER JOIN [Equipment] E ON E.performance_id=P.id
LEFT JOIN [Tool] T ON T.id=E.tool_id
WHERE T.name='Microphone' AND P.id=1
ORDER BY T.name ASC
GO

--TASK4
--OUTER JOIN
SELECT P.id AS performance_id, T.name AS tool_name
FROM [Performance] P
INNER JOIN [Equipment] E ON E.performance_id=P.id
FULL OUTER JOIN [Tool] T ON T.id=E.tool_id
GO

--TASK5
--LIKE
SELECT P.name
FROM [Performer] P
WHERE P.surname LIKE 'S%'
GO

--BETWEEN
SELECT COUNT(T.id) AS amount_of_tools
FROM [Performance] P
INNER JOIN [Equipment] E ON E.performance_id=P.id
LEFT JOIN [Tool] T ON T.id=E.tool_id
GROUP BY P.id
HAVING COUNT(T.id) BETWEEN 0 AND 3
GO

--IN
SELECT T.id
FROM [Tool] T
WHERE T.name IN ('Spotlight','Microphone')
GO

--EXISTS
SELECT T.name
FROM [Tool] T
WHERE EXISTS(SELECT E.performance_id FROM [Equipment] E WHERE E.tool_id=T.id)
GO

--ALL
SELECT P.id
FROM [Performer] P
WHERE P.id = ALL(SELECT Pe.id FROM [Performance] Pe WHERE Pe.performer_id=P.id)

--ANY
SELECT T.name
FROM [Tool] T
WHERE T.id = ANY (SELECT E.tool_id FROM [Equipment] E)

--TASK6
--SUM WITH GROUPING
SELECT SUM(RES.amount_of_tools) AS amount_of_tools_needed
FROM
(
	SELECT COUNT(E.tool_id) AS amount_of_tools
	FROM [Tool] T
	RIGHT JOIN [Equipment] E ON E.tool_id=T.id
	GROUP BY E.performance_id
) RES

--TASK7
--SUBQUERY IN WHERE
SELECT *
FROM [Tool] T
WHERE T.id = ANY
(
	SELECT E.tool_id
	FROM [Equipment] E
)

--TASK8
--SUBQUERY IN FROM
SELECT SUM(RES.amount_of_tools) AS amount_of_tools_needed
FROM
(
	SELECT COUNT(E.tool_id) AS amount_of_tools
	FROM [Tool] T
	RIGHT JOIN [Equipment] E ON E.tool_id=T.id
	GROUP BY E.performance_id
) RES

--TASK9
SELECT PR_SUP.id AS Superio, PR_SUB.id AS Inferior
FROM [Section] S


LEFT JOIN [Performer] PR_SUP ON PR_SUP.id=S.main_performer_id
LEFT JOIN [Performance] P ON P.section_id=S.id
LEFT JOIN [Performer] PR_SUB ON PR_SUB.id=P.performer_id

--TASK10
--CrossTab
SELECT 'AMOUNT OF TOOLS' AS Performance_id, [1] AS '1', [2] AS '2'
FROM
(
	SELECT E.performance_id AS Performance, E.tool_id AS Tools
	FROM [Equipment] E

) AS FromTable
PIVOT
(
	COUNT(Tools)
	FOR Performance IN ([1],[2])
) AS PivotTable

--TASK11
--UPDATE ON BASE OF ONE TABLE

SELECT *
FROM [Tool]

UPDATE [Tool] 
SET name='Microphone_test'
WHERE name='Microphone_tes'

SELECT *
FROM [Tool]

--TASK12
--UPDATE ON BASE OF MULTIPLE TABLE

SELECT *
FROM [Tool]

UPDATE T
SET T.name='Microphone'

FROM [Tool] T
	JOIN [Equipment] E ON E.tool_id=T.id
	
WHERE E.performance_id=1 AND T.name='Microphone_test'
	
SELECT *
FROM [Tool]

--TASK13
--INSERT INTO TABLE
INSERT INTO [Tool]
	([name])
VALUES('Sound station')

--TASK14
--INSERT INTO TABLE
DROP TABLE IF EXISTS [Temp]

CREATE TABLE [Temp](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Temp] 
	([id],[name]) 
VALUES 
	(1,'Bottle of water')
GO

INSERT INTO [Tool]
SELECT T.name FROM [Temp] T

DROP TABLE IF EXISTS [Temp]
GO
--TASK15
--DELETE DATA FROM TABLE
DROP TABLE IF EXISTS [Temp]
GO

CREATE TABLE [Temp](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROM [Temp]
GO

INSERT INTO [Temp] 
	([id],[name]) 
VALUES 
	(1,'Bottle of water')
GO

SELECT * FROM [Temp]
GO

DELETE FROM [Temp]
GO

SELECT * FROM [Temp]
GO

DROP TABLE IF EXISTS [Temp]
GO

--TASK16
--DELETE SPECIFIC DATA FROM TABLE
DROP TABLE IF EXISTS [Temp]
GO

CREATE TABLE [Temp](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROM [Temp]
GO

INSERT INTO [Temp] 
	([id],[name]) 
VALUES 
	(1,'Bottle of water'),
	(2,'Something')
GO

SELECT * FROM [Temp]
GO

DELETE FROM [Temp] WHERE name='Something'
GO

SELECT * FROM [Temp]
GO

DROP TABLE IF EXISTS [Temp]
GO

--REPORT1
SELECT C.title AS Conference, S.title AS Section, B.address AS Address, P.topic AS 'Performance topic', PR.profecional_biography AS 'Performer profecional biography'
FROM [Conference] C

LEFT JOIN [Bulding] B ON B.id=C.bulding_id
LEFT JOIN [Section] S ON S.conference_id=C.id
LEFT JOIN [Performance] P ON P.section_id=S.id
LEFT JOIN [Performer] PR ON PR.id=P.performer_id
GO
--REPORT2
DECLARE @CONF_TITLE AS nvarchar(max) = 'InnovateX Summit: The Future of Technology and Business'

SELECT PR.name AS 'NAME', PR.surname AS 'SURNAME', PR.work_place AS 'WORK PLACE', PR.position AS 'POSITION'
FROM [Conference] C
LEFT JOIN [Section] S ON S.conference_id=C.id
LEFT JOIN [Performer] PR ON PR.id = S.main_performer_id
WHERE C.title=@CONF_TITLE

UNION

SELECT PR.name AS 'NAME', PR.surname AS 'SURNAME', PR.work_place AS 'WORK PLACE', PR.position AS 'POSITION'
FROM [Conference] C
LEFT JOIN [Section] S ON S.conference_id=C.id
LEFT JOIN [Performance] P ON P.section_id=S.id
LEFT JOIN [Performer] PR ON PR.id=P.performer_id
WHERE C.title=@CONF_TITLE
--REPORT3
SELECT DISTINCT CONCAT(CAST(Q.id as nvarchar),' - ', CAST(B.address as nvarchar)) AS 'Quarter-Address', CAST(P.start_time AS DATETIME) + CAST(P.date AS DATETIME) AS 'Time', Tools = STUFF((
          SELECT ',' + TT.name
          FROM [Tool] TT
		  RIGHT JOIN [Equipment] ET ON ET.tool_id=TT.id
          WHERE ET.performance_id = E.performance_id
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
FROM [Section] S
LEFT JOIN [Quarter] Q ON Q.id=S.quarter_id
LEFT JOIN [Bulding] B ON B.id=Q.bulding_id
LEFT JOIN [Performance] P ON P.section_id=S.id
LEFT JOIN [Equipment] E ON E.performance_id=P.id
LEFT JOIN [Tool] T ON T.id=E.tool_id
