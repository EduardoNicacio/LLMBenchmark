CREATE PROCEDURE usp_ActivityDelete
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2 = GETDATE(),
    @UpdatedByUser NVARCHAR(100) = SYSTEM_USER,
    @UpdatedByProgram NVARCHAR(100) = APP_NAME(),
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM sysobjects WHERE name='usp_ActivityDelete' AND xtype='PC')
        EXEC('DROP PROCEDURE usp_ActivityDelete');

    CREATE PROC usp_ActivityDelete AS

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, GETDATE()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'YourProfileName',
            @recipients = 'your@email.com',
            @subject = 'Error in usp_ActivityDelete',
            @body = 'An error occurred: ' + @ErrorMessage;

        RAISERROR('Error occurred during delete operation.', 16, 1);
    END CATCH;
END;
GO
