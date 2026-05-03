-- ============================================================
-- Procedure : [dbo].[usp_ActivityUpdate]
-- Purpose   : Updates an existing Activity record
-- Author    : Eduardo Nicacio
-- Created   : 2025-06-15
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @SystemTimestamp TIMESTAMP
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Set defaults
DECLARE @UpdatedDateTime DATETIME2(7) = SYSUTCDATETIME();
DECLARE @UpdatedByUser NVARCHAR(100) = SYSTEM_USER;
DECLARE @UpdatedByProgram NVARCHAR(100) = APP_NAME();

-- Validation
IF @ActivityId IS NULL
    RAISERROR(N'ActivityId is required and cannot be NULL.', 16, 1) WITH LOG;

IF LEN(@Name) > 128
    RAISERROR(N'Name exceeds the maximum allowed length of 128 characters.', 16, 1) WITH LOG;

IF LEN(@Description) > 4000
    RAISERROR(N'Description exceeds the maximum allowed length of 4000 characters.', 16, 1) WITH LOG;

IF @ActiveFlag NOT IN (0, 1)
    RAISERROR(N'Invalid value for ActiveFlag. Allowed values are: 0, 1.', 16, 1) WITH LOG;

IF @SystemDeleteFlag NOT IN ('N', 'Y')
    RAISERROR(N'Invalid value for SystemDeleteFlag. Allowed values are: N, Y.', 16, 1) WITH LOG;

BEGIN TRY
    UPDATE [dbo].[Activity]
    SET 
        [ProjectId] = @ProjectId,
        [ProjectMemberId] = @ProjectMemberId,
        [Name] = @Name,
        [Description] = @Description,
        [StartDate] = @StartDate,
        [TargetDate] = @TargetDate,
        [EndDate] = @EndDate,
        [ProgressStatus] = @ProgressStatus,
        [ActivityPoints] = @ActivityPoints,
        [Priority] = @Priority,
        [Risk] = @Risk,
        [Tags] = @Tags,
        [ActiveFlag] = @ActiveFlag,
        [SystemDeleteFlag] = @SystemDeleteFlag,
        [UpdatedDateTime] = @UpdatedDateTime,
        [UpdatedByUser] = @UpdatedByUser,
        [UpdatedByProgram] = @UpdatedByProgram
    WHERE 
        [ActivityId] = @ActivityId
        AND [SystemTimestamp] = @SystemTimestamp;

    IF @@ROWCOUNT = 0
        RAISERROR(50004, 16, 1) WITH LOG;
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

    RAISERROR(50000, 16, 1, N'Error occurred during Update operation.');
END CATCH;
RETURN;
