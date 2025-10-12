-- usp_ActivityDelete
CREATE PROCEDURE usp_ActivityDelete
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    IF @ActivityId IS NULL RAISERROR('50001', 16, 1);

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
        RAISERROR('50000', 16, 1, 'Error occurred during DELETE operation.');
    END CATCH;

END
GO