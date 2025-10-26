-- usp_ActivityDelete
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF (@ActivityId IS NULL)
            RAISERROR('Parameter ActivityId cannot be null.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemDeleteFlag <> 'Y')
            RAISERROR('Activity not found or already deleted.', 16, 1);

        IF (@SystemTimestamp IS NULL OR CONVERT(TIMESTAMP, @SystemTimestamp) < GETDATE())
            RAISERROR('Optimistic lock failure: Another user has updated or deleted this Activity.', 16, 1);

        UPDATE [dbo].[Activity]
        SET
            UpdatedDateTime = IIF(@UpdatedDateTime IS NULL, SYSUTCDATETIME(), @UpdatedDateTime),
            UpdatedByUser = IIF(@UpdatedByUser IS NULL, SYSTEM_USER, @UpdatedByUser),
            UpdatedByProgram = IIF(@UpdatedByProgram IS NULL, APP_NAME(), @UpdatedByProgram),
            SystemDeleteFlag = 'Y',
            SystemTimestamp = GETDATE()
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'Error occurred during Delete operation.';
        INSERT INTO [dbo].[DbError] (ErrorMessage, ErrorDate) VALUES (@ErrorMessage, SYSUTCDATETIME());

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH;
END;
GO