CREATE PROCEDURE dbo.usp_ActivityUpdate (
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1, -- Default to Active
    @SystemDeleteFlag CHAR(1) = 'N', -- Default to Not Deleted
    @UpdatedDateTime DATETIME2(7) = SYSUTCDATETIME(),
    @UpdatedByUser NVARCHAR(100) = SYSTEM_USER,
    @UpdatedByProgram NVARCHAR(100) = APP_NAME(),
    @SystemTimestamp IMAGE = NULL  -- Use IMAGE for timestamp
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation
    IF @ActivityId IS NULL RAISERROR (50001, 16, 1, 'ActivityId is required.');
    IF LEN(@Name) > 128 RAISERROR (50002, 16, 1, 'Name exceeds maximum length of 128.');
    IF LEN(@Description) > 4000 RAISERROR (50002, 16, 1, 'Description exceeds maximum length of 4000.');
    IF @ActiveFlag NOT IN (0, 1) RAISERROR (50003, 16, 1, 'Invalid ActiveFlag value. Must be 0 or 1.');
    IF @SystemDeleteFlag NOT IN ('N', 'Y') RAISERROR (50003, 16, 1, 'Invalid SystemDeleteFlag value. Must be N or Y.');
    IF LEN(@UpdatedByUser) > 100 RAISERROR (50002, 16, 1, 'UpdatedByUser exceeds maximum length of 100.');
    IF LEN(@UpdatedByProgram) > 100 RAISERROR (50002, 16, 1, 'UpdatedByProgram exceeds maximum length of 100.');

    -- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram if null
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    BEGIN TRY
        -- Optimistic Lock Verification
        IF EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp)
        BEGIN
            RAISERROR (50004, 16, 1, 'Operation failed because another user has updated or deleted this [Entity]. Your changes have been lost. Please review their changes before trying again.');
            RETURN; -- Exit the stored procedure
        END

        UPDATE [dbo].[Activity]
        SET
            ProjectId = @ProjectId,
            ProjectMemberId = @ProjectMemberId,
            Name = @Name,
            Description = @Description,
            StartDate = @StartDate,
            TargetDate = @TargetDate,
            EndDate = @EndDate,
            ProgressStatus = @ProgressStatus,
            ActivityPoints = @ActivityPoints,
            Priority = @Priority,
            Risk = @Risk,
            Tags = @Tags,
            ActiveFlag = @ActiveFlag,
            SystemDeleteFlag = @SystemDeleteFlag,
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE
            ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

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

        THROW; -- Re-raise the error to be handled by the calling application.
    END CATCH
END;
GO