-- usp_ActivityRetrieveForList
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList] AS
BEGIN
    -- Retrieve statement for active, non-deleted records
    BEGIN TRY
        SELECT [ActivityId], [Name]
        FROM [dbo].[Activity]
        WHERE [ActiveFlag] = 1 AND [SystemDeleteFlag] <> 'Y';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        INSERT INTO [dbo].[DbError] ([ErrorDateTime], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (SYSUTCDATETIME(), ERROR_NUMBER(), @ErrorSeverity, @ErrorState, 'usp_ActivityRetrieveForList', ERROR_LINE(), @ErrorMessage);
        THROW;
    END CATCH
END;
GO