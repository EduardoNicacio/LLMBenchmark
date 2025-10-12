-- usp_ActivityRetrieve
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
(
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
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N',
    @CreatedDateTime datetime2(7) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM [dbo].[Activity]
    WHERE (ProjectId = @ProjectId OR @ProjectId IS NULL)
        AND (ProjectMemberId = @ProjectMemberId OR @ProjectMemberId IS NULL)
        AND (@Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0)
        AND (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0)
        AND (StartDate = @StartDate OR @StartDate IS NULL)
        AND (TargetDate = @TargetDate OR @TargetDate IS NULL)
        AND (EndDate = @EndDate OR @EndDate IS NULL)
        AND (ProgressStatus = @ProgressStatus OR @ProgressStatus IS NULL)
        AND (ActivityPoints = @ActivityPoints OR @ActivityPoints IS NULL)
        AND (Priority = @Priority OR @Priority IS NULL)
        AND (Risk = @Risk OR @Risk IS NULL)
        AND (@Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0)
        AND ActiveFlag = @ActiveFlag
        AND SystemDeleteFlag = @SystemDeleteFlag
        AND (@CreatedDateTime IS NULL OR CreatedDateTime >= @CreatedDateTime AND CreatedDateTime < DATEADD(day, 1, @CreatedDateTime));
END
GO