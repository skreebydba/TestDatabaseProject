
CREATE PROCEDURE DataLoadSimulation.PerformStocktake
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
        PRINT N'Performing stocktake';
    END;

    DECLARE @StaffMemberPersonID int = (SELECT TOP(1) PersonID
                                        FROM [Application].People
                                        WHERE IsEmployee <> 0
                                        ORDER BY NEWID());

    DECLARE @Counter int = 0;
    DECLARE @NumberOfAdjustedStockItems int = (SELECT CEILING(RAND() * 5));
    DECLARE @StockItemIDToAdjust int;
    DECLARE @QuantityToAdjust int;

    BEGIN TRAN;

    UPDATE Warehouse.StockItemHoldings
    SET LastStocktakeQuantity = QuantityOnHand,
        LastEditedBy = @StaffMemberPersonID,
        LastEditedWhen = @StartingWhen;

    WHILE @Counter < @NumberOfAdjustedStockItems
    BEGIN
        SET @QuantityToAdjust = 5 - CEILING(RAND() * 10);
        SET @StockItemIDToAdjust = (SELECT TOP(1) StockItemID
                                    FROM Warehouse.StockItemHoldings
                                    WHERE (QuantityOnHand + @QuantityToAdjust) >= 0
                                    ORDER BY NEWID());

        IF @StockItemIDToAdjust IS NOT NULL
        BEGIN

            UPDATE Warehouse.StockItemHoldings
            SET LastStocktakeQuantity += @QuantityToAdjust,
                LastEditedBy = @StaffMemberPersonID,
                LastEditedWhen = @StartingWhen
            WHERE StockItemID = @StockItemIDToAdjust;

            INSERT Warehouse.StockItemTransactions
                (StockItemID, TransactionTypeID, CustomerID, InvoiceID, SupplierID, PurchaseOrderID,
                 TransactionOccurredWhen, Quantity, LastEditedBy, LastEditedWhen)
            VALUES
                (@StockItemIDToAdjust,
                 (SELECT TransactionTypeID FROM [Application].TransactionTypes WHERE TransactionTypeName = N'Stock Adjustment at Stocktake'),
                 NULL, NULL, NULL, NULL,
                 @StartingWhen, @QuantityToAdjust, @StaffMemberPersonID, @StartingWhen);
        END;
        SET @Counter += 1;
    END;

    COMMIT;
END;