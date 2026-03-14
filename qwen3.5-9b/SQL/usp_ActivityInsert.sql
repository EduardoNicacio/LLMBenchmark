- =============================================
-- Stored Procedure: usp_ActivityInsert
-- Description: Inserts a new Activity record
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER NOT NULL,
    @ProjectMemberId UNIQUEIDENTIFIER NOT NULL,
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
    @CreatedDateTime DATETIME2(7) NOT NULL,
    @CreatedByUser NVARCHAR(100) NOT NULL,
    @CreatedByProgram NVARCHAR(100) NOT NULL
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
        -- 1. Check Mandatory Parameters for Null (Except nullable ones with defaults)
        IF @ProjectId IS NULL
            THROW 50001, 'Parameter ProjectId cannot be NULL.', 16;

        IF @ProjectMemberId IS NULL
            THROW 50001, 'Parameter ProjectMemberId cannot be NULL.', 16;

        IF @Name IS NULL
            THROW 50001, 'Parameter Name cannot be NULL.', 16;

        IF @Description IS NULL
            THROW 50001, 'Parameter Description cannot be NULL.', 16;

        IF @ActiveFlag IS NULL
            THROW 50001, 'Parameter ActiveFlag cannot be NULL.', 16;

        IF @SystemDeleteFlag IS NULL
            THROW 50001, 'Parameter SystemDeleteFlag cannot be NULL.', 16;

        IF @CreatedDateTime IS NULL
            THROW 50001, 'Parameter CreatedDateTime cannot be NULL.', 16;

        IF @CreatedByUser IS NULL
            THROW 50001, 'Parameter CreatedByUser cannot be NULL.', 16;

        IF @CreatedByProgram IS NULL
            THROW 50001, 'Parameter CreatedByProgram cannot be NULL.', 16;

        -- 2. Check Parameter Lengths
        IF LEN(@ProjectId) > 100
            THROW 50002, 'Parameter ProjectId length exceeds maximum allowed size.', 16;

        IF LEN(@Name) > @MaxNameLen
            THROW 50002, 'Parameter Name length exceeds maximum allowed size.', 16;

        IF LEN(@Description) > @MaxDescLen
            THROW 50002, 'Parameter Description length exceeds maximum allowed size.', 16;

        IF LEN(@Tags) > @MaxTagsLen
            THROW 50002, 'Parameter Tags length exceeds maximum allowed size.', 16;

        IF LEN(@CreatedByUser) > @MaxUserLen
            THROW 50002, 'Parameter CreatedByUser length exceeds maximum allowed size.', 16;

        IF LEN(@CreatedByProgram) > @MaxProgramLen
            THROW 50002, 'Parameter CreatedByProgram length exceeds maximum allowed size.', 16;

        -- 3. Validate Flags
        IF @ActiveFlag NOT IN (0, 1)
            THROW 50003, 'Invalid ActiveFlag. Must be 0 or 1.', 16;

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            THROW 50003, 'Invalid SystemDeleteFlag. Must be N or Y.', 16;

        -- 4. Optimistic Locking for RowVersion (Not required for Insert but best practice if ID provided)
        -- SystemTimestamp is NOT included in Insert SP as per requirements.
        
        INSERT INTO [dbo].[Activity] (
            [ActivityId],
            [ProjectId],
            [ProjectMemberId],
            [Name],
            [Description],
            [StartDate],
            [TargetDate],
            [EndDate],
            [ProgressStatus],
            [ActivityPoints],
            [Priority],
            [Risk],
            [Tags],
            [ActiveFlag],
            [SystemDeleteFlag],
            [CreatedDateTime],
            [CreatedByUser],
            [CreatedByProgram]
        )
        VALUES (
            @ActivityId,
            @ProjectId,
            @ProjectMemberId,
            @Name,
            @Description,
            @StartDate,
            @TargetDate,
            @EndDate,
            @ProgressStatus,
            @ActivityPoints,
            @Priority,
            @Risk,
            @Tags,
            @ActiveFlag,
            @SystemDeleteFlag,
            @CreatedDateTime,
            @CreatedByUser,
            @CreatedByProgram
        );

        -- 5. Return new timestamp if applicable
        -- SystemTimestamp is a rowversion, so we need to select it out if needed.
        DECLARE @NewSystemTimestamp VARBINARY(8);
        SELECT @NewSystemTimestamp = [SystemTimestamp] FROM [dbo].[Activity] 
        WHERE [ActivityId] = @ActivityId;

        RETURN @NewSystemTimestamp;
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

        -- Insert into Error Log
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
            -- If DbError insert fails, raise generic error
            RAISERROR ('50000', 16, 1, 'Error occurred during Insert operation.');
        END CATCH

        -- Raise Generic Error or Specific if in TRY block
        IF @ErrorNumber = 50003 OR @ErrorNumber = 50002 
            -- If validation errors happened, they are raised by THROW inside TRY.
            -- This CATCH block handles the 50000 generic case.
            THROW 50000, 'Error occurred during Insert operation.', 16;
    END CATCH
END
GO