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
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1,
    @SystemDeleteFlag CHAR(1) = 'N'
AS
BEGIN
    BEGIN TRY
        -- Default to active, non-deleted records if not specified
        SET @ActiveFlag = ISNULL(@ActiveFlag, 1);
        SET @SystemDeleteFlag = ISNULL(@SystemDeleteFlag, 'N');

        -- Build dynamic WHERE clause for wildcard searches
        DECLARE @sql NVARCHAR(MAX) = 'SELECT * FROM [dbo].[Activity] WHERE (1=1)';

        IF @ActivityId IS NOT NULL
            SET @sql = @sql + ' AND [ActivityId] = @ActivityId';
        IF @ProjectId IS NOT NULL
            SET @sql = @sql + ' AND [ProjectId] = @ProjectId';
        IF @ProjectMemberId IS NOT NULL
            SET @sql = @sql + ' AND [ProjectMemberId] = @ProjectMemberId';

        -- Wildcard searches for string columns
        IF @Name IS NOT NULL
            SET @sql = @sql + ' AND CHARINDEX(@Name, [Name], 0) > 0';
        IF @Description IS NOT NULL
            SET @sql = @sql + ' AND CHARINDEX(@Description, [Description], 0) > 0';
        IF @Tags IS NOT NULL
            SET @sql = @sql + ' AND CHARINDEX(@Tags, [Tags], 0) > 0';

        -- Date range searches
        IF @StartDate IS NOT NULL
            SET @sql = @sql + ' AND ([StartDate] >= @StartDate AND [StartDate] < DATEADD(day, 1, @StartDate))';
        IF @TargetDate IS NOT NULL
            SET @sql = @sql + ' AND ([TargetDate] >= @TargetDate AND [TargetDate] < DATEADD(day, 1, @TargetDate))';
        IF @EndDate IS NOT NULL
            SET @sql = @sql + ' AND ([EndDate] >= @EndDate AND [EndDate] < DATEADD(day, 1, @EndDate))';

        -- Numeric comparisons
        IF @ProgressStatus IS NOT NULL
            SET @sql = @sql + ' AND [ProgressStatus] = @ProgressStatus';
        IF @ActivityPoints IS NOT NULL
            SET @sql = @sql + ' AND [ActivityPoints] = @ActivityPoints';
        IF @Priority IS NOT NULL
            SET @sql = @sql + ' AND [Priority] = @Priority';
        IF @Risk IS NOT NULL
            SET @sql = @sql + ' AND [Risk] = @Risk';

        -- Filter for active/non-deleted records if not specified otherwise
        SET @sql = @sql + ' AND [ActiveFlag] = @ActiveFlag AND [SystemDeleteFlag] = @SystemDeleteFlag';

        EXEC sp_executesql @sql, N'@ActivityId UNIQUEIDENTIFIER, @ProjectId UNIQUEIDENTIFIER, @ProjectMemberId UNIQUEIDENTIFIER,
            @Name NVARCHAR(128), @Description NVARCHAR(4000), @StartDate DATE, @TargetDate DATE, @EndDate DATE,
            @ProgressStatus TINYINT, @ActivityPoints SMALLINT, @Priority TINYINT, @Risk TINYINT, @Tags NVARCHAR(200),
            @ActiveFlag TINYINT, @SystemDeleteFlag CHAR(1)',
            @ActivityId, @ProjectId, @ProjectMemberId,
            @Name, @Description, @StartDate, @TargetDate, @EndDate,
            @ProgressStatus, @ActivityPoints, @Priority, @Risk, @Tags,
            @ActiveFlag, @SystemDeleteFlag;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] ([ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        RAISERROR('50000: Error occurred during retrieve operation.', 16, 1);
    END CATCH
END
GO
