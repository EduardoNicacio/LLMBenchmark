/*****************************************************************************************
*  Procedure: usp_ActivityRetrieve
*  Purpose : Return rows that match the supplied search criteria.
*            All columns are returned. UpdatedDateTime, UpdatedByUser,
*            UpdatedByProgram are **not** part of the filter (they stay in the result set).
*            ActiveFlag defaults to 1; SystemDeletedFlag defaults to 'N'.
*****************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityRetrieve
(
    @ActivityId        UNIQUEIDENTIFIER = NULL,
    @ProjectId         UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId   UNIQUEIDENTIFIER = NULL,
    @Name              NVARCHAR(128) = NULL,
    @Description       NVARCHAR(4000) = NULL,
    @StartDate         DATE = NULL,
    @TargetDate        DATE = NULL,
    @EndDate           DATE = NULL,
    @ProgressStatus    TINYINT = NULL,
    @ActivityPoints    SMALLINT = NULL,
    @Priority          TINYINT = NULL,
    @Risk              TINYINT = NULL,
    @Tags              NVARCHAR(200) = NULL,
    @ActiveFlag        TINYINT = 1,               -- defaulted to 1
    @SystemDeleteFlag  CHAR(1) = 'N'             -- defaulted to N
)
AS
BEGIN
    SET NOCOUNT ON;

    /* ------------------- Validation ------------------------------------------------- */
    IF @ActiveFlag NOT IN (0,1)          THEN RAISERROR(50003,'@ActiveFlag must be 0 or 1.',0);
    IF @SystemDeleteFlag NOT IN ('N','Y') THEN RAISERROR(50003,'@SystemDeleteFlag must be N or Y.',0);

    /* Length checks (only for non‑null parameters) */
    IF @Name IS NOT NULL AND LEN(@Name) > 128   THEN RAISERROR(50002,'@Name exceeds column length (128).',0);
    IF @Description IS NOT NULL AND LEN(@Description) > 4000 THEN RAISERROR(50002,'@Description exceeds column length (4000).',0);
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200   THEN RAISERROR(50002,'@Tags exceeds column length (200).',0);

    /* ------------------- SELECT ---------------------------------------------------- */
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
        UpdatedByProgram,
        SystemTimestamp
    FROM dbo.Activity
    WHERE
        (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
        (@ProjectId IS NULL  OR ProjectId = @ProjectId)      AND
        (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
        (@Name IS NULL OR CHARINDEX(@Name, Name,0) > 0)       AND
        (@Description IS NULL OR CHARINDEX(@Description, Description,0) > 0) AND
        (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day,1,@StartDate)) AND
        (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day,1,@TargetDate)) AND
        (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day,1,@EndDate)) AND
        (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
        (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
        (@Priority IS NULL OR Priority = @Priority) AND
        (@Risk IS NULL OR Risk = @Risk) AND
        (@Tags IS NULL OR CHARINDEX(@Tags, Tags,0) > 0) AND
        (@ActiveFlag = 1) AND
        (@SystemDeleteFlag = 'N');

    /* ------------------- TRY…CATCH wrapper ---------------------------------------- */
    BEGIN TRY
        /* The SELECT statement above is already inside the try block. */
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorSeverity, ErrorState,
                                 ErrorProcedure, ErrorLine, ErrorMessage)
        SELECT ERROR_NUMBER()   AS ErrorNumber,
               ERROR_SEVERITY()  AS ErrorSeverity,
               ERROR_STATE()     AS ErrorState,
               ERROR_PROCEDURE()  AS ErrorProcedure,
               ERROR_LINE()      AS ErrorLine,
               ERROR_MESSAGE()   AS ErrorMessage;
        RAISERROR('50000',16,1,'Error occurred during SELECT operation.');
    END CATCH;
END; /* usp_ActivityRetrieve */
