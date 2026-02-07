CREATE PROCEDURE usp_ActivityRetrieve
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
    @ActiveFlag tinyint = 1, -- Default to 1
    @SystemDeleteFlag char(1) = 'N' -- Default to 'N'
AS
BEGIN
    SET NOCOUNT ON;
    
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
            CreatedByProgram
        FROM dbo.Activity
        WHERE 
            (@ActivityId IS NULL OR CHARINDEX(@ActivityId, ActivityId) > 0)
           AND (@ProjectId IS NULL OR CHARINDEX(@ProjectId, ProjectId) > 0)
           AND (@ProjectMemberId IS NULL OR CHARINDEX(@ProjectMemberId, ProjectMemberId) > 0)
           AND (@Name IS NULL OR CHARINDEX(@Name, Name) > 0)
           AND (@Description IS NULL OR CHARINDEX(@Description, Description) > 0)
           AND (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate))
           AND (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate))
           AND (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))
           AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
           AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
           AND (@Priority IS NULL OR Priority = @Priority)
           AND (@Risk IS NULL OR Risk = @Risk)
           AND (@Tags IS NULL OR CHARINDEX(@Tags, Tags) > 0)
           AND ActiveFlag = @ActiveFlag
           AND SystemDeleteFlag <> @SystemDeleteFlag;
           
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorTime)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), SYSDATETIME());
        
        THROW 50000, 'Error occurred during Retrieve operation.', 1;
    END CATCH
END
GO