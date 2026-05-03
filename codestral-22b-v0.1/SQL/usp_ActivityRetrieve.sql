-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieve]
-- Purpose   : Retrieves an activity from the Activity table based on filter criteria
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-19
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieve]
(
    @ActivityId uniqueidentifier = NULL,
    @ProjectId uniqueidentifier = NULL,
    @ProjectMemberId uniqueidentifier = NULL,
    @Name nvarchar(128) = NULL,
    @Description nvarchar(4000) = NULL,
    @Date date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N'
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ActivityId, ProjectId, ProjectMemberId, Name, Description, Date, TargetDate, EndDate, ProgressStatus, ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram, UpdatedDateTime, UpdatedByUser, UpdatedByProgram
    FROM [dbo].[Activity] WITH (NOLOCK)
    WHERE (@ActivityId IS NULL OR ActivityId = @ActivityId)
        AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
        AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
        AND (@Name IS NULL OR Name LIKE '%' + @Name + '%')
        AND (@Description IS NULL OR Description LIKE '%' + @Description + '%')
        AND ((@Date IS NULL OR (Date >= @Date AND Date < DATEADD(day, 1, @Date)))
            AND (@TargetDate IS NULL OR (TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)))
            AND (@EndDate IS NULL OR (EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))))
        AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
        AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
        AND (@Priority IS NULL OR Priority = @Priority)
        AND (@Risk IS NULL OR Risk = @Risk)
        AND (@Tags IS NULL OR Tags LIKE '%' + @Tags + '%')
        AND ActiveFlag = @ActiveFlag
        AND SystemDeleteFlag = @SystemDeleteFlag;
END;
