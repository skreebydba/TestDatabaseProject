CREATE TABLE [Application].[PaymentMethods] (
    [PaymentMethodID]   INT           CONSTRAINT [DF_Application_PaymentMethods_PaymentMethodID] DEFAULT (NEXT VALUE FOR [Sequences].[PaymentMethodID]) NOT NULL,
    [PaymentMethodName] NVARCHAR (50) NOT NULL,
    [LastEditedBy]      INT           NOT NULL,
    [ValidFrom]         DATETIME2 (7) NOT NULL,
    [ValidTo]           DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Application_PaymentMethods] PRIMARY KEY CLUSTERED ([PaymentMethodID] ASC),
    CONSTRAINT [FK_Application_PaymentMethods_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Application_PaymentMethods_PaymentMethodName] UNIQUE NONCLUSTERED ([PaymentMethodName] ASC)
);


GO
CREATE TRIGGER [Application].[TR_Application_PaymentMethods_DataLoad_Modify]
ON [Application].[PaymentMethods]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[PaymentMethods_Archive]
        ( [PaymentMethodID], [PaymentMethodName],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[PaymentMethodID], d.[PaymentMethodName],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[PaymentMethodID] = d.[PaymentMethodID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Ways that payments can be made (ie: cash, check, EFT, etc.', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'PaymentMethods';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a payment type within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'PaymentMethods', @level2type = N'COLUMN', @level2name = N'PaymentMethodID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full name of ways that customers can make payments or that suppliers can be paid', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'PaymentMethods', @level2type = N'COLUMN', @level2name = N'PaymentMethodName';

