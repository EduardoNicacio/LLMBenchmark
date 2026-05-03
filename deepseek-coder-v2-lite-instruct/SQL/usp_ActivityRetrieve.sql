-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieve]
-- Purpose   : Retrieve activity records from the Activity table based on specified criteria.
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-01
-- ============================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description], [StartDate], [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints], [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime], [CreatedByUser], [CreatedByProgram], [UpdatedDateTime], [UpdatedByUser], [UpdatedByProgram]
    FROM [dbo].[Activity]
    WHERE (@ActivityId IS NULL OR ActivityId = @ActivityId)
      AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
      AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
      AND (@Name IS NULL OR CHARINDEX(@Name, [Name], 0) > 0)
      AND (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0)
      AND (@StartDate IS NULL OR (StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)))
      AND (@TargetDate IS NULL OR (TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)))
      AND (@EndDate IS NULL OR (EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)))
      AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
      AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
      AND (@Priority IS NULL OR Priority = @Priority)
      AND (@Risk IS NULL OR Risk = @Risk)
      AND (@Tags IS NULL OR CHARINDEX(@Tags, [Tags], 0) > 0)
      AND (@ActiveFlag IS NULL OR ActiveFlag = @ActiveFlag)
      AND (@SystemDeleteFlag IS NULL OR SystemDeleteFlag = @SystemDeleteFlag)
      AND (@CreatedDateTime IS NULL OR CreatedDateTime = @CreatedDateTime)
      AND (@CreatedByUser IS NULL OR CreatedByUser = @CreatedByUser)
      AND (@CreatedByProgram IS NULL OR CreatedByProgram = @CreatedByProgram)
      AND (@UpdatedDateTime IS NULL OR UpdatedDateTime = @UpdatedDateTime)
      AND (@UpdatedByUser IS NULL OR UpdatedByUser = @UpdatedByUser)
      AND (@UpdatedByProgram IS NULL OR UpdatedByProgram = @UpdatedByProgram)
    ORDER BY [Name] ASC;
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError]
        (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDateTime)
    VALUES
        (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(),
         ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(),
         SYSUTCDATETIME());
    RAISERROR(50000, 16, 1, N'Error occurred during usp_ActivityRetrieve operation.');
END CATCH;
