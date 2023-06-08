DROP PROCEDURE IF EXISTS [dbo].[Conf_rate];
GO

CREATE PROCEDURE [dbo].[Conf_rate] @conference_id int
AS

DECLARE 
	@amount_of_tools AS int,
	@amount_of_performers AS int,
	@duration AS int,
	@amount_of_space AS int

	--обчислюємо к-сть інструментів для даної конференції
SELECT @amount_of_tools = COUNT(E.tool_id)
--зєднання таблиць і обчислення к-сті записів до tool_id
FROM [Conference] C
RIGHT JOIN [Section] S ON S.conference_id=C.id
LEFT JOIN [Performance] P ON P.section_id=S.id
RIGHT JOIN [Equipment] E ON E.performance_id=P.id

GROUP BY C.id

HAVING C.id=@conference_id
--обчислюємо к-ть виконавців 
SELECT @amount_of_performers = COUNT(RES.PERFORMER_ID)
FROM
(
	SELECT PR.id AS PERFORMER_ID, C.id AS CONFERENCE_ID
	FROM [Conference] C
	RIGHT JOIN [Section] S ON S.conference_id=C.id
	LEFT JOIN [Performance] P ON P.section_id=S.id
	LEFT JOIN [Performer] PR ON PR.id=P.performer_id

	UNION
--обчислюємо к-сть унікальних виконавців
	SELECT S.main_performer_id AS PERFORMER_ID, C.id AS CONFERENCE_ID
	FROM [Conference] C
	RIGHT JOIN [Section] S ON S.conference_id=C.id
) AS RES

GROUP BY RES.CONFERENCE_ID

HAVING RES.CONFERENCE_ID=@conference_id
--обчислюємо тривалість конференції у годинах
SELECT @duration = SUM(DATEDIFF(MINUTE, '0:00:00', P.duration))/60
FROM [Conference] C
RIGHT JOIN [Section] S ON S.conference_id=C.id
LEFT JOIN [Performance] P ON P.section_id=S.id

GROUP BY C.id

HAVING C.id=@conference_id
--обчислюємо к-ть приміщень для даної конференції
SELECT @amount_of_space = COUNT(RES.QUARTER_ID)
FROM 
(
	SELECT DISTINCT C.id AS CONFERENCE_ID, S.quarter_id AS QUARTER_ID
	FROM [Conference] C
	LEFT JOIN [Section] S ON S.conference_id=C.id
) AS RES

GROUP BY RES.CONFERENCE_ID

HAVING RES.CONFERENCE_ID=@conference_id
--обчислюємо к-сть балів для різних параметрів конференції
DECLARE
	@points_for_tools AS int = CASE WHEN @amount_of_tools > 5 THEN 10 WHEN @amount_of_tools > 0 THEN 5 ELSE 0 END,
	@points_for_performers AS int = CASE WHEN @amount_of_performers > 5 THEN 10 WHEN @amount_of_performers > 0 THEN 5 ELSE 0 END,
	@points_for_duraion AS int = CASE WHEN @duration > 24 THEN 10 WHEN @duration <= 24 AND @duration >= 0 THEN @duration*5/12 ELSE 0 END,
	@points_for_space AS int = CASE WHEN @amount_of_space > 3 THEN 10 ELSE 5 END
--виводимо ідентифікатор, назву конференції та загальну к-ть балів
SELECT C.id, C.title, @points_for_tools+@points_for_performers+@points_for_duraion+@points_for_space AS Rate
FROM [Conference] C
WHERE C.id=@conference_id

  DROP PROCEDURE IF EXISTS [dbo].[Conferences_rate];
GO

CREATE PROCEDURE [dbo].[Conferences_rate]
    @start_date DATETIME,
    @end_date DATETIME
AS
BEGIN
    DECLARE @conference_id INT,
            @Index INT = 0,
            @TotalConferences INT

    -- Загальна кількість конференцій за вказаний період часу
    SELECT @TotalConferences = COUNT(*)
    FROM [Conference]
    WHERE start_date >= @start_date AND end_date <= @end_date

    WHILE @Index < @TotalConferences
    BEGIN
        -- Вибірка наступної конференції
        SELECT @conference_id = id
        FROM (
            SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS RowNum
            FROM [Conference]
            WHERE start_date >= @start_date AND end_date <= @end_date
        ) AS Conferences
        WHERE RowNum = @Index + 1

        -- Виклик процедури [Conf_rate] для обробки вибраної конференції
        EXEC [Conf_rate] @conference_id

        SET @Index = @Index + 1
    END
END
GO

-- Виклик процедури для обчислення рейтингу всіх конференцій за вказаний період часу
EXEC [Conferences_rate] '2022-01-01', '2023-12-31'

