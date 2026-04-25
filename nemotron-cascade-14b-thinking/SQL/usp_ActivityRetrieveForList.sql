-- usp_ActivityRetrieveForList
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    BEGIN TRY
        SELECT [ActivityId], [Name]
        FROM [dbo].[Activity]
        WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (ErrorDateTime, ErrorLevel, ErrorNumber, Message, ConnectionId)
        VALUES (GETDATE(), 1, ERROR_NUMBER(), ERROR_MESSAGE(), @@CONNECTION_ID());
        RAISERROR('Error occurred during RetrieveForList operation.', 16, 50000);
    END CATCH
END
GO