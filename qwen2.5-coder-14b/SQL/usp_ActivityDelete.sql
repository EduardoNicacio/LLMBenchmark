-- usp_ActivityDelete

CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN
    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @SystemTimestamp IS NULL
            RAISERROR('Error 50001: Null parameter(s) detected.', 16, 1);

        IF LEN(@UpdatedByUser) > 100 OR LEN(@UpdatedByProgram) > 100
            RAISERROR('Error 50002: String parameter exceeds column length.', 16, 1);

        -- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram if null
        IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
        IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
        IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

        -- Soft-delete the activity
        UPDATE [dbo].[Activity]
        SET 
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE 
            ActivityId = @ActivityId AND
            [SystemTimestamp] = @SystemTimestamp;

        -- Check for optimistic lock violation
        IF @@ROWCOUNT = 0
            RAISERROR('Error 50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);

    END TRY
    BEGIN CATCH
        -- Log the error to dbo.DbError table
        INSERT INTO [dbo].[DbError] (
            ErrorMessage,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorNumber
        ) VALUES (
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_NUMBER()
        );

        -- Raise a generic error message
        RAISERROR('Error 50000: Error occurred during Delete operation.', 16, 1);
    END CATCH
END;
GO