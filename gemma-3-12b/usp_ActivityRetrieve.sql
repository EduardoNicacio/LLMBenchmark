CREATE PROCEDURE dbo.usp_ActivityRetrieve (
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
    @SystemDeleteFlag CHAR(1) = 'N' --Default to Not Deleted
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Input Validation for SystemDeleteFlag and ActiveFlag are not needed here.

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
        (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
        (@ProjectId IS NULL OR ProjectId = @ProjectId) AND
        (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
        (@Name IS NULL OR CHARINDEX(@Name, Name) > 0) AND
        (@Description IS NULL OR CHARINDEX(@Description, Description) > 0) AND
        (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)) AND
        (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)) AND
        (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)) AND
        (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
        (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
        (@Priority IS NULL OR Priority = @Priority) AND
        (@Risk IS NULL OR Risk = @Risk) AND
        (@Tags IS NULL OR CHARINDEX(@Tags, Tags) > 0) AND
        (@ActiveFlag = 1) AND -- Always retrieve active records.
        (@SystemDeleteFlag = 'N'); --Always retrieve non-deleted records.
END;
GO