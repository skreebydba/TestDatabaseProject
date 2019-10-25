CREATE TABLE [Warehouse].[PackageTypes] (
    [PackageTypeID]   INT           CONSTRAINT [DF_Warehouse_PackageTypes_PackageTypeID] DEFAULT (NEXT VALUE FOR [Sequences].[PackageTypeID]) NOT NULL,
    [PackageTypeName] NVARCHAR (50) NOT NULL,
    [LastEditedBy]    INT           NOT NULL,
    [ValidFrom]       DATETIME2 (7) NOT NULL,
    [ValidTo]         DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Warehouse_PackageTypes] PRIMARY KEY CLUSTERED ([PackageTypeID] ASC),
    CONSTRAINT [FK_Warehouse_PackageTypes_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Warehouse_PackageTypes_PackageTypeName] UNIQUE NONCLUSTERED ([PackageTypeName] ASC)
);


GO
CREATE TRIGGER [Warehouse].[TR_Warehouse_PackageTypes_DataLoad_Modify]
ON [Warehouse].[PackageTypes]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Warehouse].[PackageTypes_Archive]
        ( [PackageTypeID], [PackageTypeName],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[PackageTypeID], d.[PackageTypeName],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[PackageTypeID] = d.[PackageTypeID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Ways that stock items can be packaged (ie: each, box, carton, pallet, kg, etc.', @level0type = N'SCHEMA', @level0name = N'Warehouse', @level1type = N'TABLE', @level1name = N'PackageTypes';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a package type within the database', @level0type = N'SCHEMA', @level0name = N'Warehouse', @level1type = N'TABLE', @level1name = N'PackageTypes', @level2type = N'COLUMN', @level2name = N'PackageTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full name of package types that stock items can be purchased in or sold in', @level0type = N'SCHEMA', @level0name = N'Warehouse', @level1type = N'TABLE', @level1name = N'PackageTypes', @level2type = N'COLUMN', @level2name = N'PackageTypeName';

