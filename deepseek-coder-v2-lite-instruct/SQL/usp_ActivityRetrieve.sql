-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieve]
-- Purpose   : Retrieve a single activity record from the Activity table.
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-01
-- ============================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT  [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description], [StartDate], [TargetDate], [EndDate], [ProgressStatus],
            [ActivityPoints], [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime], [CreatedByUser], [CreatedByProgram], [UpdatedDateTime], [UpdatedByUser], [UpdatedByProgram]
    FROM [dbo].[Activity] WITH (NOLOCK)
    WHERE ActivityId = @ActivityId AND ActiveFlag = ISNULL(@ActiveFlag, 1) AND SystemDeleteFlag = ISNULL(@SystemDeleteFlag, 'N');
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SYSUTCDATETIME());
    RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityRetrieve operation.');
END CATCH;
