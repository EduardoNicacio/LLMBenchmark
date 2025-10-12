-- usp_ActivityDelete
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
(
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp timestamp
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y', UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SYSTIMESTAMP = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
        )
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END
GO