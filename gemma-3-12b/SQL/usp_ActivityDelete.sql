-- usp_ActivityDelete
CREATE PROCEDURE [dbo].[usp_ActivityDelete] (
    @ActivityId uniqueidentifier = NULL,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate Input Parameters
    IF @ActivityId IS NULL RAISERROR (50001, 16, 1, 'ActivityId')
    IF @UpdatedDateTime IS NULL RAISERROR (50001, 16, 1, 'UpdatedDateTime')
    IF LEN(@UpdatedByUser) > 100 RAISERROR (50002, 16, 1, 'UpdatedByUser')
    IF LEN(@UpdatedByProgram) > 100 RAISERROR (50002, 16, 1, 'UpdatedByProgram')

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        -- Log Error
        IF ERROR_NUMBER() = 2627 -- Optimistic Lock Violation (Concurrency Failure)
            RAISERROR (50004, 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.')
        ELSE
            INSERT INTO dbo.DbError (ErrorTime, ApplicationName, ProcedureName, ErrorMessage)
            VALUES (GETDATE(), 'ActivityDelete', 'usp_ActivityDelete', ERROR_MESSAGE());

        -- Raise Error
        RAISERROR (50000, 16, 1, 'Error occurred during ActivityDelete operation.')
        RETURN;
    END CATCH
END;
GO