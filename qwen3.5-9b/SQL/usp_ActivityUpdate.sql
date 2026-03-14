-- =============================================
-- Stored Procedure: usp_ActivityUpdate
-- Description: Updates an existing Activity record
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityUpdate]
    @ActivityId UNIQUEIDENTIFIER NOT NULL,
    @Name NVARCHAR(128) NOT NULL,
    @Description NVARCHAR(4000) NOT NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT NOT NULL,
    @SystemDeleteFlag CHAR(1) NOT NULL,
    @SystemTimestamp ROWVERSION NOT NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @MaxNameLen INT = 128;
        DECLARE @MaxDescLen INT = 4000;
        DECLARE @MaxTagsLen INT = 200;
        DECLARE @MaxUserLen INT = 100;
        DECLARE @MaxProgramLen INT = 100;

        -- Input Validation
        -- 1. Check Mandatory Parameters for Null (Except nullable ones)
        IF @Name IS NULL
            THROW 50001, 'Parameter Name cannot be NULL.', 16;

        IF @Description IS NULL
            THROW 50001, 'Parameter Description cannot be NULL.', 16;

        IF @ActiveFlag IS NULL
            THROW 50001, 'Parameter ActiveFlag cannot be NULL.', 16;

        IF @SystemDeleteFlag IS NULL
            THROW 50001, 'Parameter SystemDeleteFlag cannot be NULL.', 16;

        -- 2. Check Parameter Lengths
        IF LEN(@Name) > @MaxNameLen
            THROW 50002, 'Parameter Name length exceeds maximum allowed size.', 16;

        IF LEN(@Description) > @MaxDescLen
            THROW 50002, 'Parameter Description length exceeds maximum allowed size.', 16;

        IF LEN(@Tags) > @MaxTagsLen
            THROW 50002, 'Parameter Tags length exceeds maximum allowed size.', 16;

        IF LEN(@UpdatedByUser) > @MaxUserLen
            THROW 50002, 'Parameter UpdatedByUser length exceeds maximum allowed size.', 16;

        IF LEN(@UpdatedByProgram) > @MaxProgramLen
            THROW 50002, 'Parameter UpdatedByProgram length exceeds maximum allowed size.', 16;

        -- 3. Validate Flags
        IF @ActiveFlag NOT IN (0, 1)
            THROW 50003, 'Invalid ActiveFlag. Must be 0 or 1.', 16;

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            THROW 50003, 'Invalid SystemDeleteFlag. Must be N or Y.', 16;

        -- 4. Default Audit Fields
        DECLARE @DefUpdatedDateTime DATETIME2(7) = NULL;
        DECLARE @DefUpdatedByUser NVARCHAR(100) = NULL;
        DECLARE @DefUpdatedByProgram NVARCHAR(100) = NULL;

        IF @UpdatedDateTime IS NULL
            SET @UpdatedDateTime = SYSUTCDATETIME();
            
        IF @UpdatedByUser IS NULL
            SET @UpdatedByUser = SYSTEM_USER;
            
        IF @UpdatedByProgram IS NULL
            SET @UpdatedByProgram = APP_NAME();

        -- 5. Optimistic Locking Check
        DECLARE @CurrentRecordCount INT;
        SELECT @CurrentRecordCount = COUNT(*) 
        FROM [dbo].[Activity]
        WHERE [ActivityId] = @ActivityId 
          AND [SystemTimestamp] = @SystemTimestamp;

        IF @CurrentRecordCount = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;

        -- 6. Update Record
        UPDATE [dbo].[Activity]
        SET 
            [Name] = @Name,
            [Description] = @Description,
            [StartDate] = @StartDate,
            [TargetDate] = @TargetDate,
            [EndDate] = @EndDate,
            [ProgressStatus] = @ProgressStatus,
            [ActivityPoints] = @ActivityPoints,
            [Priority] = @Priority,
            [Risk] = @Risk,
            [Tags] = @Tags,
            [ActiveFlag] = @ActiveFlag,
            [SystemDeleteFlag] = @SystemDeleteFlag,
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
            RAISERROR ('50000', 16, 1, 'Error occurred during Update operation.');
        END CATCH

        -- Re-throw specific error
        IF @ErrorNumber = 50004
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;
        ELSE
            THROW 50000, 'Error occurred during Update operation.', 16;
    END CATCH
END
GO