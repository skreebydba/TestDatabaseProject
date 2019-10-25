CREATE TABLE [Warehouse].[ColdRoomTemperatures] (
    [ColdRoomTemperatureID] BIGINT          IDENTITY (1, 1) NOT NULL,
    [ColdRoomSensorNumber]  INT             NOT NULL,
    [RecordedWhen]          DATETIME2 (7)   NOT NULL,
    [Temperature]           DECIMAL (10, 2) NOT NULL,
    [ValidFrom]             DATETIME2 (7)   NOT NULL,
    [ValidTo]               DATETIME2 (7)   NOT NULL,
    CONSTRAINT [PK_Warehouse_ColdRoomTemperatures] PRIMARY KEY NONCLUSTERED ([ColdRoomTemperatureID] ASC),
    INDEX [IX_Warehouse_ColdRoomTemperatures_ColdRoomSensorNumber] NONCLUSTERED ([ColdRoomSensorNumber])
)
WITH (MEMORY_OPTIMIZED = ON);

