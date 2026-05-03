-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieve]
-- Purpose   : Retrieve Activity rows with flexible filtering.
-- Author    : Eduardo Nicacio
-- Created   : 2025-09-05
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
    @ActivityId        uniqueidentifier = NULL,
    @ProjectId         uniqueidentifier = NULL,
    @ProjectMemberId   uniqueidentifier = NULL,
    @Name              nvarchar(128) = NULL,
    @Description       nvarchar(4000) = NULL,
    @StartDate         date = NULL,
    @TargetDate        date = NULL,
    @EndDate           date = NULL,
    @ProgressStatus    tinyint = NULL,
    @ActivityPoints    smallint = NULL,
    @Priority          tinyint = NULL,
    @Risk              tinyint = NULL,
    @Tags              nvarchar(200) = NULL,
    @ActiveFlag        tinyint = 1,
    @SystemDeleteFlag  char(1) = N'N',
    @CreatedDateTime   datetime2(7) = NULL,
    @CreatedByUser     nvarchar(100) = NULL,
    @CreatedByProgram  nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [dbo].[Activity].ActivityId, [dbo].[Activity].ProjectId, [dbo].[Activity].ProjectMemberId,
           [dbo].[Activity].Name, [dbo].[Activity].Description, [dbo].[Activity].StartDate,
           [dbo].[Activity].TargetDate, [dbo].[Activity].EndDate, [dbo].[Activity].ProgressStatus,
           [dbo].[Activity].ActivityPoints, [dbo].[Activity].Priority, [dbo].[Activity].Risk,
           [dbo].[Activity].Tags, [dbo].[Activity].ActiveFlag, [dbo].[Activity].SystemDeleteFlag,
           [dbo].[Activity].CreatedDateTime, [dbo].[Activity].CreatedByUser, [dbo].[Activity].CreatedByProgram,
           [dbo].[Activity].UpdatedDateTime, [dbo].[Activity].UpdatedByUser, [dbo].[Activity].UpdatedByProgram,
           [dbo].[Activity].SystemTimestamp
    FROM [dbo].[Activity] WITH (NOLOCK)
    WHERE
        (@ActivityId IS NULL OR [dbo].[Activity].ActivityId = @ActivityId) AND
        (@ProjectId IS NULL OR [dbo].[Activity].ProjectId = @ProjectId) AND
        (@ProjectMemberId IS NULL OR [dbo].[Activity].ProjectMemberId = @ProjectMemberId) AND
        (@Name IS NULL OR CHARINDEX(@Name, [dbo].[Activity].Name, 0) > 0) AND
        (@Description IS NULL OR CHARINDEX(@Description, [dbo].[Activity].Description, 0) > 0) AND
        (@Tags IS NULL OR CHARINDEX(@Tags, [dbo].[Activity].Tags, 0) > 0) AND
        (@StartDate IS NULL OR ([dbo].[Activity].StartDate >= @StartDate AND [dbo].[Activity].StartDate < DATEADD(day, 1, @StartDate))) AND
        (@TargetDate IS NULL OR ([dbo].[Activity].TargetDate >= @TargetDate AND [dbo].[Activity].TargetDate < DATEADD(day, 1, @TargetDate))) AND
        (@EndDate IS NULL OR ([dbo].[Activity].EndDate >= @EndDate AND [dbo].[Activity].EndDate < DATEADD(day, 1, @EndDate))) AND
        (@ProgressStatus IS NULL OR [dbo].[Activity].ProgressStatus = @ProgressStatus) AND
        (@ActivityPoints IS NULL OR [dbo].[Activity].ActivityPoints = @ActivityPoints) AND
        (@Priority IS NULL OR [dbo].[Activity].Priority = @Priority) AND
        (@Risk IS NULL OR [dbo].[Activity].Risk = @Risk) AND
        (@ActiveFlag IS NULL OR [dbo].[Activity].ActiveFlag = @ActiveFlag) AND
        (@SystemDeleteFlag IS NULL OR [dbo].[Activity].SystemDeleteFlag = @SystemDeleteFlag);
END
GO
