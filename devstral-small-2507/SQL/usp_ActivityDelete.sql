CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId uniqueidentifier,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp varbinary(8)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @SystemTimestamp IS NULL
        BEGIN
            RAISERROR('Required parameter is null.', 16, 50001);
            RETURN;
        END

        -- Default values if not provided
        IF @UpdatedDateTime IS NULL THEN SET @UpdatedDateTime = SYSUTCDATETIME();
        IF @UpdatedByUser IS NULL THEN SET @UpdatedByUser = SYSTEM_USER;
        IF @UpdatedByProgram IS NULL THEN SET @UpdatedByProgram = APP_NAME();

        -- Soft-delete the activity record
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Log error to dbo.DbError table
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during delete operation.', 16, 50000);
    END CATCH
END;
GO
