CREATE PROCEDURE usp_ActivityDelete
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp rowversion -- Optimistic lock column
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Parameter validation: ActivityId cannot be null
        IF @ActivityId IS NULL
            THROW 50001, 'Null parameter detected.', 1;
            
        DECLARE @CurrentSystemTimestamp rowversion;
        SELECT @CurrentSystemTimestamp = SystemTimestamp FROM dbo.Activity WHERE ActivityId = @ActivityId AND SystemDeleteFlag = 'N';
        
        IF @CurrentSystemTimestamp IS NULL
            THROW 50001, 'Activity not found or already deleted.', 1;
            
        -- Soft-delete and update metadata with defaults if null
        UPDATE dbo.Activity
        SET 
            SystemDeleteFlag = 'Y',
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @CurrentSystemTimestamp; -- Optimistic lock check
        
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorTime)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), SYSDATETIME());
        
        IF ERROR_NUMBER() = 5131 -- Optimistic lock violation
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
            
        ELSE
            THROW 50000, 'Error occurred during Delete operation.', 1;
    END CATCH
END
GO