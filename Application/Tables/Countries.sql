CREATE TABLE [Application].[Countries] (
    [CountryID]                INT               CONSTRAINT [DF_Application_Countries_CountryID] DEFAULT (NEXT VALUE FOR [Sequences].[CountryID]) NOT NULL,
    [CountryName]              NVARCHAR (60)     NOT NULL,
    [FormalName]               NVARCHAR (60)     NOT NULL,
    [IsoAlpha3Code]            NVARCHAR (3)      NULL,
    [IsoNumericCode]           INT               NULL,
    [CountryType]              NVARCHAR (20)     NULL,
    [LatestRecordedPopulation] BIGINT            NULL,
    [Continent]                NVARCHAR (30)     NOT NULL,
    [Region]                   NVARCHAR (30)     NOT NULL,
    [Subregion]                NVARCHAR (30)     NOT NULL,
    [Border]                   [sys].[geography] NULL,
    [LastEditedBy]             INT               NOT NULL,
    [ValidFrom]                DATETIME2 (7)     NOT NULL,
    [ValidTo]                  DATETIME2 (7)     NOT NULL,
    CONSTRAINT [PK_Application_Countries] PRIMARY KEY CLUSTERED ([CountryID] ASC),
    CONSTRAINT [FK_Application_Countries_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Application_Countries_CountryName] UNIQUE NONCLUSTERED ([CountryName] ASC),
    CONSTRAINT [UQ_Application_Countries_FormalName] UNIQUE NONCLUSTERED ([FormalName] ASC)
);


GO
CREATE TRIGGER [Application].[TR_Application_Countries_DataLoad_Modify]
ON [Application].[Countries]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[Countries_Archive]
        ( [CountryID], [CountryName], [FormalName], [IsoAlpha3Code], [IsoNumericCode], [CountryType], [LatestRecordedPopulation], [Continent], [Region], [Subregion], [Border],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[CountryID], d.[CountryName], d.[FormalName], d.[IsoAlpha3Code], d.[IsoNumericCode], d.[CountryType], d.[LatestRecordedPopulation], d.[Continent], d.[Region], d.[Subregion], d.[Border],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[CountryID] = d.[CountryID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Countries that contain the states or provinces (including geographic boundaries)', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a country within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'CountryID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Name of the country', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'CountryName';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full formal name of the country as agreed by United Nations', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'FormalName';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = '3 letter alphabetic code assigned to the country by ISO', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'IsoAlpha3Code';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric code assigned to the country by ISO', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'IsoNumericCode';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Type of country or administrative region', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'CountryType';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Latest available population for the country', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'LatestRecordedPopulation';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Name of the continent', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'Continent';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Name of the region', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'Region';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Name of the subregion', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'Subregion';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Geographic border of the country as described by the United Nations', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Countries', @level2type = N'COLUMN', @level2name = N'Border';

