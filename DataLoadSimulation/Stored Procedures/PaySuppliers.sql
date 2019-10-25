
CREATE PROCEDURE DataLoadSimulation.PaySuppliers
@CurrentDateTime datetime2(7),
@StartingWhen datetime,
@EndOfTime datetime2(7),
@IsSilentMode bit
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @IsSilentMode = 0
    BEGIN
        PRINT N'Paying suppliers';
    END;

    DECLARE @StaffMemberPersonID int = (SELECT TOP(1) PersonID
                                        FROM [Application].People
                                        WHERE IsEmployee <> 0
                                        ORDER BY NEWID());

    DECLARE @TransactionsToPay TABLE
    (
        SupplierTransactionID int,
        SupplierID int,
        PurchaseOrderID int NULL,
        SupplierInvoiceNumber nvarchar(20) NULL,
        OutstandingBalance decimal(18,2)
    );

    INSERT @TransactionsToPay
        (SupplierTransactionID, SupplierID, PurchaseOrderID, SupplierInvoiceNumber, OutstandingBalance)
    SELECT SupplierTransactionID, SupplierID, PurchaseOrderID, SupplierInvoiceNumber, OutstandingBalance
    FROM Purchasing.SupplierTransactions
    WHERE IsFinalized = 0;

    BEGIN TRAN;

    UPDATE Purchasing.SupplierTransactions
    SET OutstandingBalance = 0,
        FinalizationDate = @StartingWhen,
        LastEditedBy = @StaffMemberPersonID,
        LastEditedWhen = @StartingWhen
    WHERE SupplierTransactionID IN (SELECT SupplierTransactionID FROM @TransactionsToPay);

    INSERT Purchasing.SupplierTransactions
        (SupplierID, TransactionTypeID, PurchaseOrderID, PaymentMethodID,
         SupplierInvoiceNumber, TransactionDate, AmountExcludingTax, TaxAmount, TransactionAmount,
         OutstandingBalance, FinalizationDate, LastEditedBy, LastEditedWhen)
    SELECT ttp.SupplierID, (SELECT TransactionTypeID FROM [Application].TransactionTypes WHERE TransactionTypeName = N'Supplier Payment Issued'),
           NULL, (SELECT PaymentMethodID FROM [Application].PaymentMethods WHERE PaymentMethodName = N'EFT'),
           NULL, CAST(@StartingWhen AS date), 0, 0, 0 - SUM(ttp.OutstandingBalance),
           0, CAST(@StartingWhen AS date), @StaffMemberPersonID, @StartingWhen
    FROM @TransactionsToPay AS ttp
    GROUP BY ttp.SupplierID;

    COMMIT;

END;