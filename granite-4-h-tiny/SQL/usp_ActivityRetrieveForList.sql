CREATE PROCEDURE usp_ActivityRetrieveForList AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM sysobjects WHERE name='usp_ActivityRetrieveForList' AND xtype='PC')
        EXEC('DROP PROCEDURE usp_ActivityRetrieveForList');

    CREATE PROC usp_ActivityRetrieveForList AS

    BEGIN TRY
        SELECT ActivityId, Name
        FROM [dbo].[Activity]
        WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';

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
            @subject = 'Error in usp_ActivityRetrieveForList',
            @body = 'An error occurred: ' + @ErrorMessage;

        RAISERROR('Error occurred during retrieve for list operation.', 16, 1);
    END CATCH;
END;
GO
