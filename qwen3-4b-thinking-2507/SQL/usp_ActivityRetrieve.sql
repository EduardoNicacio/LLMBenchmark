-- usp_ActivityRetrieve
CREATE OR ALTER PROCEDURE usp_ActivityRetrieve
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
    DECLARE @ErrorCode INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Validate parameters for nullability and types
    IF @ActiveFlag NOT IN (0, 1)
        RAISERROR('50003', 16, 1, 'ActiveFlag must be 0 or 1');
    IF @SystemDeleteFlag NOT IN ('Y', 'N')
        RAISERROR('50003', 16, 1, 'SystemDeleteFlag must be ''Y'' or ''N''');

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
            AND (@StartDate IS NULL OR [StartDate] = @StartDate)
            AND (@TargetDate IS NULL OR [TargetDate] = @TargetDate)
            AND (@EndDate IS NULL OR [EndDate] = @EndDate)
            AND (@ProgressStatus IS NULL OR [ProgressStatus] = @ProgressStatus)
            AND (@ActivityPoints IS NULL OR [ActivityPoints] = @ActivityPoints)
            AND (@Priority IS NULL OR [Priority] = @Priority)
            AND (@Risk IS NULL OR [Risk] = @Risk)
            AND (@Tags IS NULL OR [Tags] = @Tags)
            AND ([ActiveFlag] = @ActiveFlag)
            AND ([SystemDeleteFlag] = @SystemDeleteFlag)
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
        RAISERROR('50000', 16, 1, 'Error occurred during retrieval');
    END CATCH
END
GO
