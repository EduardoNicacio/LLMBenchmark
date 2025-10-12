CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentTimestamp TIMESTAMP;
    SELECT @CurrentTimestamp = SystemTimestamp FROM [dbo].[Activity] WHERE ActivityId = @ActivityId;

    IF @CurrentTimestamp <> @SystemTimestamp
        THROW 50004, 'Operation failed because another user has updated or deleted this Activity.', 1;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE 
            ActivityId = @ActivityId;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
        )
        VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE()
        );
        THROW 50000, 'Error occurred during DELETE operation.', 1;
    END CATCH;
END;
GO