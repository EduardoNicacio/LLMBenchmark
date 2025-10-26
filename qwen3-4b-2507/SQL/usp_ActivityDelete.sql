-- usp_ActivityDelete
CREATE PROCEDURE usp_ActivityDelete
    @ActivityId UNIQUEIDENTIFIER,
    @UpdatedDateTime DATETIME2(7),
    @UpdatedByUser NVARCHAR(100),
    @UpdatedByProgram NVARCHAR(100),
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF @ActivityId IS NULL
    BEGIN
        RAISERROR('50001', 16, 1, 'Null parameter detected in usp_ActivityDelete');
        RETURN;
    END

    -- Default values for optional parameters
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
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp
            AND [SystemDeleteFlag] = 'N';

        RETURN 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorMessage, Operation, ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure)
        VALUES (ERROR_MESSAGE(), 'DELETE', ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

        IF ERROR_NUMBER() = 2627 -- Optimistic lock violation
        BEGIN
            RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
        END
        ELSE
        BEGIN
            RAISERROR('50000', 16, 1, 'Error occurred during DELETE operation.');
        END

        RETURN -1;
    END CATCH
END
GO
