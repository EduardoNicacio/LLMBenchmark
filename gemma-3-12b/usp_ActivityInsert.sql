CREATE PROCEDURE dbo.usp_ActivityInsert (
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
    @CreatedDateTime DATETIME2(7) = SYSUTCDATETIME(),
    @CreatedByUser NVARCHAR(100) = SYSTEM_USER,
    @CreatedByProgram NVARCHAR(100) = APP_NAME()
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

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            ActivityId,
            ProjectId,
            ProjectMemberId,
            Name,
            Description,
            StartDate,
            TargetDate,
            EndDate,
            ProgressStatus,
            ActivityPoints,
            Priority,
            Risk,
            Tags,
            ActiveFlag,
            SystemDeleteFlag,
            CreatedDateTime,
            CreatedByUser,
            CreatedByProgram
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

        THROW; -- Re-raise the error to be handled by the calling application.
    END CATCH
END;
GO