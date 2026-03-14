-- =============================================
-- Stored Procedure: usp_ActivityRetrieveForList
-- Description: Retrieves ActivityId and Name for active, non-deleted records
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieveForList]
    @FilterString NVARCHAR(128) = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Select ActivityId and Name for active, non-deleted records
        SELECT 
            [ActivityId],
            [Name]
        FROM [dbo].[Activity]
        WHERE 
            [ActiveFlag] = 1 
            AND [SystemDeleteFlag] <> 'Y'
            AND
            -- Optional Filter Logic
            (
                (@FilterString IS NULL OR CHARINDEX(@FilterString, [Name], 0) > 0)
            )
            AND
            -- Date Range Search
            (
                (@StartDate IS NULL OR [StartDate] >= @StartDate) AND
                (@EndDate IS NULL OR [EndDate] < DATEADD(day, 1, @EndDate))
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
            RAISERROR ('50000', 16, 1, 'Error occurred during RetrieveForList operation.');
        END CATCH
    END CATCH
END
GO