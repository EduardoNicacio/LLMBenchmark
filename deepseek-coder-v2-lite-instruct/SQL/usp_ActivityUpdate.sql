CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
    @ActivityId uniqueidentifier,
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
    @UpdatedDateTime datetime2(7) = NULL OUTPUT,
    @UpdatedByUser nvarchar(100) = NULL OUTPUT,
    @UpdatedByProgram nvarchar(100) = NULL OUTPUT,
    @SystemTimestamp timestamp
AS
BEGIN TRY
    IF @ActivityId IS NULL OR (@UpdatedDateTime IS NOT NULL AND @UpdatedByUser IS NOT NULL AND @UpdatedByProgram IS NOT NULL AND @SystemTimestamp IS NOT NULL)
        RAISERROR('50001', 16, 1) -- Null parameter error

    SELECT @UpdatedDateTime = SYSUTCDATETIME(), @UpdatedByUser = SYSTEM_USER, @UpdatedByProgram = APP_NAME() WHERE @UpdatedDateTime IS NULL OR @UpdatedByUser IS NULL OR @UpdatedByProgram IS NULL;

    DECLARE @CurrentSystemTimestamp timestamp;
    SELECT @CurrentSystemTimestamp = SystemTimestamp FROM [dbo].[Activity] WHERE ActivityId = @ActivityId;

    IF @CurrentSystemTimestamp != @SystemTimestamp
        RAISERROR('50004', 16, 1) -- Optimistic lock violation

    UPDATE [dbo].[Activity] SET
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
        UpdatedDateTime = @UpdatedDateTime,
        UpdatedByUser = @UpdatedByUser,
        UpdatedByProgram = @UpdatedByProgram
    WHERE ActivityId = @ActivityId;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50001 OR ERROR_NUMBER() = 50004
        RAISERROR('Error occurred during update operation.', 16, 1);
    ELSE
        EXEC dbo.usp_LogError; -- Assuming this procedure logs errors to DbError table
END CATCH
