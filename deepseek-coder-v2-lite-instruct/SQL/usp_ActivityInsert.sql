-- ============================================================
-- Procedure : [dbo].[usp_ActivityInsert]
-- Purpose   : Insert a new activity record into the Activity table.
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-01
-- ============================================================
SET NOCOUNT ON;
BEGIN TRY
    DECLARE @UpdatedDateTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @UpdatedByUser NVARCHAR(100) = SYSTEM_USER;
    DECLARE @UpdatedByProgram NVARCHAR(100) = APP_NAME();

    -- Validation checks
    IF @ActivityId IS NULL RAISERROR(50001, 16, 1, N'@ActivityId');
    IF LEN(@Name) > 128 RAISERROR(50002, 16, 1, N'@Name', 128);
    IF @ActiveFlag NOT IN (0, 1) RAISERROR(50003, 16, 1, N'@ActiveFlag', '0 or 1');
    IF @SystemDeleteFlag NOT IN ('N', 'Y') RAISERROR(50003, 16, 1, N'@SystemDeleteFlag', '''N'' or ''Y''');

    -- Insert the new activity record
    INSERT INTO [dbo].[Activity] (
        ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram
    ) VALUES (
        @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints, @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag, @UpdatedDateTime, @UpdatedByUser, @UpdatedByProgram
    );

    -- Return the newly inserted ActivityId
    SELECT ActivityId;
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
