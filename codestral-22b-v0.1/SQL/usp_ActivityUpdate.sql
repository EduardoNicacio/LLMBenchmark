-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
(
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
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp timestamp
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET ProjectId = @ProjectId, ProjectMemberId = @ProjectMemberId, Name = @Name, Description = @Description, StartDate = @StartDate, TargetDate = @TargetDate, EndDate = @EndDate, ProgressStatus = @ProgressStatus, ActivityPoints = @ActivityPoints, Priority = @Priority, Risk = @Risk, Tags = @Tags, ActiveFlag = @ActiveFlag, UpdatedDateTime = @UpdatedDateTime, UpdatedByUser = @UpdatedByUser, UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SYSTIMESTAMP = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
        )
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END
GO