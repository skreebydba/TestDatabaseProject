CREATE TABLE [Application].[DeliveryMethods] (
    [DeliveryMethodID]   INT           CONSTRAINT [DF_Application_DeliveryMethods_DeliveryMethodID] DEFAULT (NEXT VALUE FOR [Sequences].[DeliveryMethodID]) NOT NULL,
    [DeliveryMethodName] NVARCHAR (50) NOT NULL,
    [LastEditedBy]       INT           NOT NULL,
    [ValidFrom]          DATETIME2 (7) NOT NULL,
    [ValidTo]            DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Application_DeliveryMethods] PRIMARY KEY CLUSTERED ([DeliveryMethodID] ASC),
    CONSTRAINT [FK_Application_DeliveryMethods_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Application_DeliveryMethods_DeliveryMethodName] UNIQUE NONCLUSTERED ([DeliveryMethodName] ASC)
);


GO
CREATE TRIGGER [Application].[TR_Application_DeliveryMethods_DataLoad_Modify]
ON [Application].[DeliveryMethods]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[DeliveryMethods_Archive]
        ( [DeliveryMethodID], [DeliveryMethodName],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[DeliveryMethodID], d.[DeliveryMethodName],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[DeliveryMethodID] = d.[DeliveryMethodID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Ways that stock items can be delivered (ie: truck/van, post, pickup, courier, etc.', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'DeliveryMethods';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a delivery method within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'DeliveryMethods', @level2type = N'COLUMN', @level2name = N'DeliveryMethodID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full name of methods that can be used for delivery of customer orders', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'DeliveryMethods', @level2type = N'COLUMN', @level2name = N'DeliveryMethodName';

