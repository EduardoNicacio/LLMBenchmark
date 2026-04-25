-- usp_ActivityDelete
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
(
    -- Input parameters: ActivityId, UpdatedDateTime, UpdatedByUser, UpdatedByProgram, SystemTimestamp
    @ActivityId UNIQUEIDENTIFIER NOT NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP NOT NULL
)
AS
BEGIN
    -- Validate null parameters for non-nullable columns
    IF @ActivityId IS NULL OR @SystemTimestamp IS NULL BEGIN RAISERROR('Error 50001: Null parameter detected.', 16, 50001); RETURN; END

    BEGIN TRY
        -- Optimistic lock check
        DECLARE @CurrentSystemTimestamp TIMESTAMP;
        SELECT @CurrentSystemTimestamp = SystemTimestamp FROM [dbo].[Activity] WHERE ActivityId = @ActivityId;

        IF @CurrentSystemTimestamp <> @SystemTimestamp
        BEGIN
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
            RETURN;
        END

        -- Soft-delete with default update values if parameters are null
        UPDATE [dbo].[Activity]
        SET 
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME());
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (ErrorDateTime, ErrorLevel, ErrorNumber, Message, ConnectionId)
        VALUES (GETDATE(), 1, ERROR_NUMBER(), ERROR_MESSAGE(), @@CONNECTION_ID());
        RAISERROR('Error occurred during Delete operation.', 16, 50000);
    END CATCH
END
GO