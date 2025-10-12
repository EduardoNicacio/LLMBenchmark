CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
(
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
-- Default ActiveFlag to 1 instead of null.
@ActiveFlag TINYINT NOT NULL DEFAULT 1,

-- Default SystemDeletedFlag (i.e. SystemDeleteFlag) to 'N' instead of null.
@SystemDeletedFlag CHAR(1) NOT NULL DEFAULT 'N',
@CreatedDateTime DATETIME2(7) = NULL  -- used only for date search criteria
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
-------------------------------------------------------------------
-- Validate lengths for varchar/nvarchar parameters that are provided.
IF @Name IS NOT NULL AND LEN(@Name) > 128
RAISERROR ('Parameter Name length exceeds maximum allowed (128).', 16, 50002);
IF @Description IS NOT NULL AND LEN(@Description) > 4000
RAISERROR ('Parameter Description length exceeds maximum allowed (4000).', 16, 50002);
IF @Tags IS NOT NULL AND LEN(@Tags) > 200
RAISERROR ('Parameter Tags length exceeds maximum allowed (200).', 16, 50002);
    -------------------------------------------------------------------
    -- Validate flag parameters.
    IF @ActiveFlag NOT IN (0,1)
        RAISERROR ('Parameter ActiveFlag must be either 0 or 1.', 16, 50003);
    IF @SystemDeletedFlag NOT IN ('N','Y')
        RAISERROR ('Parameter SystemDeletedFlag must be ''N'' or ''Y''.', 16, 50003);

    -------------------------------------------------------------------
    -- Retrieve records matching the search criteria.
    SELECT 
        ActivityId,
        ProjectId,
        ProjectMemberId,
        Name,
        Description,
        StartDate,
        TargetDate,
        EndDate,
        ProgressStatus,
        ActivityPoints,
        Priority,
        Risk,
        Tags,
        ActiveFlag,
        SystemDeleteFlag,
        CreatedDateTime,
        CreatedByUser,
        CreatedByProgram,
        UpdatedDateTime,
        UpdatedByUser,
        UpdatedByProgram
    FROM dbo.Activity
    WHERE ActiveFlag = @ActiveFlag AND SystemDeleteFlag = @SystemDeletedFlag
      AND (@ActivityId IS NULL OR ActivityId = @ActivityId)
      AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
      AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
      AND (@Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0)
      AND (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0)
      AND (@StartDate IS NULL OR StartDate = @StartDate)
      AND (@TargetDate IS NULL OR TargetDate = @TargetDate)
      AND (@EndDate IS NULL OR EndDate = @EndDate)
      AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
      AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
      AND (@Priority IS NULL OR Priority = @Priority)
      AND (@Risk IS NULL OR Risk = @Risk)
      AND (@Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0)
      -- Date search criteria pattern.
      AND (@CreatedDateTime IS NULL 
           OR CreatedDateTime >= @CreatedDateTime 
           AND CreatedDateTime < DATEADD(day, 1, @CreatedDateTime));
END TRY
BEGIN CATCH
    -------------------------------------------------------------------
    -- Log the error in dbo.DbError.
    INSERT INTO [dbo].[DbError] 
    (
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
END CATCH
END
GO