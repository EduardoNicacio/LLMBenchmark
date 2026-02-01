CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp VARBINARY(8)
AS
BEGIN
    BEGIN TRY
        -- Set default values if null
        SET @UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME());
        SET @UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER);
        SET @UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME());

        -- Soft delete with optimistic locking
        UPDATE [dbo].[Activity]
        SET
            [SystemDeleteFlag] = 'Y',
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE
            [ActivityId] = @ActivityId AND
            [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] ([ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        RAISERROR('50000: Error occurred during delete operation.', 16, 1);
    END CATCH
END
GO
