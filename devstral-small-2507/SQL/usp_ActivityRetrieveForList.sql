CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Retrieve ActivityId and Name for active, non-deleted records
        SELECT [ActivityId], [Name] FROM [dbo].[Activity]
        WHERE [ActiveFlag] = 1 AND [SystemDeleteFlag] <> 'Y'
    END TRY
    BEGIN CATCH
        -- Log error to dbo.DbError table
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during list retrieve operation.', 16, 50000);
    END CATCH
END;
GO
