CREATE TABLE [Application].[TransactionTypes] (
    [TransactionTypeID]   INT           CONSTRAINT [DF_Application_TransactionTypes_TransactionTypeID] DEFAULT (NEXT VALUE FOR [Sequences].[TransactionTypeID]) NOT NULL,
    [TransactionTypeName] NVARCHAR (50) NOT NULL,
    [LastEditedBy]        INT           NOT NULL,
    [ValidFrom]           DATETIME2 (7) NOT NULL,
    [ValidTo]             DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Application_TransactionTypes] PRIMARY KEY CLUSTERED ([TransactionTypeID] ASC),
    CONSTRAINT [FK_Application_TransactionTypes_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]),
    CONSTRAINT [UQ_Application_TransactionTypes_TransactionTypeName] UNIQUE NONCLUSTERED ([TransactionTypeName] ASC)
);


GO
CREATE TRIGGER [Application].[TR_Application_TransactionTypes_DataLoad_Modify]
ON [Application].[TransactionTypes]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE([ValidFrom])
    BEGIN
        THROW 51000, '[ValidFrom] must be updated when simulating data loads', 1;
        ROLLBACK TRAN;
    END;

    INSERT [Application].[TransactionTypes_Archive]
        ( [TransactionTypeID], [TransactionTypeName],[LastEditedBy], [ValidFrom],[ValidTo])
    SELECT d.[TransactionTypeID], d.[TransactionTypeName],d.[LastEditedBy],  d.[ValidFrom], i.[ValidFrom]
    FROM inserted AS i
    INNER JOIN deleted AS d
    ON i.[TransactionTypeID] = d.[TransactionTypeID];
END;
GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Types of customer, supplier, or stock transactions (ie: invoice, credit note, etc.)', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'TransactionTypes';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a transaction type within the database', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'TransactionTypes', @level2type = N'COLUMN', @level2name = N'TransactionTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Full name of the transaction type', @level0type = N'SCHEMA', @level0name = N'Application', @level1type = N'TABLE', @level1name = N'TransactionTypes', @level2type = N'COLUMN', @level2name = N'TransactionTypeName';

