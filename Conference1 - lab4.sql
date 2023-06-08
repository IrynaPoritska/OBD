BEGIN
ALTER TABLE [Equipment] ADD 
	[id] [uniqueidentifier] NOT NULL,
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Tool] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Performance] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Section] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Performer] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Quarter] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Conference] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;

ALTER TABLE [Building] ADD 
	[UCR] [nvarchar](max) NULL,
	[DCR] [datetime2] NULL,
	[ULR] [nvarchar](max) NULL,
	[DLC] [datetime2] NULL;
END
GO

CREATE OR ALTER TRIGGER [Equipment_insertion]
   ON [Equipment]
   INSTEAD OF INSERT
AS 
	INSERT INTO [Equipment]( id, performance_id, tool_id, UCR, DCR)
    SELECT NEWID(), performance_id, tool_id, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Equipment_update]
   ON  [Equipment]
   AFTER UPDATE
AS	
	DECLARE @id AS uniqueidentifier 

	SELECT @id = i.id FROM inserted i

	UPDATE [Equipment]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Building_insertion]
   ON [Building]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Building]( address, UCR, DCR)
    SELECT address, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Building_update]
   ON  [Building]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Building]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Conference_insertion]
   ON [Conference]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Conference]( bulding_id, title, start_date, end_date, UCR, DCR)
    SELECT bulding_id, title, start_date, end_date, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Conference_update]
   ON  [Conference]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Conference]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Performance_insertion]
   ON [Performance]
   INSTEAD OF INSERT
AS
	DECLARE @section_id int, @performer_id int, @start_time time, @duration time, @date date

	SELECT @section_id=section_id, @performer_id=performer_id, @start_time=start_time, @duration=duration, @date=date  FROM inserted

	DECLARE @quarter_id int

	SELECT @quarter_id=S.quarter_id
	FROM [Section] S

	WHERE S.id=@section_id

	IF EXISTS
	(
		SELECT PE.id FROM [Performance] PE
		WHERE PE.section_id!=@section_id AND PE.date=@date AND PE.performer_id=@performer_id
	) OR @start_time <= ANY
	(
			SELECT DATEADD(SECOND,DATEDIFF(SECOND,0,PE.duration),PE.start_time) AS end_time
			FROM [Performance] PE
			LEFT JOIN [Section] S ON S.id=PE.section_id
			WHERE PE.date=@date AND PE.start_time <= @start_time AND S.quarter_id=@quarter_id
	) OR DATEADD(SECOND,DATEDIFF(SECOND,0,@duration),@start_time) >= ANY
	(
			SELECT PE.start_time
			FROM [Performance] PE
			LEFT JOIN [Section] S ON S.id=PE.section_id
			WHERE PE.date=@date AND PE.start_time >= @start_time AND S.quarter_id=@quarter_id
	) 
		BEGIN
				PRINT 'Cannot assign chosen speacker to another speech in another section this day OR quarter`s booked for another performance of another section'
		END
	ELSE
		BEGIN
			INSERT INTO [Performance]( topic, section_id, performer_id, start_time, duration, date , UCR, DCR)
			SELECT topic, section_id, performer_id, start_time, duration, date, USER_NAME(), GETDATE() FROM inserted;
		END
GO

CREATE OR ALTER TRIGGER [Performance_update]
   ON  [Performance]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Performance]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Performer_insertion]
   ON [Performer]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Performer]( name, surname, degree, work_place, position, profecional_biography, UCR, DCR)
    SELECT name, surname, degree, work_place, position, profecional_biography, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Performer_update]
   ON  [Performer]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Performer]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Quarter_insertion]
   ON [Quarter]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Quarter]( bulding_id, UCR, DCR)
    SELECT bulding_id, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Quarter_update]
   ON  [Quarter]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Quarter]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Section_insertion]
   ON [Section]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Section]( conference_id, main_performer_id, quarter_id, title, UCR, DCR)
    SELECT conference_id, main_performer_id, quarter_id, title, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Section_update]
   ON  [Section]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Section]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO 

CREATE OR ALTER TRIGGER [Tool_insertion]
   ON [Tool]
   INSTEAD OF INSERT
AS 

	INSERT INTO [Tool]( name, UCR, DCR)
    SELECT name, USER_NAME(), GETDATE() FROM inserted;
GO

CREATE OR ALTER TRIGGER [Tool_update]
   ON  [Tool]
   AFTER UPDATE
AS
	
	DECLARE @id AS int 

	SELECT @id = i.id FROM inserted i

	UPDATE [Tool]
	SET ULR = USER_NAME(), DLC = GETDATE()
	WHERE id=@id
GO

INSERT INTO [dbo].[Performance]
	([section_id],[topic],[performer_id],[date],[start_time],[duration])
VALUES(2,N'Artificial Intelligence',2,'2023-04-21','15:50:30','02:30:00')
INSERT INTO [dbo].[Performance]
	([section_id],[topic],[performer_id],[date],[start_time],[duration])
VALUES(2,N'Disruptive Technologies',3,'2023-04-23','14:00:00','07:40:00')