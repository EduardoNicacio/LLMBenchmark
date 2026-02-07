CREATE PROCEDURE usp_ActivityDelete
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7),
    @UpdatedByUser NVARCHAR(100),
    @UpdatedByProgram NVARCHAR(100),
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF (@ActivityId IS NULL)
        RAISERROR('Error 50001: ActivityId cannot be null.', 16, 1);
    IF (@UpdatedDateTime IS NULL)
        SET @UpdatedDateTime = SYSUTCDATETIME();
    IF (@UpdatedByUser IS NULL)
        SET @UpdatedByUser = SYSTEM_USER;
    IF (@UpdatedByProgram IS NULL)
        SET @UpdatedByProgram = APP_NAME();

    -- Validate string parameters
    IF (LEN(@UpdatedByUser) > 100)
        RAISERROR('Error 50002: UpdatedByUser exceeds maximum length of 100 characters.', 16, 1);
    IF (LEN(@UpdatedByProgram) > 100)
        RAISERROR('Error 50002: UpdatedByProgram exceeds maximum length of 100 characters.', 16, 1);

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET
            [SystemDeleteFlag] = 'Y',
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram,
            [SystemTimestamp] = @SystemTimestamp
        WHERE
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('Error 50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);

        -- Success
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        -- Log error
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorTime)
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETUTCDATE()
        );

        -- Raise error
        RAISERROR('Error 50000: Error occurred during ActivityDelete operation.', 16, 1);
    END CATCH
END;
GO
