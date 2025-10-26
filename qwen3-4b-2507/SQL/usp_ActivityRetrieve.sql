-- usp_ActivityRetrieve
CREATE PROCEDURE usp_ActivityRetrieve
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
    @ActiveFlag TINYINT = NULL,
    @SystemDeleteFlag CHAR(1) = NULL,
    @CreatedDateTime DATETIME2(7) = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate ActiveFlag and SystemDeleteFlag
    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag NOT IN (0, 1))
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid ActiveFlag value. Must be 0 or 1.');
        RETURN;
    END

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag NOT IN ('N', 'Y'))
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.');
        RETURN;
    END

    -- Default values
    IF @ActiveFlag IS NULL
        SET @ActiveFlag = 1;
    IF @SystemDeleteFlag IS NULL
        SET @SystemDeleteFlag = 'N';

    BEGIN TRY
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
        FROM [dbo].[Activity]
        WHERE 
            ([ActivityId] = @ActivityId OR @ActivityId IS NULL)
            AND ([ProjectId] = @ProjectId OR @ProjectId IS NULL)
            AND ([ProjectMemberId] = @ProjectMemberId OR @ProjectMemberId IS NULL)
            AND (@Name IS NULL OR CHARINDEX(@Name, [Name], 0) > 0)
            AND (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0)
            AND (@StartDate IS NULL OR [StartDate] >= @StartDate AND [StartDate] < DATEADD(day, 1, @StartDate))
            AND (@TargetDate IS NULL OR [TargetDate] >= @TargetDate AND [TargetDate] < DATEADD(day, 1, @TargetDate))
            AND (@EndDate IS NULL OR [EndDate] >= @EndDate AND [EndDate] < DATEADD(day, 1, @EndDate))
            AND (@ProgressStatus IS NULL OR [ProgressStatus] = @ProgressStatus)
            AND (@ActivityPoints IS NULL OR [ActivityPoints] = @ActivityPoints)
            AND (@Priority IS NULL OR [Priority] = @Priority)
            AND (@Risk IS NULL OR [Risk] = @Risk)
            AND (@Tags IS NULL OR CHARINDEX(@Tags, [Tags], 0) > 0)
            AND (@ActiveFlag = 1 OR [ActiveFlag] = @ActiveFlag)
            AND ([SystemDeleteFlag] = 'N' OR [SystemDeleteFlag] = @SystemDeleteFlag)
            AND (@CreatedDateTime IS NULL OR [CreatedDateTime] >= @CreatedDateTime AND [CreatedDateTime] < DATEADD(day, 1, @CreatedDateTime))
            AND (@CreatedByUser IS NULL OR [CreatedByUser] = @CreatedByUser)
            AND (@CreatedByProgram IS NULL OR [CreatedByProgram] = @CreatedByProgram)
            AND (@UpdatedDateTime IS NULL OR [UpdatedDateTime] >= @UpdatedDateTime AND [UpdatedDateTime] < DATEADD(day, 1, @UpdatedDateTime))
            AND (@UpdatedByUser IS NULL OR [UpdatedByUser] = @UpdatedByUser)
            AND (@UpdatedByProgram IS NULL OR [UpdatedByProgram] = @UpdatedByProgram);

        RETURN 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorMessage, Operation, ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure)
        VALUES (ERROR_MESSAGE(), 'RETRIEVE', ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

        RAISERROR('50000', 16, 1, 'Error occurred during RETRIEVE operation.');
        RETURN -1;
    END CATCH
END
GO
