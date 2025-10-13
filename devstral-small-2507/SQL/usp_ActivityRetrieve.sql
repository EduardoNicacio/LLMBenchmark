-- usp_ActivityRetrieve  
CREATE PROCEDURE dbo.usp_ActivityRetrieve
(
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
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1,
    @SystemDeleteFlag CHAR(1) = 'N',
    @CreatedDateTime DATETIME2(7) = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Input validation
        IF @ActiveFlag IS NOT NULL AND (@ActiveFlag <> 0 AND @ActiveFlag <> 1)
            RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.', 16, 50003);

        IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag <> 'N' AND @SystemDeleteFlag <> 'Y')
            RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 50003);

        SELECT
            [ActivityId],
            [ProjectId],
            [ProjectMemberId],
            [Name],
            [Description],
            [StartDate],
            [TargetDate],
            [EndDate],
            [ProgressStatus],
            [ActivityPoints],
            [Priority],
            [Risk],
            [Tags],
            [ActiveFlag],
            [SystemDeleteFlag],
            [CreatedDateTime],
            [CreatedByUser],
            [CreatedByProgram],
            [UpdatedDateTime],
            [UpdatedByUser],
            [UpdatedByProgram]
        FROM
            [dbo].[Activity] WITH (NOLOCK)
        WHERE
            (@ActivityId IS NULL OR [ActivityId] = @ActivityId) AND
            (@ProjectId IS NULL OR [ProjectId] = @ProjectId) AND
            (@ProjectMemberId IS NULL OR [ProjectMemberId] = @ProjectMemberId) AND
            (@Name IS NULL OR CHARINDEX(@Name, [Name], 0) > 0) AND
            (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0) AND
            (@StartDate IS NULL OR [StartDate] = @StartDate) AND
            (@TargetDate IS NULL OR [TargetDate] = @TargetDate) AND
            (@EndDate IS NULL OR [EndDate] = @EndDate) AND
            (@ProgressStatus IS NULL OR [ProgressStatus] = @ProgressStatus) AND
            (@ActivityPoints IS NULL OR [ActivityPoints] = @ActivityPoints) AND
            (@Priority IS NULL OR [Priority] = @Priority) AND
            (@Risk IS NULL OR [Risk] = @Risk) AND
            (@Tags IS NULL OR CHARINDEX(@Tags, [Tags], 0) > 0) AND
            (@ActiveFlag IS NULL OR [ActiveFlag] = @ActiveFlag) AND
            (@SystemDeleteFlag IS NULL OR [SystemDeleteFlag] = @SystemDeleteFlag) AND
            (@CreatedDateTime IS NULL OR [CreatedDateTime] >= @CreatedDateTime AND [CreatedDateTime] < DATEADD(day, 1, @CreatedDateTime)) AND
            (@CreatedByUser IS NULL OR CHARINDEX(@CreatedByUser, [CreatedByUser], 0) > 0) AND
            (@CreatedByProgram IS NULL OR CHARINDEX(@CreatedByProgram, [CreatedByProgram], 0) > 0);

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Log error to dbo.DbError table
        INSERT INTO dbo.DbError (ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during ActivityRetrieve operation.', 16, 50000);
    END CATCH
END
GO
