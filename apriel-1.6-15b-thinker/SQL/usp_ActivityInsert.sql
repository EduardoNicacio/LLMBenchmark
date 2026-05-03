-- ============================================================
-- Procedure : [dbo].[usp_ActivityInsert]
-- Purpose   : Insert a new Activity row and return its ID.
-- Author    : Eduardo Nicacio
-- Created   : 2025-09-05
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId        uniqueidentifier,
    @ProjectId         uniqueidentifier,
    @ProjectMemberId   uniqueidentifier,
    @Name              nvarchar(128),
    @Description       nvarchar(4000),
    @StartDate         date = NULL,
    @TargetDate        date = NULL,
    @EndDate           date = NULL,
    @ProgressStatus    tinyint = NULL,
    @ActivityPoints    smallint = NULL,
    @Priority          tinyint = NULL,
    @Risk              tinyint = NULL,
    @Tags              nvarchar(200) = NULL,
    @ActiveFlag        tinyint,
    @SystemDeleteFlag  char(1),
    @CreatedDateTime   datetime2(7),
    @CreatedByUser     nvarchar(100),
    @CreatedByProgram  nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validation: required parameters not null
    IF @ActivityId IS NULL
        RAISERROR(50001, 16, 1, N'ActivityId is required and cannot be NULL.');
        RETURN;
    IF @ProjectId IS NULL
        RAISERROR(50001, 16, 1, N'ProjectId is required and cannot be NULL.');
        RETURN;
    IF @ProjectMemberId IS NULL
        RAISERROR(50001, 16, 1, N'ProjectMemberId is required and cannot be NULL.');
        RETURN;
    IF @Name IS NULL
        RAISERROR(50001, 16, 1, N'Name is required and cannot be NULL.');
        RETURN;
    IF @Description IS NULL
        RAISERROR(50001, 16, 1, N'Description is required and cannot be NULL.');
        RETURN;
    IF @ActiveFlag IS NULL
        RAISERROR(50001, 16, 1, N'ActiveFlag is required and cannot be NULL.');
        RETURN;
    IF @SystemDeleteFlag IS NULL
        RAISERROR(50001, 16, 1, N'SystemDeleteFlag is required and cannot be NULL.');
        RETURN;
    IF @CreatedDateTime IS NULL
        RAISERROR(50001, 16, 1, N'CreatedDateTime is required and cannot be NULL.');
        RETURN;
    IF @CreatedByUser IS NULL
        RAISERROR(50001, 16, 1, N'CreatedByUser is required and cannot be NULL.');
        RETURN;
    IF @CreatedByProgram IS NULL
        RAISERROR(50001, 16, 1, N'CreatedByProgram is required and cannot be NULL.');
        RETURN;

    -- Validation: length constraints
    IF LEN(@Name) > 128
        RAISERROR(50002, 16, 1, N'Name exceeds the maximum allowed length of 128 characters.');
        RETURN;
    IF LEN(@Description) > 4000
        RAISERROR(50002, 16, 1, N'Description exceeds the maximum allowed length of 4000 characters.');
        RETURN;
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        RAISERROR(50002, 16, 1, N'Tags exceeds the maximum allowed length of 200 characters.');
        RETURN;
    IF LEN(@CreatedByUser) > 100
        RAISERROR(50002, 16, 1, N'CreatedByUser exceeds the maximum allowed length of 100 characters.');
        RETURN;
    IF LEN(@CreatedByProgram) > 100
        RAISERROR(50002, 16, 1, N'CreatedByProgram exceeds the maximum allowed length of 100 characters.');
        RETURN;

    -- Validation: flag values
    IF @ActiveFlag NOT IN (0,1)
        RAISERROR(50003, 16, 1, N'Invalid value for ActiveFlag. Allowed values are: 0, 1.');
        RETURN;
    IF @SystemDeleteFlag NOT IN (N'N', N'Y')
        RAISERROR(50003, 16, 1, N'Invalid value for SystemDeleteFlag. Allowed values are: N, Y.');
        RETURN;

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            ActivityId, ProjectId, ProjectMemberId, Name, Description,
            StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints,
            Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag,
            CreatedDateTime, CreatedByUser, CreatedByProgram
        )
        VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
            @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
            @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram
        );

        SELECT @ActivityId AS ActivityId;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError]
            (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
        VALUES
            (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
             ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
             SYSUTCDATETIME());
        RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityInsert operation.');
    END CATCH;
END
GO
