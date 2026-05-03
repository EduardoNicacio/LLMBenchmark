-- ============================================================
-- Procedure : [dbo].[usp_ActivityInsert]
-- Purpose   : Inserts a new Activity record
-- Author    : Eduardo Nicacio
-- Created   : 2025-06-15
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Validation
IF @ActivityId IS NULL
    RAISERROR(N'ActivityId is required and cannot be NULL.', 16, 1) WITH LOG;

IF @ProjectId IS NULL
    RAISERROR(N'ProjectId is required and cannot be NULL.', 16, 1) WITH LOG;

IF @ProjectMemberId IS NULL
    RAISERROR(N'ProjectMemberId is required and cannot be NULL.', 16, 1) WITH LOG;

IF LEN(@Name) > 128
    RAISERROR(N'Name exceeds the maximum allowed length of 128 characters.', 16, 1) WITH LOG;

IF LEN(@Description) > 4000
    RAISERROR(N'Description exceeds the maximum allowed length of 4000 characters.', 16, 1) WITH LOG;

IF @ActiveFlag NOT IN (0, 1)
    RAISERROR(N'Invalid value for ActiveFlag. Allowed values are: 0, 1.', 16, 1) WITH LOG;

IF @SystemDeleteFlag NOT IN ('N', 'Y')
    RAISERROR(N'Invalid value for SystemDeleteFlag. Allowed values are: N, Y.', 16, 1) WITH LOG;

BEGIN TRY
    INSERT INTO [dbo].[Activity] (
        [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description],
        [StartDate], [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints],
        [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag],
        [CreatedDateTime], [CreatedByUser], [CreatedByProgram], [SystemTimestamp]
    ) VALUES (
        @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
        @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
        @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
        @CreatedDateTime, @CreatedByUser, @CreatedByProgram, SYSUTCDATETIME()
    );

    SELECT @ActivityId AS [ActivityId];
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure],
        [ErrorLine], [ErrorMessage], [ErrorDateTime]
    ) VALUES (
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
        ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
        SYSUTCDATETIME()
    );

    RAISERROR(50000, 16, 1, N'Error occurred during Insert operation.');
END CATCH;
RETURN;
