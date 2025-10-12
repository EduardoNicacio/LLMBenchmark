-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
(
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
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram, UpdatedDateTime, UpdatedByUser, UpdatedByProgram
        )
        VALUES (
            NEWID(), @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints, @Priority, @Risk, @Tags, @ActiveFlag, 'N', @CreatedDateTime, @CreatedByUser, @CreatedByProgram, NULL, NULL, NULL
        );
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