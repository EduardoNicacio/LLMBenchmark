CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp binary(8) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate ActivityId is not null
        IF @ActivityId IS NULL
            RAISERROR('ActivityId cannot be null', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        -- Set default values if parameters are null
        DECLARE @CurrentDateTime datetime2(7) = ISNULL(@UpdatedDateTime, SYSUTCDATETIME());
        DECLARE @CurrentUser nvarchar(100) = ISNULL(@UpdatedByUser, SYSTEM_USER);
        DECLARE @CurrentProgram nvarchar(100) = ISNULL(@UpdatedByProgram, APP_NAME());

        -- Check if the record exists and is not deleted
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemDeleteFlag = 'N')
            RAISERROR('Activity with the specified ID does not exist or is already deleted', 16, 1) WITH RAISEDBYCALLER = TRUE;

        -- Soft-delete the record with optimistic locking check
        UPDATE [dbo].[Activity]
        SET
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = @CurrentDateTime,
            UpdatedByUser = @CurrentUser,
            UpdatedByProgram = @CurrentProgram
        WHERE
            ActivityId = @ActivityId AND
            (ISNULL(@SystemTimestamp, 0x) = 0x OR SystemTimestamp = @SystemTimestamp) AND
            SystemDeleteFlag = 'N';

        -- Check if any rows were actually updated (for optimistic locking)
        IF @@ROWCOUNT = 0
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50004;

        -- Return success
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState,
            ErrorProcedure, ErrorLine,
            ErrorMessage, CreatedDateTime
        )
        VALUES (
            ERROR_NUMBER(), @ErrorSeverity, @ErrorState,
            'usp_ActivityDelete', ERROR_LINE(),
            @ErrorMessage, SYSUTCDATETIME()
        );

        -- Re-throw the error with our standard message
        RAISERROR('Error occurred during delete operation.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50000;
    END CATCH
END;
GO
