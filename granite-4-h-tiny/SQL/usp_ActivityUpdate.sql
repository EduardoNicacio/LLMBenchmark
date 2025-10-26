CREATE PROCEDURE usp_ActivityUpdate
    @ActivityId UNIQUEIDENTIFIER,
    -- Note: All other columns are not included in this procedure as per the requirement.
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM sysobjects WHERE name='usp_ActivityUpdate' AND xtype='PC')
        EXEC('DROP PROCEDURE usp_ActivityUpdate');

    CREATE PROC usp_ActivityUpdate AS

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET /* Include all the columns here except CreatedDateTime, CreatedByUser, and CreatedByProgram. */
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
            @subject = 'Error in usp_ActivityUpdate',
            @body = 'An error occurred: ' + @ErrorMessage;

        RAISERROR('Error occurred during update operation.', 16, 1);
    END CATCH;
END;
GO
