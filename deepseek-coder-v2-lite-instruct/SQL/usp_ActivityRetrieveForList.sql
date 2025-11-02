CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN TRY
    SELECT ActivityId, Name
    FROM [dbo].[Activity]
    WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y'
END TRY
BEGIN CATCH
    RAISERROR('Error occurred during retrieve for list operation.', 16, 1);
    EXEC dbo.usp_LogError; -- Assuming this procedure logs errors to DbError table
END CATCH
