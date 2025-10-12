CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
    @ActivityId uniqueidentifier = NULL,
    @ProjectId uniqueidentifier = NULL,
    @ProjectMemberId uniqueidentifier = NULL,
    @Name nvarchar(128) = NULL,
    @Description nvarchar(4000) = NULL,
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1, -- Default to active
    @SystemDeleteFlag char(1) = 'N' -- Default to not deleted
AS
BEGIN
    BEGIN TRY
        SELECT *
        FROM [dbo].[Activity]
        WHERE (@ActivityId IS NULL OR ActivityId = @ActivityId)
          AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
          AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
          AND (@Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0)
          AND (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0)
          AND (@StartDate IS NULL OR CreatedDateTime >= @StartDate AND CreatedDateTime < DATEADD(day, 1, @StartDate))
          AND (@TargetDate IS NULL OR TargetDate = @TargetDate)
          AND (@EndDate IS NULL OR EndDate = @EndDate)
          AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
          AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
          AND (@Priority IS NULL OR Priority = @Priority)
          AND (@Risk IS NULL OR Risk = @Risk)
          AND (@Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0)
          AND ActiveFlag = @ActiveFlag
          AND SystemDeleteFlag = @SystemDeleteFlag;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
