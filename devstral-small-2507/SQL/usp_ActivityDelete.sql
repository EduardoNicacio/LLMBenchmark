-- usp_ActivityDelete  
CREATE PROCEDURE dbo.usp_ActivityDelete
(
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp VARBINARY(8)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Input validation
        IF dbo.CheckInputParameter(@ActivityId, NULL, 0, 'ActivityId') = 1 RETURN;
        IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
        IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
        IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

        DECLARE @CurrentSystemTimestamp VARBINARY(8);

        -- Check for optimistic locking violation
        SELECT @CurrentSystemTimestamp = [SystemTimestamp]
        FROM [dbo].[Activity] WITH (UPDLOCK)
        WHERE [ActivityId] = @ActivityId AND [SystemDeleteFlag] = 'N';

        IF @CurrentSystemTimestamp IS NULL
            RAISERROR('Activity not found or already deleted.', 16, 50004);

        IF @CurrentSystemTimestamp <> @SystemTimestamp
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);

        UPDATE [dbo].[Activity]
        SET [SystemDeleteFlag] = 'Y',
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE [ActivityId] = @ActivityId AND [SystemTimestamp] = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        EXEC dbo.LogError @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_ActivityDelete';

        RAISERROR('Error occurred during Activity delete operation.', 16, 50000);
    END CATCH
END
GO
