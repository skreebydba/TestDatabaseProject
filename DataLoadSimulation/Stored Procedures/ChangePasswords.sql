
CREATE PROCEDURE DataLoadSimulation.ChangePasswords
@CurrentDateTime datetime2(7),
@StartingWhen datetime,
@EndOfTime datetime2(7),
@IsSilentMode bit
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- 1 in 4 days will be 1 password change, 1 in 8 days will be 2 passwords changed

    DECLARE @NumberOfPasswordsToChange int = (SELECT TOP(1) Quantity
                                              FROM (VALUES (0), (0), (0), (0), (0), (1), (1), (2)) AS q(Quantity)
                                              ORDER BY NEWID());
    IF @IsSilentMode = 0
    BEGIN
        PRINT N'Changing ' + CAST(@NumberOfPasswordsToChange AS nvarchar(20)) + N' passwords';
    END;

    DECLARE @Counter int = 0;
    DECLARE @PersonID int;
    DECLARE @EmailAddress nvarchar(256);
    DECLARE @HashedPassword varbinary(max);
    DECLARE @FullName nvarchar(50);

    WHILE @Counter < @NumberOfPasswordsToChange
    BEGIN
        SELECT TOP(1) @PersonID = PersonID,
                      @EmailAddress = EmailAddress,
                      @FullName = FullName
        FROM [Application].People
        WHERE IsPermittedToLogon <> 0 AND PersonID <> 1
        ORDER BY NEWID();

        UPDATE [Application].People
        SET HashedPassword = HASHBYTES(N'SHA2_256', N'SQLRocks!00' + @FullName),
            [ValidFrom] = @StartingWhen
        WHERE PersonID = @PersonID;

        SET @Counter += 1;
    END;
END;