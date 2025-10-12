-- Stored Procedure for Insert Operation
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
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
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN TRY
    INSERT INTO [dbo].[Activity] (
        ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate, ProgressStatus, 
        ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram, 
        UpdatedDateTime, UpdatedByUser, UpdatedByProgram, SystemTimestamp
    ) VALUES (
        @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate, @TargetDate, @EndDate, @ProgressStatus, 
        @ActivityPoints, @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag, @CreatedDateTime, @CreatedByUser, @CreatedByProgram, 
        NULL, NULL, NULL, NULL
    );
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