DROP TABLE IF EXISTS [dbo].[Equipment];
DROP TABLE IF EXISTS [dbo].[Tool];
DROP TABLE IF EXISTS [dbo].[Performance];
DROP TABLE IF EXISTS [dbo].[Section];
DROP TABLE IF EXISTS [dbo].[Performer];
DROP TABLE IF EXISTS [dbo].[Quarter];
DROP TABLE IF EXISTS [dbo].[Conference];
DROP TABLE IF EXISTS [dbo].[Building];

CREATE TABLE [dbo].[Building](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[address] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Bulding] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Quarter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bulding_id] [int] NOT NULL,
 CONSTRAINT [PK_Quarter] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Conference](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bulding_id] [int] NOT NULL,
	[title] [nvarchar](max) NOT NULL,
	[start_date] [datetime2](0) NULL,
	[end_date] [datetime2](0) NULL,
 CONSTRAINT [PK_Conference] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Section](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[conference_id] [int] NOT NULL,
	[title] [nvarchar](max) NOT NULL,
	[main_performer_id] [int] NOT NULL,
	[quarter_id] [int] NOT NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Performance](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[section_id] [int] NOT NULL,
	[performer_id] [int] NOT NULL,
	[topic] [nvarchar](max) NOT NULL,
	[date] [date] NULL,
	[start_time] [time](0) NULL,
	[duration] [time](0) NULL,
 CONSTRAINT [PK_Performance] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Performer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[surname] [nvarchar](30) NOT NULL,
	[degree] [nvarchar](20) NOT NULL,
	[work_place] [nvarchar](30) NULL,
	[position] [nvarchar](50) NULL,
	[profecional_biography] [nvarchar](max) NULL,
 CONSTRAINT [PK_Performer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Equipment](
	[performance_id] [int] NOT NULL,
	[tool_id] [int] NOT NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[performance_id] ASC,
	[tool_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Tool](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Tool] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Quarter] WITH CHECK ADD CONSTRAINT [FK_Quarter_Building] FOREIGN KEY([bulding_id])
REFERENCES [dbo].[Building] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Conference] WITH CHECK ADD CONSTRAINT [FK_Conference_Building] FOREIGN KEY([bulding_id])
REFERENCES [dbo].[Building] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Conference] FOREIGN KEY([conference_id])
REFERENCES [dbo].[Conference] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Quarter] FOREIGN KEY([quarter_id])
REFERENCES [dbo].[Quarter] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Performer] FOREIGN KEY([main_performer_id])
REFERENCES [dbo].[Performer] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[Performance] WITH CHECK ADD CONSTRAINT [FK_Performance_Section] FOREIGN KEY([section_id])
REFERENCES [dbo].[Section] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[Performance] WITH CHECK ADD CONSTRAINT [FK_Performance_Performer] FOREIGN KEY([performer_id])
REFERENCES [dbo].[Performer] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[Equipment] WITH CHECK ADD CONSTRAINT [FK_Equipment_Performance] FOREIGN KEY([performance_id])
REFERENCES [dbo].[Performance] ([id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].[Equipment] WITH CHECK ADD CONSTRAINT [FK_Equipment_Tool] FOREIGN KEY([tool_id])
REFERENCES [dbo].[Tool] ([id])
ON DELETE NO ACTION
GO

DELETE FROM [dbo].[Conference]
DELETE FROM [dbo].[Equipment]
DELETE FROM [dbo].[Performance]
DELETE FROM [dbo].[Performer]
DELETE FROM [dbo].[Quarter]
DELETE FROM [dbo].[Section]
DELETE FROM [dbo].[Tool]
GO

INSERT INTO [dbo].[Building]
	([address])
VALUES(N'439 Texas Alley')
INSERT INTO [dbo].[Building]
	([address])
VALUES(N'9 Macpherson Road')

INSERT INTO [dbo].[Quarter]
	([bulding_id])
VALUES(1)
INSERT INTO [dbo].[Quarter]
	([bulding_id])
VALUES(2)
INSERT INTO [dbo].[Quarter]
	([bulding_id])
VALUES(1)

INSERT INTO [dbo].[Tool]
	([name])
VALUES(N'Microphone')
INSERT INTO [dbo].[Tool]
	([name])
VALUES(N'Spotlight')
INSERT INTO [dbo].[Tool]
	([name])
VALUES(N'Projector')

INSERT INTO [dbo].[Performer]
	([name],[surname],[degree],[work_place],[position],[profecional_biography])
VALUES(N'John',N'Smith',N'Marketing',N'Marketing at a Fortune 500',N'Vice President',N'John Smith is a highly experienced marketing professional with over 15 years of experience in the field. He has worked for several leading companies in the industry and has a proven track record of delivering successful marketing campaigns that drive revenue growth.
After graduating from the University of California, Berkeley with a degree in Marketing, John started his career at a small boutique agency where he gained invaluable experience working on a variety of clients across different industries. He then moved on to work at a larger agency where he quickly rose through the ranks and became the Director of Marketing.
In his current role as the Vice President of Marketing at a Fortune 500 company, John is responsible for developing and executing the company`s global marketing strategy. He leads a team of talented marketers and works closely with other departments to ensure alignment and integration across all marketing efforts.
Throughout his career, John has received numerous awards and accolades for his outstanding contributions to the field of marketing. He is a sought-after speaker and has presented at industry conferences and events around the world. He is also an active member of several professional organizations, including the American Marketing Association and the Marketing Research Association.')
INSERT INTO [dbo].[Performer]
	([name],[surname],[degree],[work_place],[position],[profecional_biography])
VALUES(N'Jane',N'Smith',N'Marketing',N'DigitalRise Marketing',N'Consultant',N'Jane Smith is a highly accomplished marketing executive with over 15 years of experience in the field. She is known for her exceptional strategic thinking and her ability to deliver innovative marketing campaigns that drive business results.
After earning her Bachelor`s degree in Marketing from the University of California, Berkeley, Jane began her career as a marketing coordinator at a small startup. Over the years, she steadily climbed the ranks, taking on increasingly senior roles at companies ranging from mid-sized firms to Fortune 500 corporations.
Most recently, Jane served as the consultant in Marketing at a leading technology company, where she oversaw a team of 50 professionals and managed a multi-million dollar budget. During her tenure, she was responsible for developing and executing a comprehensive marketing strategy that helped the company achieve record revenue growth.
Throughout her career, Jane has been recognized for her outstanding contributions to the field of marketing. She has won numerous industry awards and has been featured in publications such as Forbes and Business Insider. She is also a sought-after speaker at industry events and conferences.
In her current role, Jane is focused on using her expertise to help businesses achieve their marketing goals. She works closely with clients to develop customized marketing strategies that are tailored to their unique needs and objectives. Her ultimate goal is to help companies drive growth and achieve long-term success through strategic marketing initiatives.')
INSERT INTO [dbo].[Performer]
	([name],[surname],[degree],[work_place],[position],[profecional_biography])
VALUES(N'John',N'Kim',N'Computer Science',N'Pixelwave Technologies',N'Lead Software Engineer',N'John Kim is a seasoned software engineer with over 10 years of experience in the field. He is recognized for his exceptional technical skills and his ability to deliver innovative software solutions that meet the needs of diverse clients.
John received his Bachelor`s degree in Computer Science from Stanford University, where he developed a passion for programming and software engineering. After graduation, he joined a software development company, where he worked on a range of projects for clients in the healthcare, finance, and retail industries.
Over the years, John has honed his skills in various programming languages and frameworks, including Java, Python, and React. He has experience working with large-scale enterprise applications as well as small-scale startups. 
Most recently, John served as the Lead Software Engineer at a growing tech startup, where he was responsible for developing and leading the technical direction of the company`s products. During his tenure, he played a critical role in developing the company`s flagship product, which has been widely recognized for its innovative features and user-friendly interface.
Throughout his career, John has received numerous accolades for his technical expertise and his contributions to the software engineering community. He is also a sought-after speaker at tech conferences and events, where he shares his insights on emerging technologies and best practices in software development.
In his current role, John is focused on using his expertise to help companies build cutting-edge software solutions that drive business success. He works closely with clients to understand their unique needs and objectives, and develops customized software solutions that help them achieve their goals. His ultimate goal is to help companies leverage the power of technology to achieve their business objectives and stay ahead of the competition.')

INSERT INTO [dbo].[Conference]
	([title],[bulding_id],[start_date],[end_date])
VALUES(N'InnovateX Summit: The Future of Technology and Business',1,'2023-04-21 15:25:30','2023-04-25 15:00:00')
INSERT INTO [dbo].[Conference]
	([title],[bulding_id],[start_date],[end_date])
VALUES(N'International Conference on Artificial Intelligence', 2, '2022-09-10 09:00:00', '2022-09-12 18:00:00')

INSERT INTO [dbo].[Conference] ([title], [bulding_id], [start_date], [end_date])
VALUES (N'Annual Marketing and Business Strategy Conference', 1, '2021-08-20 09:30:00', '2021-08-22 16:00:00')

INSERT INTO [dbo].[Section]
	([conference_id],[title],[quarter_id],[main_performer_id])
VALUES(1,N'Artificial Intelligence and the Future of Work', 1, 1)
INSERT INTO [dbo].[Section]
	([conference_id],[title],[quarter_id],[main_performer_id])
VALUES(1,N'Disruptive Technologies Shaping the Future of Business', 3, 2)

INSERT INTO [dbo].[Performance]
	([section_id],[topic],[performer_id],[date],[start_time],[duration])
VALUES(1,N'Artificial Intelligence',2,'2023-04-21','15:50:30','02:30:00')
INSERT INTO [dbo].[Performance]
	([section_id],[topic],[performer_id],[date],[start_time],[duration])
VALUES(2,N'Disruptive Technologies',3,'2023-04-23','14:00:00','17:40:00')


INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(1,1)
INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(1,2)
INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(1,3)

INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(2,1)
INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(2,2)
INSERT INTO [dbo].[Equipment]
	([performance_id],[tool_id])
VALUES(2,3)
GO

SELECT * FROM [Building]
GO

SELECT * FROM [Performer]