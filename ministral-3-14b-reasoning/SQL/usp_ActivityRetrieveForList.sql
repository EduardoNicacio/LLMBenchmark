CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Retrieve only ActivityId and Name for active, non-deleted records
        SELECT
            ActivityId,
            Name
        FROM [dbo].[Activity]
        WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y'
        ORDER BY Name;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState,
            ErrorProcedure, ErrorLine,
            ErrorMessage, CreatedDateTime
        )
        VALUES (
            ERROR_NUMBER(), @ErrorSeverity, @ErrorState,
            'usp_ActivityRetrieveForList', ERROR_LINE(),
            @ErrorMessage, SYSUTCDATETIME()
        );

        -- Re-throw the error with our standard message
        RAISERROR('Error occurred during retrieve for list operation.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50000;
    END CATCH
END;
GO
