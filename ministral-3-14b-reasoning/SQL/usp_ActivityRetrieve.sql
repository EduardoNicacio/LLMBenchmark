CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieve]
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
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate ActiveFlag and SystemDeleteFlag if they are provided (though defaults are set)
        IF @ActiveFlag IS NOT NULL AND @ActiveFlag NOT IN (0, 1)
            RAISERROR('ActiveFlag must be 0 or 1', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        IF @SystemDeleteFlag IS NOT NULL AND @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('SystemDeleteFlag must be either "N" or "Y"', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        -- Construct the WHERE clause conditions
        DECLARE @WhereClause NVARCHAR(MAX) =
            N'ActiveFlag = @ActiveFlag AND SystemDeleteFlag = @SystemDeleteFlag';

        -- Add conditions for each parameter if not null
        IF @ActivityId IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND ActivityId = @ActivityId';

        IF @ProjectId IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND ProjectId = @ProjectId';

        IF @ProjectMemberId IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND ProjectMemberId = @ProjectMemberId';

        -- Date range conditions
        IF @StartDate IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)';

        IF @TargetDate IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)';

        IF @EndDate IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)';

        -- Numeric conditions
        IF @ProgressStatus IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND ProgressStatus = @ProgressStatus';

        IF @ActivityPoints IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND ActivityPoints = @ActivityPoints';

        IF @Priority IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND Priority = @Priority';

        IF @Risk IS NOT NULL
            SET @WhereClause = @WhereClause + N' AND Risk = @Risk';

        -- Build the dynamic SQL with proper parameterization for wildcard searches
        DECLARE @Sql NVARCHAR(MAX) =
            N'
            SELECT a.*
            FROM [dbo].[Activity] a
            WHERE ' + @WhereClause;

        -- Add wildcard search conditions if parameters are provided
        IF @Name IS NOT NULL OR @Description IS NOT NULL OR @Tags IS NOT NULL
        BEGIN
            SET @Sql = @Sql + N'
            AND (
                (a.Name LIKE ''%'' + @Name + ''%'')' +
                CASE WHEN @Description IS NOT NULL THEN N' OR (a.Description LIKE ''%'' + @Description + ''%'')' ELSE '' END +
                CASE WHEN @Tags IS NOT NULL THEN N' OR (a.Tags LIKE ''%'' + @Tags + ''%'')' ELSE '' END +
            N')';
        END

        -- Execute the dynamic SQL
        EXEC sp_executesql @Sql,
            N'@ActivityId uniqueidentifier, @ProjectId uniqueidentifier, @ProjectMemberId uniqueidentifier,
             @Name nvarchar(128), @Description nvarchar(4000), @Tags nvarchar(200),
             @StartDate date, @TargetDate date, @EndDate date,
             @ProgressStatus tinyint, @ActivityPoints smallint, @Priority tinyint, @Risk tinyint',
            @ActivityId, @ProjectId, @ProjectMemberId,
            @Name, @Description, @Tags,
            @StartDate, @TargetDate, @EndDate,
            @ProgressStatus, @ActivityPoints, @Priority, @Risk;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState,
            ErrorProcedure, ErrorLine,
            ErrorMessage, CreatedDateTime
        )
        VALUES (
            ERROR_NUMBER(), @ErrorSeverity, @ErrorState,
            'usp_ActivityRetrieve', ERROR_LINE(),
            @ErrorMessage, SYSUTCDATETIME()
        );

        -- Re-throw the error with our standard message
        RAISERROR('Error occurred during retrieve operation.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50000;
    END CATCH
END;
GO
