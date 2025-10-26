-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF (@ActivityId IS NULL)
            RAISERROR('Parameter ActivityId cannot be null.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemDeleteFlag <> 'Y')
            RAISERROR('Activity not found or already deleted.', 16, 1);

        IF (@SystemTimestamp IS NULL OR CONVERT(TIMESTAMP, @SystemTimestamp) < GETDATE())
            RAISERROR('Optimistic lock failure: Another user has updated this Activity.', 16, 1);

        UPDATE [dbo].[Activity]
        SET
            ProjectId = IIF(@ProjectId IS NOT NULL AND (@ProjectId <> (SELECT ProjectId FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @ProjectId, (SELECT ProjectId FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            ProjectMemberId = IIF(@ProjectMemberId IS NOT NULL AND (@ProjectMemberId <> (SELECT ProjectMemberId FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @ProjectMemberId, (SELECT ProjectMemberId FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            Name = IIF(@Name IS NOT NULL AND LEN(@Name) <= 128, @Name, (SELECT Name FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            Description = IIF(@Description IS NOT NULL AND LEN(@Description) <= 4000, @Description, (SELECT Description FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            StartDate = IIF(@StartDate IS NOT NULL, @StartDate, (SELECT StartDate FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            TargetDate = IIF(@TargetDate IS NOT NULL, @TargetDate, (SELECT TargetDate FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            EndDate = IIF(@EndDate IS NOT NULL, @EndDate, (SELECT EndDate FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            ProgressStatus = IIF(@ProgressStatus IS NOT NULL AND (@ProgressStatus <> (SELECT ProgressStatus FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @ProgressStatus, (SELECT ProgressStatus FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            ActivityPoints = IIF(@ActivityPoints IS NOT NULL AND (@ActivityPoints <> (SELECT ActivityPoints FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @ActivityPoints, (SELECT ActivityPoints FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            Priority = IIF(@Priority IS NOT NULL AND (@Priority <> (SELECT Priority FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @Priority, (SELECT Priority FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            Risk = IIF(@Risk IS NOT NULL AND (@Risk <> (SELECT Risk FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)), @Risk, (SELECT Risk FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            Tags = IIF(@Tags IS NOT NULL AND LEN(@Tags) <= 200, @Tags, (SELECT Tags FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            ActiveFlag = IIF(@ActiveFlag IS NOT NULL, @ActiveFlag, (SELECT ActiveFlag FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            UpdatedDateTime = IIF(@UpdatedDateTime IS NULL, SYSUTCDATETIME(), @UpdatedDateTime),
            UpdatedByUser = IIF(@UpdatedByUser IS NULL, SYSTEM_USER, @UpdatedByUser),
            UpdatedByProgram = IIF(@UpdatedByProgram IS NULL, APP_NAME(), @UpdatedByProgram)
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'Error occurred during Update operation.';
        INSERT INTO [dbo].[DbError] (ErrorMessage, ErrorDate) VALUES (@ErrorMessage, SYSUTCDATETIME());

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH;
END;
GO