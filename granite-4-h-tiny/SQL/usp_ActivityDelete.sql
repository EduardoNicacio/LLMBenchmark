CREATE PROCEDURE usp_[Entity]Delete
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2 = NULL, -- Default to null if not provided
    @UpdatedByUser nvarchar(100) = NULL, -- Default to null if not provided
    @UpdatedByProgram nvarchar(100) = NULL, -- Default to null if not provided
    @SystemTimestamp timestamp = NULL -- Use for optimistic lock verification
AS
BEGIN TRY
    IF (@UpdatedDateTime IS NOT NULL AND LEN(ISNULL(@UpdatedByUser, '')) > 0 
        AND LEN(ISNULL(@UpdatedByProgram, '')) > 0 AND ISNULL(@SystemTimestamp, 0) <> 0)
    BEGIN
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, GETUTCDATE()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId AND SystemTimestamp = ISNULL(@SystemTimestamp, timestamp);
    END
    ELSE
    BEGIN
        RAISEERROR('Invalid parameters for update. Please provide all required non-null values.', 50001, 1);
    END
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
        ERROR_MESSAGE();
END CATCH;
