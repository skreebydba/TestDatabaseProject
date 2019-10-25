CREATE TABLE [Application].[Cities] (
    [CityID]                   INT               CONSTRAINT [DF_Application_Cities_CityID] DEFAULT (NEXT VALUE FOR [Sequences].[CityID]) NOT NULL,
    [CityName]                 NVARCHAR (50)     NOT NULL,
    [StateProvinceID]          INT               NOT NULL,
    [Location]                 [sys].[geography] NULL,
    [LatestRecordedPopulation] BIGINT            NULL,
    [LastEditedBy]             INT               NOT NULL,
    [ValidFrom]                DATETIME2 (7)     NOT NULL,
    [ValidTo]                  DATETIME2 (7)     NOT NULL,
    CONSTRAINT [PK_Application_Cities] PRIMARY KEY CLUSTERED ([CityID] ASC),
    CONSTRAINT [FK_Application_Cities_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [FK_Application_Cities_StateProvinceID_Application_StateProvinces] FOREIGN KEY ([StateProvinceID]) REFERENCES [Application].[StateProvinces] ([StateProvinceID])
);


GO
CREATE NONCLUSTERED INDEX [FK_Application_Cities_StateProvinceID]
    ON [Application].[Cities]([StateProvinceID] ASC);


GO
CREATE TRIGGER [Application].[TR_Application_Cities_DataLoad_Modify]
ON [Application].[Cities]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[Cities_Archive]
        ( [CityID], [CityName], [StateProvinceID], [Location], [LatestRecordedPopulation],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[CityID], d.[CityName], d.[StateProvinceID], d.[Location], d.[LatestRecordedPopulation],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[CityID] = d.[CityID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Auto-created to support a foreign key', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'INDEX', @level2name = N'FK_Application_Cities_StateProvinceID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Cities that are part of any address (including geographic location)', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a city within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'COLUMN', @level2name = N'CityID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Formal name of the city', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'COLUMN', @level2name = N'CityName';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'State or province for this city', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'COLUMN', @level2name = N'StateProvinceID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Geographic location of the city', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'COLUMN', @level2name = N'Location';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Latest available population for the City', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'Cities', @level2type = N'COLUMN', @level2name = N'LatestRecordedPopulation';

