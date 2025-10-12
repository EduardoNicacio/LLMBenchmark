-- Stored Procedure for Delete Operation
CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN TRY
    UPDATE [dbo].[Activity] 
    SET SystemDeleteFlag = 'Y', UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()), UpdatedByUser = SYSTEM_USER, UpdatedByProgram = APP_NAME(), SystemTimestamp = @SystemTimestamp
    WHERE ActivityId = @ActivityId AND SystemDeleteFlag <> 'Y' AND SystemTimestamp = @SystemTimestamp;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
    END
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE();
    RAISERROR('50001', 16, 1); -- Raise error 50001 for null parameters.
END CATCH;
GO