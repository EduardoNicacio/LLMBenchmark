CREATE PROCEDURE dbo.usp_ActivityDelete (
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @UpdatedDateTime DATETIME2(7) = SYSUTCDATETIME(),
    @UpdatedByUser NVARCHAR(100) = SYSTEM_USER,
    @UpdatedByProgram NVARCHAR(100) = APP_NAME(),
    @SystemTimestamp IMAGE = NULL  -- Use IMAGE for timestamp
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation
    IF @ActivityId IS NULL RAISERROR (50001, 16, 1, 'ActivityId is required.');
    IF LEN(@UpdatedByUser) > 100 RAISERROR (50002, 16, 1, 'UpdatedByUser exceeds maximum length of 100.');
    IF LEN(@UpdatedByProgram) > 100 RAISERROR (50002, 16, 1, 'UpdatedByProgram exceeds maximum length of 100.');

    -- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram if null
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    BEGIN TRY
        -- Optimistic Lock Verification
        IF EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp)
        BEGIN
            RAISERROR (50004, 16, 1, 'Operation failed because another user has updated or deleted this [Entity]. Your changes have been lost. Please review their changes before trying again.');
            RETURN; -- Exit the stored procedure
        END

        UPDATE [dbo].[Activity]
        SET
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE
            ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
	INSERT INTO [dbo].[DbError] (
		ErrorNumber,
		ErrorSeverity,
		ErrorState,
		ErrorProcedure,
		ErrorLine,
		ErrorMessage
	)
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;

        THROW; -- Re-raise the error to be handled by the calling application.
    END CATCH
END;
GO