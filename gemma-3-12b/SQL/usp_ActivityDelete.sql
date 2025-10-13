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

    -- Input Validation
    IF @ActivityId IS NULL
        RAISERROR (50001, 16, 1, 'Parameter @ActivityId cannot be null.');

	IF @UpdatedDateTime IS NULL
		RAISERROR(50001, 16, 1, "Parameter @UpdatedDateTime cannot be null.");

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE
            ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

		IF @@ROWCOUNT = 0
			RAISERROR(50004,16,1,"Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.");
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() <> 0
            INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorMessage, ErrorDateTime)
            VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        RAISERROR (50000, 16, 1, 'Error occurred during ActivityDelete operation.');
    END CATCH;
END;
GO