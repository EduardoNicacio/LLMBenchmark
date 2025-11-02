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
    @ActiveFlag tinyint = NULL,
    @SystemDeleteFlag char(1) = NULL,
    @CreatedDateTime datetime2(7) = NULL,
    @CreatedByUser nvarchar(100) = NULL,
    @CreatedByProgram nvarchar(100) = NULL,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate Input Parameters
    IF @ActiveFlag IS NULL
        SET @ActiveFlag = 1; -- Default to active records
    IF @SystemDeleteFlag IS NULL
        SET @SystemDeleteFlag = 'N'; -- Default to non-deleted records

    IF @ActiveFlag NOT IN (0, 1) RAISERROR (50003, 16, 1, 'ActiveFlag')
    IF @SystemDeleteFlag NOT IN ('N', 'Y') RAISERROR (50003, 16, 1, 'SystemDeleteFlag')

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
        WHERE ActiveFlag = @ActiveFlag
          AND SystemDeleteFlag = @SystemDeleteFlag
          AND (@ActivityId IS NULL OR ActivityId = @ActivityId)
          AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
          AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
          AND (@Name IS NULL OR (@Name IS NOT NULL AND CHARINDEX(@Name, Name, 0) > 0))
          AND (@Description IS NULL OR (@Description IS NOT NULL AND CHARINDEX(@Description, Description, 0) > 0))
          AND (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate))
          AND (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate))
          AND (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))
          AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
          AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
          AND (@Priority IS NULL OR Priority = @Priority)
          AND (@Risk IS NULL OR Risk = @Risk)
          AND (@Tags IS NULL OR (@Tags IS NOT NULL AND CHARINDEX(@Tags, Tags, 0) > 0))
          AND (@CreatedDateTime IS NULL OR CreatedDateTime = @CreatedDateTime)
          AND (@CreatedByUser IS NULL OR CreatedByUser = @CreatedByUser)
          AND (@CreatedByProgram IS NULL OR CreatedByProgram = @CreatedByProgram)
          AND (@UpdatedDateTime IS NULL OR UpdatedDateTime = @UpdatedDateTime)
          AND (@UpdatedByUser IS NULL OR UpdatedByUser = @UpdatedByUser)
          AND (@UpdatedByProgram IS NULL OR UpdatedByProgram = @UpdatedByProgram);

    END TRY
    BEGIN CATCH
        -- Log Error
        INSERT INTO dbo.DbError (ErrorTime, ApplicationName, ProcedureName, ErrorMessage)
        VALUES (GETDATE(), 'ActivityRetrieve', 'usp_ActivityRetrieve', ERROR_MESSAGE());

        -- Raise Error
        RAISERROR (50000, 16, 1, 'Error occurred during ActivityRetrieve operation.')
        RETURN;
    END CATCH
END;
GO