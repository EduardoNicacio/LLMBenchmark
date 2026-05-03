-- ============================================================
-- Procedure : [dbo].[usp_ActivityDelete]
-- Purpose   : Delete an activity record from the Activity table.
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-01
-- ============================================================
SET NOCOUNT ON;
BEGIN TRY
    DECLARE @UpdatedDateTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @UpdatedByUser NVARCHAR(100) = SYSTEM_USER;
    DECLARE @UpdatedByProgram NVARCHAR(100) = APP_NAME();

    -- Validation check
    IF @ActivityId IS NULL RAISERROR(50001, 16, 1, N'@ActivityId');

    -- Perform soft delete with optimistic locking
    UPDATE [dbo].[Activity]
    SET SystemDeleteFlag = 'Y', UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    IF @@ROWCOUNT = 0 RAISERROR(50004, 16, 1);
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError]
        (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
    VALUES
        (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
         ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
         SYSUTCDATETIME());
    RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityDelete operation.');
END CATCH;
