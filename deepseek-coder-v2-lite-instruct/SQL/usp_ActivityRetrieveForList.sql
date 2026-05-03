-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieveForList]
-- Purpose   : Retrieve a list of activity records for display purposes.
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-01
-- ============================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT ActivityId, Name
    FROM [dbo].[Activity]
    WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y'
    ORDER BY Name ASC;
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError]
        (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
    VALUES
        (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
         ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
         SYSUTCDATETIME());
    RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityRetrieveForList operation.');
END CATCH;
