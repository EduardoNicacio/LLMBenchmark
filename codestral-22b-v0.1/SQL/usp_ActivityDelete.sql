-- ============================================================
-- Procedure : [dbo].[usp_ActivityDelete]
-- Purpose   : Soft deletes an activity from the Activity table
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-19
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityDelete]
(
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp binary(8)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Input validation
    IF @ActivityId IS NULL
        RAISERROR(50001, 16, 1, N'@ActivityId is required and cannot be NULL.');

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y', UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR(50004, 16, 1, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime
        ) VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SYSUTCDATETIME()
        );
        RAISERROR(50000, 16, 1, N'Error occurred during Delete operation.');
    END CATCH;
END;
