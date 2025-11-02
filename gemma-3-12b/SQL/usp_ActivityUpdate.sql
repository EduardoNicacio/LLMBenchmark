-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate] (
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
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate Input Parameters
    IF @ActivityId IS NULL RAISERROR (50001, 16, 1, 'ActivityId')
    IF LEN(@Name) > 128 RAISERROR (50002, 16, 1, 'Name')
    IF LEN(@UpdatedByUser) > 100 RAISERROR (50002, 16, 1, 'UpdatedByUser')
    IF LEN(@UpdatedByProgram) > 100 RAISERROR (50002, 16, 1, 'UpdatedByProgram')
    IF @ActiveFlag IS NULL RAISERROR (50001, 16, 1, 'ActiveFlag')
    IF @ActiveFlag NOT IN (0, 1) RAISERROR (50003, 16, 1, 'ActiveFlag')
    IF @SystemDeleteFlag IS NULL RAISERROR (50001, 16, 1, 'SystemDeleteFlag')
    IF @SystemDeleteFlag NOT IN ('N', 'Y') RAISERROR (50003, 16, 1, 'SystemDeleteFlag')

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET ProjectId = ISNULL(@ProjectId, ProjectId),
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
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        -- Log Error
        IF ERROR_NUMBER() = 2627 -- Optimistic Lock Violation (Concurrency Failure)
            RAISERROR (50004, 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.')
        ELSE
            INSERT INTO dbo.DbError (ErrorTime, ApplicationName, ProcedureName, ErrorMessage)
            VALUES (GETDATE(), 'ActivityUpdate', 'usp_ActivityUpdate', ERROR_MESSAGE());

        -- Raise Error
        RAISERROR (50000, 16, 1, 'Error occurred during ActivityUpdate operation.')
        RETURN;
    END CATCH
END;
GO