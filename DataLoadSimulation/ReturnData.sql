CREATE PROCEDURE [Sales].[ReturnDate]
	@utc int = 0
AS
	IF(@utc = 0)
	BEGIN
		SELECT 'This is the current timestamp: ' + CURRENT_TIMESTAMP;
	END
	ELSE 
	BEGIN
		SELECT 'This is the UTC timestamp ' + GETUTCDATE();
	END
RETURN 0
GO


