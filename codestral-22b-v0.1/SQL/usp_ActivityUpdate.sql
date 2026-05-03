-- ============================================================
-- Procedure : [dbo].[usp_ActivityUpdate]
-- Purpose   : Updates an existing activity in the Activity table
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-19
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityUpdate]
(
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
    @Date date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N',
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp binary(8)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Input validation
    IF @ActivityId IS NULL
        RAISERROR(50001, 16, 1, N'@ActivityId is required and cannot be NULL.');
    IF @ProjectId IS NULL
        RAISERROR(50001, 16, 1, N'@ProjectId is required and cannot be NULL.');
    IF @ProjectMemberId IS NULL
        RAISERROR(50001, 16, 1, N'@ProjectMemberId is required and cannot be NULL.');
    IF @Name IS NULL
        RAISERROR(50001, 16, 1, N'@Name is required and cannot be NULL.');
    IF LEN(@Name) > 128
        RAISERROR(50002, 16, 1, N'@Name exceeds the maximum allowed length of 128 characters.');
    IF @Description IS NULL
        RAISERROR(50001, 16, 1, N'@Description is required and cannot be NULL.');
    IF LEN(@Description) > 4000
        RAISERROR(50002, 16, 1, N'@Description exceeds the maximum allowed length of 4000 characters.');
    IF @ActiveFlag NOT IN (0, 1)
        RAISERROR(50003, 16, 1, N'Invalid value for @ActiveFlag. Allowed values are: 0, 1.');
    IF @SystemDeleteFlag NOT IN ('N', 'Y')
        RAISERROR(50003, 16, 1, N'Invalid value for @SystemDeleteFlag. Allowed values are: ''N'', ''Y''.');

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET ProjectId = @ProjectId, ProjectMemberId = @ProjectMemberId, Name = @Name, Description = @Description, Date = @Date, TargetDate = @TargetDate, EndDate = @EndDate, ProgressStatus = @ProgressStatus, ActivityPoints = @ActivityPoints, Priority = @Priority, Risk = @Risk, Tags = @Tags, ActiveFlag = @ActiveFlag, SystemDeleteFlag = @SystemDeleteFlag, UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR(50004, 16, 1, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime
        ) VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SYSUTCDATETIME()
        );
        RAISERROR(50000, 16, 1, N'Error occurred during Update operation.');
    END CATCH;
END;
