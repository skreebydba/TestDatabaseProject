CREATE TABLE [Purchasing].[SupplierCategories] (
    [SupplierCategoryID]   INT           CONSTRAINT [DF_Purchasing_SupplierCategories_SupplierCategoryID] DEFAULT (NEXT VALUE FOR [Sequences].[SupplierCategoryID]) NOT NULL,
    [SupplierCategoryName] NVARCHAR (50) NOT NULL,
    [LastEditedBy]         INT           NOT NULL,
    [ValidFrom]            DATETIME2 (7) NOT NULL,
    [ValidTo]              DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Purchasing_SupplierCategories] PRIMARY KEY CLUSTERED ([SupplierCategoryID] ASC),
    CONSTRAINT [FK_Purchasing_SupplierCategories_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Purchasing_SupplierCategories_SupplierCategoryName] UNIQUE NONCLUSTERED ([SupplierCategoryName] ASC)
);


GO
CREATE TRIGGER [Purchasing].[TR_Purchasing_SupplierCategories_DataLoad_Modify]
ON [Purchasing].[SupplierCategories]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Purchasing].[SupplierCategories_Archive]
        ( [SupplierCategoryID], [SupplierCategoryName],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[SupplierCategoryID], d.[SupplierCategoryName],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[SupplierCategoryID] = d.[SupplierCategoryID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Categories for suppliers (ie novelties, toys, clothing, packaging, etc.)', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'SupplierCategories';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a supplier category within the database', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'SupplierCategories', @level2type = N'COLUMN', @level2name = N'SupplierCategoryID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full name of the category that suppliers can be assigned to', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'SupplierCategories', @level2type = N'COLUMN', @level2name = N'SupplierCategoryName';

