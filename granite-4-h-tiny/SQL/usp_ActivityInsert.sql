CREATE PROCEDURE usp_[Entity]Insert
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
    @StartDate date,
    @TargetDate date,
    @EndDate date,
    @ProgressStatus tinyint,
    @ActivityPoints smallint,
    @Priority tinyint,
    @Risk tinyint,
    @Tags nvarchar(200),
    @ActiveFlag tinyint = 1, -- Default to active
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN TRY
    INSERT INTO [dbo].[Activity] (
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
    )
    VALUES (
        @ActivityId,
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
        'N', -- Assuming SystemDeleteFlag is not nullable and must be set explicitly
        GETUTCDATE(),
        @CreatedByUser,
        @CreatedByProgram
    );
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
        ERROR_MESSAGE();
END CATCH;
