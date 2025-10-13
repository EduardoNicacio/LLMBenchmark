-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert] (
    @ProjectId uniqueidentifier = NULL,
    @ProjectMemberId uniqueidentifier = NULL,
    @Name nvarchar(128) = NULL,
    @Description nvarchar(4000) = NULL,
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1, -- Default to active
    @SystemDeleteFlag char(1) = 'N', -- Default to not deleted
    @CreatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @CreatedByUser nvarchar(100) = SYSTEM_USER,
    @CreatedByProgram nvarchar(100) = APP_NAME()
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation
    IF @Name IS NULL
        RAISERROR (50001, 16, 1, 'Parameter @Name cannot be null.');

	IF LEN(@Name) > 128
		RAISERROR(50002, 16, 1, "Parameter @Name exceeds maximum length of 128.");

    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag <> 0 AND @ActiveFlag <> 1)
        RAISERROR (50003, 16, 1, 'Parameter @ActiveFlag must be 0 or 1.');

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag <> 'N' AND @SystemDeleteFlag <> 'Y')
        RAISERROR (50003, 16, 1, 'Parameter @SystemDeleteFlag must be ''N'' or ''Y''.');


    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
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

		-- Return the ActivityId of newly inserted record.
		SELECT SCOPE_IDENTITY();

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() <> 0
            INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorMessage, ErrorDateTime)
            VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        RAISERROR (50000, 16, 1, 'Error occurred during ActivityInsert operation.');
    END CATCH;
END;
GO
