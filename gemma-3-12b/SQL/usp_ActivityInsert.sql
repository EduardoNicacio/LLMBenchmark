-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert] (
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
    @CreatedByProgram nvarchar(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate Input Parameters
    IF @ProjectId IS NULL RAISERROR (50001, 16, 1, 'ProjectId')
    IF @ProjectMemberId IS NULL RAISERROR (50001, 16, 1, 'ProjectMemberId')
    IF @Name IS NULL RAISERROR (50001, 16, 1, 'Name')
    IF LEN(@Name) > 128 RAISERROR (50002, 16, 1, 'Name')
    IF @Description IS NULL RAISERROR (50001, 16, 1, 'Description')
    IF @ActiveFlag IS NULL RAISERROR (50001, 16, 1, 'ActiveFlag')
    IF @ActiveFlag NOT IN (0, 1) RAISERROR (50003, 16, 1, 'ActiveFlag')
    IF @SystemDeleteFlag IS NULL RAISERROR (50001, 16, 1, 'SystemDeleteFlag')
    IF @SystemDeleteFlag NOT IN ('N', 'Y') RAISERROR (50003, 16, 1, 'SystemDeleteFlag')
    IF @CreatedDateTime IS NULL RAISERROR (50001, 16, 1, 'CreatedDateTime')
    IF LEN(@CreatedByUser) > 100 RAISERROR (50002, 16, 1, 'CreatedByUser')
    IF LEN(@CreatedByProgram) > 100 RAISERROR (50002, 16, 1, 'CreatedByProgram')


    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
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
        ) VALUES (
            @ProjectId,
            @ProjectMemberId,
            @Name,
            @Description,
            @StartDate,
            @TargetDate,
            @EndDate,
            @ProgressStatus,
            @ActivityPoints,
            @Priority,
            @Risk,
            @Tags,
            @ActiveFlag,
            @SystemDeleteFlag,
            @CreatedDateTime,
            @CreatedByUser,
            @CreatedByProgram
        );

    END TRY
    BEGIN CATCH
        -- Log Error
        INSERT INTO dbo.DbError (ErrorTime, ApplicationName, ProcedureName, ErrorMessage)
        VALUES (GETDATE(), 'ActivityInsert', 'usp_ActivityInsert', ERROR_MESSAGE());

        -- Raise Error
        RAISERROR (50000, 16, 1, 'Error occurred during ActivityInsert operation.')
        RETURN;
    END CATCH
END;
GO