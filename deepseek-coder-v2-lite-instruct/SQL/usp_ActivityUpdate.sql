-- ============================================================
-- Procedure : [dbo].[usp_ActivityUpdate]
-- Purpose   : Update an existing activity record in the Activity table.
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
    -- Add more validation rules as needed...

    UPDATE [dbo].[Activity]
    SET ProjectId = @ProjectId, ProjectMemberId = @ProjectMemberId, Name = @Name, Description = @Description, StartDate = @StartDate, TargetDate = @TargetDate, EndDate = @EndDate, ProgressStatus = @ProgressStatus,
        ActivityPoints = @ActivityPoints, Priority = @Priority, Risk = @Risk, Tags = @Tags, ActiveFlag = @ActiveFlag, UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    IF @@ROWCOUNT = 0 RAISERROR(50004, 16, 1);
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SYSUTCDATETIME());
    RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityUpdate operation.');
END CATCH;
