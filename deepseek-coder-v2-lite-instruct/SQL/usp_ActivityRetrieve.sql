-- Stored Procedure for Retrieve Operation
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
    @SystemDeleteFlag char(1) = 'N',
    @CreatedDateTime datetime2(7) = NULL,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL
AS
BEGIN TRY
    SELECT 
        ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate, ProgressStatus, 
        ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, UpdatedDateTime, UpdatedByUser, UpdatedByProgram
    FROM [dbo].[Activity]
    WHERE 
        (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
        (@ProjectId IS NULL OR ProjectId = @ProjectId) AND
        (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
        (@Name IS NULL OR Name LIKE '%' + @Name + '%') AND
        (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0) AND
        (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)) AND
        (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)) AND
        (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)) AND
        (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
        (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
        (@Priority IS NULL OR Priority = @Priority) AND
        (@Risk IS NULL OR Risk = @Risk) AND
        (@Tags IS NULL OR Tags LIKE '%' + @Tags + '%') AND
        (ActiveFlag = 1) AND
        (SystemDeleteFlag = 'N') AND
        (@CreatedDateTime IS NULL OR CreatedDateTime >= @CreatedDateTime AND CreatedDateTime < DATEADD(day, 1, @CreatedDateTime)) AND
        (@UpdatedDateTime IS NULL OR UpdatedDateTime = @UpdatedDateTime) AND
        (@UpdatedByUser IS NULL OR UpdatedByUser = @UpdatedByUser) AND
        (@UpdatedByProgram IS NULL OR UpdatedByProgram = @UpdatedByProgram);
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE();
    RAISERROR('50001', 16, 1); -- Raise error 50001 for null parameters.
END CATCH;
GO