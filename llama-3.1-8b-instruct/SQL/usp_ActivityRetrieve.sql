-- usp_ActivityRetrieve
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            ActivityId,
            ProjectId,
            ProjectMemberId,
            Name,
            Description,
            StartDate,
            TargetDate,
            EndDate,
            ProgressStatus,
            ActivityPoints,
            Priority,
            Risk,
            Tags,
            ActiveFlag = IIF(SystemDeleteFlag <> 'Y', 1, 0),
            SystemDeleteFlag
        FROM (
            SELECT
                ActivityId,
                ProjectId,
                ProjectMemberId,
                Name,
                Description,
                StartDate,
                TargetDate,
                EndDate,
                ProgressStatus,
                ActivityPoints,
                Priority,
                Risk,
                Tags,
                ActiveFlag,
                SystemDeleteFlag,
                ROW_NUMBER() OVER (ORDER BY CreatedDateTime DESC) AS RowNumber
            FROM (
                SELECT
                    ActivityId,
                    ProjectId,
                    ProjectMemberId,
                    Name,
                    Description,
                    StartDate,
                    TargetDate,
                    EndDate,
                    ProgressStatus,
                    ActivityPoints,
                    Priority,
                    Risk,
                    Tags,
                    ActiveFlag,
                    SystemDeleteFlag,
                    CreatedDateTime
                FROM [dbo].[Activity]
                WHERE
                    (@ActivityId IS NULL OR ActivityId = @ActivityId)
                    AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
                    AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
                    AND ((@Name IS NULL) OR CHARINDEX(@Name, Name, 0) > 0)
                    AND ((@Description IS NULL) OR CHARINDEX(@Description, Description, 0) > 0)
                    AND ((@StartDate IS NULL) OR (StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)))
                    AND ((@TargetDate IS NULL) OR (TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)))
                    AND ((@EndDate IS NULL) OR (EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)))
                    AND ((@ProgressStatus IS NULL) OR ProgressStatus = @ProgressStatus)
                    AND ((@ActivityPoints IS NULL) OR ActivityPoints = @ActivityPoints)
                    AND ((@Priority IS NULL) OR Priority = @Priority)
                    AND ((@Risk IS NULL) OR Risk = @Risk)
                    AND ((@Tags IS NULL) OR CHARINDEX(@Tags, Tags, 0) > 0)
                    AND SystemDeleteFlag <> 'Y'
            ) AS Subquery
        ) AS Mainquery
        WHERE RowNumber <= 1;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'Error occurred during Retrieve operation.';
        INSERT INTO [dbo].[DbError] (ErrorMessage, ErrorDate) VALUES (@ErrorMessage, SYSUTCDATETIME());

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH;
END;
GO