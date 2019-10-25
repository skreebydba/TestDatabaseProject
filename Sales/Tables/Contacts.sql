CREATE TABLE [dbo].[Contacts]
(
	[Id] INT NOT NULL PRIMARY KEY,
	[FirstName] NVARCHAR(100),
	[LastName] NVARCHAR(100),
	[StreetAddress] NVARCHAR(300),
	[City] NVARCHAR(100),
	[StateCode] NVARCHAR(100),
	[ZipCode] NVARCHAR(10)
)
