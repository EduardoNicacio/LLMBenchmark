-- usp_[Entity]Delete - Delete stored procedure

CREATE PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp VARBINARY(8)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @ActivityId IS NULL THEN
            RAISERROR ('50001: Required parameters cannot be null', 16, 1);

        -- Set default values if null
        IF @UpdatedDateTime IS NULL THEN
            SET @UpdatedDateTime = SYSUTCDATETIME();

        IF @UpdatedByUser IS NULL THEN
            SET @UpdatedByUser = SYSTEM_USER;

        IF @UpdatedByProgram IS NULL THEN 
            SET @UpdatedByProgram = APP_NAME();

        -- Perform soft delete with optimistic lock verification
        UPDATE [dbo].[Activity]
        SET SystemDeleteFlag = 'Y',
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0 THEN
            RAISERROR ('50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
    END TRY
    BEGIN CATCH
        -- Log the error in the table DbError
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
    END CATCH;
END;