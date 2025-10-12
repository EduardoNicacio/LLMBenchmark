-- usp_ActivityDelete
CREATE OR ALTER PROCEDURE usp_ActivityDelete
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    DECLARE @ErrorCode INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Validate parameters for nullability and types
    IF @UpdatedDateTime IS NULL
        SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL
        SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL
        SET @UpdatedByProgram = APP_NAME();

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            [SystemDeleteFlag] = 'Y',
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram,
            [SystemTimestamp] = @SystemTimestamp
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
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
        RAISERROR('50000', 16, 1, 'Error occurred during deletion');
    END CATCH
END
GO
