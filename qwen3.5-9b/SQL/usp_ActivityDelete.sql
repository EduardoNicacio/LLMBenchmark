-- =============================================
-- Stored Procedure: usp_ActivityDelete
-- Description: Soft Deletes an Activity record
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityDelete]
    @ActivityId UNIQUEIDENTIFIER NOT NULL,
    @SystemTimestamp ROWVERSION NOT NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @MaxUserLen INT = 100;
        DECLARE @MaxProgramLen INT = 100;

        -- Validate Length of Audit Parameters
        IF LEN(@UpdatedByUser) > @MaxUserLen
            THROW 50002, 'Parameter UpdatedByUser length exceeds maximum allowed size.', 16;

        IF LEN(@UpdatedByProgram) > @MaxProgramLen
            THROW 50002, 'Parameter UpdatedByProgram length exceeds maximum allowed size.', 16;

        -- Default Audit Fields
        DECLARE @DefUpdatedDateTime DATETIME2(7) = NULL;
        DECLARE @DefUpdatedByUser NVARCHAR(100) = NULL;
        DECLARE @DefUpdatedByProgram NVARCHAR(100) = NULL;

        IF @UpdatedDateTime IS NULL
            SET @UpdatedDateTime = SYSUTCDATETIME();
            
        IF @UpdatedByUser IS NULL
            SET @UpdatedByUser = SYSTEM_USER;
            
        IF @UpdatedByProgram IS NULL
            SET @UpdatedByProgram = APP_NAME();

        -- Optimistic Locking Check (Validate SystemTimestamp)
        DECLARE @CurrentRecordCount INT;
        SELECT @CurrentRecordCount = COUNT(*) 
        FROM [dbo].[Activity]
        WHERE [ActivityId] = @ActivityId 
          AND [SystemTimestamp] = @SystemTimestamp;

        IF @CurrentRecordCount = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;

        UPDATE [dbo].[Activity]
        SET 
            [SystemDeleteFlag] = 'Y',
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorNumber INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER();

        BEGIN TRY
            INSERT INTO [dbo].[DbError] (
                [ErrorMessage],
                [ErrorNumber],
                [StackTrace]
            )
            VALUES (
                @ErrorMessage,
                @ErrorNumber,
                ERROR_LINE() + ' ' + ERROR_PROCEDURE()
            );
        END TRY
        BEGIN CATCH
            RAISERROR ('50000', 16, 1, 'Error occurred during Delete operation.');
        END CATCH

        -- Re-throw generic error or 50004 if not handled specifically
        IF @ErrorNumber = 50004
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;
        ELSE
            THROW 50000, 'Error occurred during Delete operation.', 16;
    END CATCH
END
GO