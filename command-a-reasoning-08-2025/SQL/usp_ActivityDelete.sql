-- ============================================================
-- Procedure : [dbo].[usp_ActivityDelete]
-- Purpose   : Soft-deletes an Activity record
-- Author    : Eduardo Nicacio
-- Created   : 2025-06-15
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Set defaults
SET @UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME());
SET @UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER);
SET @UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME());

-- Validation
IF @ActivityId IS NULL
    RAISERROR(N'ActivityId is required and cannot be NULL.', 16, 1) WITH LOG;

BEGIN TRY
    UPDATE [dbo].[Activity]
    SET 
        [SystemDeleteFlag] = 'Y',
        [UpdatedDateTime] = @UpdatedDateTime,
        [UpdatedByUser] = @UpdatedByUser,
        [UpdatedByProgram] = @UpdatedByProgram
    WHERE 
        [ActivityId] = @ActivityId
        AND [SystemTimestamp] = @SystemTimestamp;

    IF @@ROWCOUNT = 0
        RAISERROR(50004, 16, 1) WITH LOG;
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure],
        [ErrorLine], [ErrorMessage], [ErrorDateTime]
    ) VALUES (
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
        ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
        SYSUTCDATETIME()
    );

    RAISERROR(50000, 16, 1, N'Error occurred during Delete operation.');
END CATCH;
RETURN;
