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
    @ActiveFlag TINYINT = 1,
    @SystemDeleteFlag CHAR(1) = 'N',
    @CreatedDateTime DATE = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL,
    @UpdatedDateTime DATE = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate ActiveFlag and SystemDeleteFlag
    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag != 0 AND @ActiveFlag != 1)
        RAISERROR('50003', 16, 1, 'ActiveFlag') RETURN;

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag != 'N' AND @SystemDeleteFlag != 'Y')
        RAISERROR('50003', 16, 1, 'SystemDeleteFlag') RETURN;

    -- Validate string lengths
    IF @Name IS NOT NULL AND LEN(@Name) > 128
        RAISERROR('50002', 16, 1, 'Name', 128) RETURN;

    IF @Description IS NOT NULL AND LEN(@Description) > 4000
        RAISERROR('50002', 16, 1, 'Description', 4000) RETURN;

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        RAISERROR('50002', 16, 1, 'Tags', 200) RETURN;

    IF @CreatedDateTime IS NOT NULL AND @CreatedDateTime > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'CreatedDateTime', 9999) RETURN;

    IF @StartDate IS NOT NULL AND @StartDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'StartDate', 9999) RETURN;

    IF @TargetDate IS NOT NULL AND @TargetDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'TargetDate', 9999) RETURN;

    IF @EndDate IS NOT NULL AND @EndDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'EndDate', 9999) RETURN;

    IF @CreatedByUser IS NOT NULL AND LEN(@CreatedByUser) > 100
        RAISERROR('50002', 16, 1, 'CreatedByUser', 100) RETURN;

    IF @CreatedByProgram IS NOT NULL AND LEN(@CreatedByProgram) > 100
        RAISERROR('50002', 16, 1, 'CreatedByProgram', 100) RETURN;

    IF @UpdatedByUser IS NOT NULL AND LEN(@UpdatedByUser) > 100
        RAISERROR('50002', 16, 1, 'UpdatedByUser', 100) RETURN;

    IF @UpdatedByProgram IS NOT NULL AND LEN(@UpdatedByProgram) > 100
        RAISERROR('50002', 16, 1, 'UpdatedByProgram', 100) RETURN;

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
            [SystemDeleteFlag] = 'N'
            AND [ActiveFlag] = @ActiveFlag
            AND (@ActivityId IS NULL OR [ActivityId] = @ActivityId)
            AND (@ProjectId IS NULL OR [ProjectId] = @ProjectId)
            AND (@ProjectMemberId IS NULL OR [ProjectMemberId] = @ProjectMemberId)
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
            AND (@CreatedDateTime IS NULL OR [CreatedDateTime] >= @CreatedDateTime AND [CreatedDateTime] < DATEADD(day, 1, @CreatedDateTime))
            AND (@CreatedByUser IS NULL OR [CreatedByUser] = @CreatedByUser)
            AND (@CreatedByProgram IS NULL OR [CreatedByProgram] = @CreatedByProgram)
            AND (@UpdatedDateTime IS NULL OR [UpdatedDateTime] >= @UpdatedDateTime AND [UpdatedDateTime] < DATEADD(day, 1, @UpdatedDateTime))
            AND (@UpdatedByUser IS NULL OR [UpdatedByUser] = @UpdatedByUser)
            AND (@UpdatedByProgram IS NULL OR [UpdatedByProgram] = @UpdatedByProgram);
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
        RETURN;
    END CATCH
END
GO
