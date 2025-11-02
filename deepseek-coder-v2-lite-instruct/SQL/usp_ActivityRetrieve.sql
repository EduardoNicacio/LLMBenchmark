CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
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
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N'
AS
BEGIN TRY
    SELECT [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description], [StartDate], [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints], [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime], [CreatedByUser], [CreatedByProgram], [UpdatedDateTime], [UpdatedByUser], [UpdatedByProgram]
    FROM [dbo].[Activity]
    WHERE (CHARINDEX(@Name, [Name], 0) > 0 OR @Name IS NULL)
        AND (CHARINDEX(@Description, [Description], 0) > 0 OR @Description IS NULL)
        AND (@StartDate IS NULL OR [StartDate] >= @StartDate)
        AND (@TargetDate IS NULL OR [TargetDate] <= DATEADD(day, 1, @TargetDate))
        AND (@EndDate IS NULL OR [EndDate] >= @EndDate)
        AND (@ProgressStatus IS NULL OR [ProgressStatus] = @ProgressStatus)
        AND (@ActivityPoints IS NULL OR [ActivityPoints] = @ActivityPoints)
        AND (@Priority IS NULL OR [Priority] = @Priority)
        AND (@Risk IS NULL OR [Risk] = @Risk)
        AND (CHARINDEX(@Tags, [Tags], 0) > 0 OR @Tags IS NULL)
        AND ([ActiveFlag] = @ActiveFlag)
        AND ([SystemDeleteFlag] = @SystemDeleteFlag)
END TRY
BEGIN CATCH
    RAISERROR('Error occurred during retrieve operation.', 16, 1);
    EXEC dbo.usp_LogError; -- Assuming this procedure logs errors to DbError table
END CATCH
