
CREATE PROCEDURE DataLoadSimulation.RecordColdRoomTemperatures
@AverageSecondsBetweenReadings int,
@NumberOfSensors int,
@CurrentDateTime datetime2(7),
@EndOfTime datetime2(7),
@IsSilentMode bit
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @IsSilentMode = 0
    BEGIN
        PRINT N'Recording cold room temperatures';
    END;

    DECLARE @TimeCounter datetime2(7) = CAST(@CurrentDateTime AS date);
    DECLARE @SensorCounter int;
    DECLARE @DelayInSeconds int;
    DECLARE @TimeToFinishForTheDay datetime2(7) = DATEADD(second, -30, DATEADD(day, 1, @TimeCounter));
    DECLARE @Temperature decimal(10,2);

    WHILE @TimeCounter < @TimeToFinishForTheDay
    BEGIN
        SET @SensorCounter = 0;
        WHILE @SensorCounter < @NumberOfSensors
        BEGIN
            SET @Temperature = 3 + RAND() * 2;

            DELETE Warehouse.ColdRoomTemperatures
            OUTPUT deleted.ColdRoomTemperatureID,
                   deleted.ColdRoomSensorNumber,
                   deleted.RecordedWhen,
                   deleted.Temperature,
                   deleted.ValidFrom,
                   @TimeCounter
            INTO Warehouse.ColdRoomTemperatures_Archive
            WHERE ColdRoomSensorNumber = @SensorCounter + 1;

            INSERT Warehouse.ColdRoomTemperatures
                (ColdRoomSensorNumber, RecordedWhen, Temperature, ValidFrom, ValidTo)
            VALUES
                (@SensorCounter + 1, @TimeCounter, @Temperature, @TimeCounter, @EndOfTime);

            SET @SensorCounter += 1;
        END;
        SET @DelayInSeconds = CEILING(RAND() * @AverageSecondsBetweenReadings);
        SET @TimeCounter = DATEADD(second, @DelayInSeconds, @TimeCounter);
    END;
END;