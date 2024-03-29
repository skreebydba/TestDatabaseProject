﻿
CREATE PROCEDURE DataLoadSimulation.AddSpecialDeals
@CurrentDateTime datetime2(7),
@StartingWhen datetime,
@EndOfTime datetime2(7),
@IsSilentMode bit
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF CAST(@CurrentDateTime AS date) = '20151231'
    BEGIN
        BEGIN TRAN;

        INSERT Sales.SpecialDeals
            (StockItemID, CustomerID, BuyingGroupID, CustomerCategoryID, StockGroupID,
             DealDescription, StartDate, EndDate, DiscountAmount, DiscountPercentage,
             UnitPrice, LastEditedBy, LastEditedWhen)
        VALUES
            (NULL, NULL, (SELECT BuyingGroupID FROM Sales.BuyingGroups WHERE BuyingGroupName = N'Wingtip Toys'),
             NULL, (SELECT StockGroupID FROM Warehouse.StockGroups WHERE StockGroupName = N'USB Novelties'),
             N'10% 1st qtr USB Wingtip', '20160101', '20160331', NULL, 10, NULL,
             2, @StartingWhen);

        INSERT Sales.SpecialDeals
            (StockItemID, CustomerID, BuyingGroupID, CustomerCategoryID, StockGroupID,
             DealDescription, StartDate, EndDate, DiscountAmount, DiscountPercentage,
             UnitPrice, LastEditedBy, LastEditedWhen)
        VALUES
            (NULL, NULL, (SELECT BuyingGroupID FROM Sales.BuyingGroups WHERE BuyingGroupName = N'Tailspin Toys'),
             NULL, (SELECT StockGroupID FROM Warehouse.StockGroups WHERE StockGroupName = N'USB Novelties'),
             N'15% 2nd qtr USB Tailspin', '20160401', '20160630', NULL, 15, NULL,
             2, @StartingWhen);

        COMMIT;

    END;

    IF @IsSilentMode = 0
    BEGIN
        PRINT N'Adding special deals';
    END;

END;