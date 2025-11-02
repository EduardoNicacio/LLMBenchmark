CREATE PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint,
    @SystemDeleteFlag char(1),
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN TRY
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL OR @CreatedDateTime IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
        RAISERROR('50001', 16, 1) -- Null parameter error
    IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100
        RAISERROR('50002', 16, 1) -- String length error
    IF @ActiveFlag NOT IN (0, 1) OR @SystemDeleteFlag NOT IN ('N', 'Y')
        RAISERROR('50003', 16, 1) -- Invalid flag error

    INSERT INTO [dbo].[Activity] (
        ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram
    ) VALUES (
        @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints, @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag, @CreatedDateTime, @CreatedByUser, @CreatedByProgram
    );
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50001 OR ERROR_NUMBER() = 50002 OR ERROR_NUMBER() = 50003
        RAISERROR('Error occurred during insert operation.', 16, 1);
    ELSE
        EXEC dbo.usp_LogError; -- Assuming this procedure logs errors to DbError table
END CATCH
