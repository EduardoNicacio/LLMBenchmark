-- usp_ActivityDelete
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
(
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp timestamp
) AS
BEGIN
    -- Input parameter validation
    IF @ActivityId IS NULL
        THROW 50001, 'Null parameters are not allowed.', 1;

    -- Soft-delete statement
    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET [SystemDeleteFlag] = 'Y', [UpdatedDateTime] = @UpdatedDateTime, [UpdatedByUser] = @UpdatedByUser, [UpdatedByProgram] = @UpdatedByProgram
        WHERE [ActivityId] = @ActivityId AND [SystemTimestamp] = @SystemTimestamp;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        IF (ERROR_NUMBER() = 2627) BEGIN -- Optimistic lock violation
            RAISERROR ('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
            THROW 50004, 'Optimistic lock violation.', 1;
        END ELSE BEGIN
            RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
            INSERT INTO [dbo].[DbError] ([ErrorDateTime], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
            VALUES (SYSUTCDATETIME(), ERROR_NUMBER(), @ErrorSeverity, @ErrorState, 'usp_ActivityDelete', ERROR_LINE(), @ErrorMessage);
            THROW;
        END
    END CATCH
END;
GO