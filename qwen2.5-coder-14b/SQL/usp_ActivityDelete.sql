CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN
    -- Validate input parameters
    IF @ActivityId IS NULL
        THROW 50001, 'Parameter ActivityId is NULL.', 1;

    -- Default values for UpdatedDateTime, UpdatedByUser, and UpdatedByProgram
    SET @UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME());
    SET @UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER);
    SET @UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME());

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
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
    END CATCH;
END;
