-- ============================================================
-- Procedure : [dbo].[usp_ActivityDelete]
-- Purpose   : Soft‑delete an Activity row using optimistic locking.
-- Author    : Eduardo Nicacio
-- Created   : 2025-09-05
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId        uniqueidentifier,
    @UpdatedDateTime   datetime2(7) = NULL,
    @UpdatedByUser     nvarchar(100) = NULL,
    @UpdatedByProgram  nvarchar(100) = NULL,
    @SystemTimestamp   binary(8)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Default assignments for audit columns
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    -- Validation: ActivityId required
    IF @ActivityId IS NULL
        RAISERROR(50001, 16, 1, N'ActivityId is required and cannot be NULL.');
        RETURN;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = N'Y',
            UpdatedDateTime   = @UpdatedDateTime,
            UpdatedByUser     = @UpdatedByUser,
            UpdatedByProgram  = @UpdatedByProgram
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR(50004, 16, 1, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
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
END
GO
