-- usp_ActivityRetrieve
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve] (
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
    @SystemDeleteFlag char(1) = 'N' -- Default to not deleted
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation
    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag <> 0 AND @ActiveFlag <> 1)
        RAISERROR (50003, 16, 1, 'Parameter @ActiveFlag must be 0 or 1.');

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag <> 'N' AND @SystemDeleteFlag <> 'Y')
        RAISERROR (50003, 16, 1, 'Parameter @SystemDeleteFlag must be ''N'' or ''Y''.');


    BEGIN TRY
        SELECT
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
            CreatedByProgram,
            UpdatedDateTime,
            UpdatedByUser,
            UpdatedByProgram,
            SystemTimestamp
        FROM [dbo].[Activity]
        WHERE
            ( @ActivityId IS NULL OR  CHARINDEX(@ActivityId, ActivityId, 0) > 0 )
			AND ( @ProjectId IS NULL OR CHARINDEX(@ProjectId, ProjectId, 0) > 0 )
			AND ( @ProjectMemberId IS NULL OR CHARINDEX(@ProjectMemberId, ProjectMemberId, 0) > 0 )
            AND ( @Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0 )
            AND ( @Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0 )
            AND ( @StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate))
            AND ( @TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate))
            AND ( @EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))
            AND ( @ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus )
            AND ( @ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints )
            AND ( @Priority IS NULL OR Priority = @Priority )
            AND ( @Risk IS NULL OR Risk = @Risk )
            AND ( @Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0 )
            AND ActiveFlag = @ActiveFlag
            AND SystemDeleteFlag = @SystemDeleteFlag;

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() <> 0
            INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorMessage, ErrorDateTime)
            VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        RAISERROR (50000, 16, 1, 'Error occurred during ActivityRetrieve operation.');
    END CATCH;
END;
GO