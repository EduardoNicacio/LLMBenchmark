-- Stored Procedure for Update Operation
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @SystemDeleteFlag char(1),
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN TRY
    UPDATE [dbo].[Activity] 
    SET ProjectId = @ProjectId, ProjectMemberId = @ProjectMemberId, Name = @Name, Description = @Description, StartDate = @StartDate, TargetDate = @TargetDate, EndDate = @EndDate, ProgressStatus = @ProgressStatus, 
        ActivityPoints = @ActivityPoints, Priority = @Priority, Risk = @Risk, Tags = @Tags, ActiveFlag = @ActiveFlag, SystemDeleteFlag = @SystemDeleteFlag, UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()), 
        UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER), UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME()), SystemTimestamp = @SystemTimestamp
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
    END
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE();
    RAISERROR('50001', 16, 1); -- Raise error 50001 for null parameters.
END CATCH;
GO