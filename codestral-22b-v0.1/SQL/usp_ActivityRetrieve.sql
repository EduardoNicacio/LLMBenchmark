-- usp_ActivityRetrieve
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
(
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
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N'
) AS
BEGIN
    -- Input parameter validation
    IF @ActiveFlag NOT IN (0, 1) OR @SystemDeleteFlag NOT IN ('N', 'Y')
        THROW 50003, 'Invalid ActiveFlag or SystemDeleteFlag.', 1;

    -- Retrieve statement with wildcard search and date range search
    BEGIN TRY
        SELECT [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description], [StartDate],
            [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints], [Priority], [Risk],
            [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime], [CreatedByUser],
            [CreatedByProgram], [UpdatedDateTime], [UpdatedByUser], [UpdatedByProgram]
        FROM [dbo].[Activity]
        WHERE (@ProjectId IS NULL OR [ProjectId] = @ProjectId)
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
            AND [ActiveFlag] = @ActiveFlag
            AND [SystemDeleteFlag] = @SystemDeleteFlag;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        INSERT INTO [dbo].[DbError] ([ErrorDateTime], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (SYSUTCDATETIME(), ERROR_NUMBER(), @ErrorSeverity, @ErrorState, 'usp_ActivityRetrieve', ERROR_LINE(), @ErrorMessage);
        THROW;
    END CATCH
END;
GO