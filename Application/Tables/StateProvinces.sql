CREATE TABLE [Application].[StateProvinces] (
    [StateProvinceID]          INT               CONSTRAINT [DF_Application_StateProvinces_StateProvinceID] DEFAULT (NEXT VALUE FOR [Sequences].[StateProvinceID]) NOT NULL,
    [StateProvinceCode]        NVARCHAR (5)      NOT NULL,
    [StateProvinceName]        NVARCHAR (50)     NOT NULL,
    [CountryID]                INT               NOT NULL,
    [SalesTerritory]           NVARCHAR (50)     NOT NULL,
    [Border]                   [sys].[geography] NULL,
    [LatestRecordedPopulation] BIGINT            NULL,
    [LastEditedBy]             INT               NOT NULL,
    [ValidFrom]                DATETIME2 (7)     NOT NULL,
    [ValidTo]                  DATETIME2 (7)     NOT NULL,
    CONSTRAINT [PK_Application_StateProvinces] PRIMARY KEY CLUSTERED ([StateProvinceID] ASC),
    CONSTRAINT [FK_Application_StateProvinces_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [FK_Application_StateProvinces_CountryID_Application_Countries] FOREIGN KEY ([CountryID]) REFERENCES [Application].[Countries] ([CountryID]),
    CONSTRAINT [UQ_Application_StateProvinces_StateProvinceName] UNIQUE NONCLUSTERED ([StateProvinceName] ASC)
);


GO
CREATE NONCLUSTERED INDEX [FK_Application_StateProvinces_CountryID]
    ON [Application].[StateProvinces]([CountryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Application_StateProvinces_SalesTerritory]
    ON [Application].[StateProvinces]([SalesTerritory] ASC);


GO
CREATE TRIGGER [Application].[TR_Application_StateProvinces_DataLoad_Modify]
ON [Application].[StateProvinces]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[StateProvinces_Archive]
        ( [StateProvinceID], [StateProvinceCode], [StateProvinceName], [CountryID], [SalesTerritory], [Border], [LatestRecordedPopulation],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[StateProvinceID], d.[StateProvinceCode], d.[StateProvinceName], d.[CountryID], d.[SalesTerritory], d.[Border], d.[LatestRecordedPopulation],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[StateProvinceID] = d.[StateProvinceID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Auto-created to support a foreign key', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'INDEX', @level2name = N'FK_Application_StateProvinces_CountryID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Index used to quickly locate sales territories', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'INDEX', @level2name = N'IX_Application_StateProvinces_SalesTerritory';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'States or provinces that contain cities (including geographic location)', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a state or province within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'StateProvinceID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Common code for this state or province (such as WA - Washington for the USA)', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'StateProvinceCode';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Formal name of the state or province', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'StateProvinceName';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Country for this StateProvince', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'CountryID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Sales territory for this StateProvince', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'SalesTerritory';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Geographic boundary of the state or province', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'Border';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Latest available population for the StateProvince', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'StateProvinces', @level2type = N'COLUMN', @level2name = N'LatestRecordedPopulation';

