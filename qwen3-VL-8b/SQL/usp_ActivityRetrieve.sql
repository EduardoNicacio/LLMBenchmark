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
    @CreatedDateTime DATETIME2(7) = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF (@ActiveFlag NOT IN (0, 1))
        RAISERROR('Error 50003: ActiveFlag must be 0 or 1.', 16, 1);
    IF (@SystemDeleteFlag NOT IN ('N', 'Y'))
        RAISERROR('Error 50003: SystemDeleteFlag must be ''N'' or ''Y''.', 16, 1);

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
            [UpdatedByProgram],
            [SystemTimestamp]
        FROM [dbo].[Activity]
        WHERE
            (@ActivityId IS NULL OR [ActivityId] = @ActivityId)
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
            AND (@ActiveFlag IS NULL OR [ActiveFlag] = @ActiveFlag)
            AND (@SystemDeleteFlag IS NULL OR [SystemDeleteFlag] = @SystemDeleteFlag)
            AND (@CreatedDateTime IS NULL OR [CreatedDateTime] >= @CreatedDateTime AND [CreatedDateTime] < DATEADD(day, 1, @CreatedDateTime))
            AND (@CreatedByUser IS NULL OR CHARINDEX(@CreatedByUser, [CreatedByUser], 0) > 0)
            AND (@CreatedByProgram IS NULL OR CHARINDEX(@CreatedByProgram, [CreatedByProgram], 0) > 0)
            AND (@UpdatedDateTime IS NULL OR [UpdatedDateTime] >= @UpdatedDateTime AND [UpdatedDateTime] < DATEADD(day, 1, @UpdatedDateTime))
            AND (@UpdatedByUser IS NULL OR CHARINDEX(@UpdatedByUser, [UpdatedByUser], 0) > 0)
            AND (@UpdatedByProgram IS NULL OR CHARINDEX(@UpdatedByProgram, [UpdatedByProgram], 0) > 0)
            AND (@SystemTimestamp IS NULL OR [SystemTimestamp] = @SystemTimestamp);
    END TRY
    BEGIN CATCH
        -- Log error
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorTime)
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETUTCDATE()
        );

        -- Raise error
        RAISERROR('Error 50000: Error occurred during ActivityRetrieve operation.', 16, 1);
    END CATCH
END;
GO
