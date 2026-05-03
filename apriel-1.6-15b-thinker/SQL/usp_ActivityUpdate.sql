-- ============================================================
-- Procedure : [dbo].[usp_ActivityUpdate]
-- Purpose   : Update an existing Activity row with optimistic locking.
-- Author    : Eduardo Nicacio
-- Created   : 2025-09-05
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @UpdatedDateTime   datetime2(7) = NULL,
    @UpdatedByUser     nvarchar(100) = NULL,
    @UpdatedByProgram  nvarchar(100) = NULL,
    @SystemTimestamp   binary(8)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Default assignments for audit columns
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

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

    -- Validation: flag values
    IF @ActiveFlag NOT IN (0,1)
        RAISERROR(50003, 16, 1, N'Invalid value for ActiveFlag. Allowed values are: 0, 1.');
        RETURN;
    IF @SystemDeleteFlag NOT IN (N'N', N'Y')
        RAISERROR(50003, 16, 1, N'Invalid value for SystemDeleteFlag. Allowed values are: N, Y.');
        RETURN;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET ProjectId = @ProjectId,
            ProjectMemberId = @ProjectMemberId,
            Name = @Name,
            Description = @Description,
            StartDate = @StartDate,
            TargetDate = @TargetDate,
            EndDate = @EndDate,
            ProgressStatus = @ProgressStatus,
            ActivityPoints = @ActivityPoints,
            Priority = @Priority,
            Risk = @Risk,
            Tags = @Tags,
            ActiveFlag = @ActiveFlag,
            SystemDeleteFlag = @SystemDeleteFlag,
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR(50004, 16, 1, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError]
            (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
        VALUES
            (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
             ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
             SYSUTCDATETIME());
        RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityUpdate operation.');
    END CATCH;
END
GO
