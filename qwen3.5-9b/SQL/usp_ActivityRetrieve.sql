-- =============================================
-- Stored Procedure: usp_ActivityRetrieve
-- Description: Retrieves Activity records based on filters
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieve]
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ActiveFlag TINYINT = NULL,
    @SystemDeleteFlag CHAR(1) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Default ActiveFlag and SystemDeleteFlag for Retrieve Logic
        -- Note: This filters the result, not validating the input parameter
        IF @ActiveFlag IS NULL
            SET @ActiveFlag = 1;
            
        IF @SystemDeleteFlag IS NULL
            SET @SystemDeleteFlag = 'N';

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
            ([ActivityId] = @ActivityId) AND
            ([ProjectId] = @ProjectId) AND
            ([ProjectMemberId] = @ProjectMemberId) AND
            ([ActiveFlag] = @ActiveFlag) AND
            ([SystemDeleteFlag] = @SystemDeleteFlag) AND

            -- String Wildcard Search Logic
            (
                (@Name IS NULL OR CHARINDEX(@Name, [Name], 0) > 0) AND
                (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0) AND
                (@Tags IS NULL OR CHARINDEX(@Tags, [Tags], 0) > 0) AND
                (@CreatedByUser IS NULL OR CHARINDEX(@CreatedByUser, [CreatedByUser], 0) > 0) AND
                (@CreatedByProgram IS NULL OR CHARINDEX(@CreatedByProgram, [CreatedByProgram], 0) > 0)
            ) AND

            -- Date Range Search Logic
            (
                (@StartDate IS NULL OR [StartDate] >= @StartDate) AND
                (@EndDate IS NULL OR [EndDate] < DATEADD(day, 1, @EndDate)) AND
                (@TargetDate IS NULL OR [TargetDate] >= @TargetDate) AND
                (@TargetDate IS NULL OR [TargetDate] < DATEADD(day, 1, @TargetDate))
            ) AND
            (
                (@TargetDate IS NULL OR [TargetDate] >= DATEADD(day, 1, @StartDate)) -- Ensure Date overlap logic if needed or simple range
                -- Actually simple range check usually suffices for "Search in Date"
            );
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorNumber INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER();

        BEGIN TRY
            INSERT INTO [dbo].[DbError] (
                [ErrorMessage],
                [ErrorNumber],
                [StackTrace]
            )
            VALUES (
                @ErrorMessage,
                @ErrorNumber,
                ERROR_LINE() + ' ' + ERROR_PROCEDURE()
            );
        END TRY
        BEGIN CATCH
            RAISERROR ('50000', 16, 1, 'Error occurred during Retrieve operation.');
        END CATCH
    END CATCH
END
GO
