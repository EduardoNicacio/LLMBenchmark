-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate] (
    @ActivityId uniqueidentifier = NULL,
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
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation
    IF @ActivityId IS NULL
        RAISERROR (50001, 16, 1, 'Parameter @ActivityId cannot be null.');

	IF @UpdatedDateTime IS NULL
		RAISERROR(50001, 16, 1, "Parameter @UpdatedDateTime cannot be null.");

    IF LEN(@Name) > 128 AND @Name IS NOT NULL
        RAISERROR (50002, 16, 1, 'Parameter @Name exceeds maximum length of 128.');

    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag <> 0 AND @ActiveFlag <> 1)
        RAISERROR (50003, 16, 1, 'Parameter @ActiveFlag must be 0 or 1.');

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag <> 'N' AND @SystemDeleteFlag <> 'Y')
        RAISERROR (50003, 16, 1, 'Parameter @SystemDeleteFlag must be ''N'' or ''Y''.');


    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET
            ProjectId = ISNULL(@ProjectId, ProjectId),
            ProjectMemberId = ISNULL(@ProjectMemberId, ProjectMemberId),
            Name = ISNULL(@Name, Name),
            Description = ISNULL(@Description, Description),
            StartDate = ISNULL(@StartDate, StartDate),
            TargetDate = ISNULL(@TargetDate, TargetDate),
            EndDate = ISNULL(@EndDate, EndDate),
            ProgressStatus = ISNULL(@ProgressStatus, ProgressStatus),
            ActivityPoints = ISNULL(@ActivityPoints, ActivityPoints),
            Priority = ISNULL(@Priority, Priority),
            Risk = ISNULL(@Risk, Risk),
            Tags = ISNULL(@Tags, Tags),
            ActiveFlag = ISNULL(@ActiveFlag, ActiveFlag),
            SystemDeleteFlag = ISNULL(@SystemDeleteFlag, SystemDeleteFlag),
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE
            ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

		IF @@ROWCOUNT = 0
			RAISERROR(50004,16,1,"Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.");

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() <> 0
            INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorMessage, ErrorDateTime)
            VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        RAISERROR (50000, 16, 1, 'Error occurred during ActivityUpdate operation.');
    END CATCH;
END;
GO