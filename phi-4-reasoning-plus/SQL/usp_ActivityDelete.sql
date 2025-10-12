CREATE PROCEDURE [dbo].[usp_ActivityDelete]
(
@ActivityId UNIQUEIDENTIFIER NOT NULL,
@UpdatedDateTime DATETIME2(7) = NULL,
@UpdatedByUser NVARCHAR(100) = NULL,
@UpdatedByProgram NVARCHAR(100) = NULL,
@SystemTimestamp VARBINARY(8) NOT NULL
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
-------------------------------------------------------------------
-- Validate required parameters.
IF @ActivityId IS NULL OR @SystemTimestamp IS NULL
BEGIN
RAISERROR ('One or more required parameters are null.', 16, 50001);
RETURN;
END
    -------------------------------------------------------------------
    -- Default values for updated columns if they are null.
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    -------------------------------------------------------------------
    -- Perform an optimistic lock check: if record has been modified,
    -- the count will be 0.
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) 
    FROM dbo.Activity
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    IF (@RowCount = 0)
    BEGIN
        RAISERROR ('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
        RETURN;
    END

    -------------------------------------------------------------------
    -- Mark the record as soft-deleted.
    UPDATE dbo.Activity
    SET 
        ActiveFlag = 0,
        UpdatedDateTime = @UpdatedDateTime,
        UpdatedByUser = @UpdatedByUser,
        UpdatedByProgram = @UpdatedByProgram
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;
END TRY
BEGIN CATCH
    -------------------------------------------------------------------
    -- Log the error in dbo.DbError.
    INSERT INTO [dbo].[DbError] 
    (
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
END CATCH
END
GO