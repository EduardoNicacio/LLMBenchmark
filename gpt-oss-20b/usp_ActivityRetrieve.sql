/*--------------------------------------------------------------------
    usp_ActivityRetrieve
    Retrieves Activity records that match supplied search criteria.
--------------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityRetrieve
(
    /* Primary key and other columns */
    @ActivityId        uniqueidentifier = NULL,
    @ProjectId         uniqueidentifier = NULL,
    @ProjectMemberId   uniqueidentifier = NULL,

    @Name              nvarchar(128)     = NULL,
    @Description       nvarchar(4000)    = NULL,

    @StartDate         date             = NULL,
    @TargetDate        date             = NULL,
    @EndDate           date             = NULL,

    @ProgressStatus    tinyint          = NULL,
    @ActivityPoints    smallint         = NULL,
    @Priority          tinyint          = NULL,
    @Risk              tinyint          = NULL,
    @Tags              nvarchar(200)    = NULL,

    /* Flags – default values are used for filtering */
    @ActiveFlag        tinyint           = 1,      -- default to active
    @SystemDeleteFlag  char(1)            = 'N',    -- default to non‑deleted

    /* Audit columns – not part of the search criteria */
    @CreatedDateTime   datetime2(7)       = NULL,
    @UpdatedDateTime   datetime2(7)       = NULL,   -- ignored
    @UpdatedByUser     nvarchar(100)      = NULL,   -- ignored
    @UpdatedByProgram  nvarchar(100)      = NULL,   -- ignored
    @CreatedByUser     nvarchar(100)      = NULL,
    @CreatedByProgram  nvarchar(100)      = NULL,
    @SystemTimestamp   timestamp          = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------
        Parameter validation
    -----------------------------*/
    IF @Name IS NOT NULL AND LEN(@Name) > 128
        RAISERROR('Name exceeds maximum length of 128 characters.',50002,1);

    IF @Description IS NOT NULL AND LEN(@Description) > 4000
        RAISERROR('Description exceeds maximum length of 4000 characters.',50002,1);

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        RAISERROR('Tags exceeds maximum length of 200 characters.',50002,1);

    IF @ActiveFlag NOT IN (0,1)
        RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.',50003,1);

    IF @SystemDeleteFlag NOT IN ('N','Y')
        RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.',50003,1);

    /*-----------------------------
        Retrieve operation
    -----------------------------*/
    BEGIN TRY
        SELECT  ActivityId,
                ProjectId,
                ProjectMemberId,
                [Name],
                [Description],
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
         WHERE (@ActivityId        IS NULL OR ActivityId        = @ActivityId)
           AND (@ProjectId        IS NULL OR ProjectId        = @ProjectId)
           AND (@ProjectMemberId  IS NULL OR ProjectMemberId  = @ProjectMemberId)

           /* String search pattern */
           AND (@Name            IS NULL OR CHARINDEX(@Name,      [Name], 0) > 0)
           AND (@Description     IS NULL OR CHARINDEX(@Description,[Description],0) > 0)
           AND (@Tags            IS NULL OR CHARINDEX(@Tags,       Tags, 0) > 0)

           /* Date range pattern – inclusive of the day */
           AND (@StartDate        IS NULL OR (StartDate >= @StartDate AND StartDate < DATEADD(day,1,@StartDate)))
           AND (@TargetDate       IS NULL OR (TargetDate >= @TargetDate AND TargetDate < DATEADD(day,1,@TargetDate)))
           AND (@EndDate          IS NULL OR (EndDate >= @EndDate AND EndDate < DATEADD(day,1,@EndDate)))

           /* Numeric filters */
           AND (@ProgressStatus   IS NULL OR ProgressStatus = @ProgressStatus)
           AND (@ActivityPoints   IS NULL OR ActivityPoints = @ActivityPoints)
           AND (@Priority         IS NULL OR Priority     = @Priority)
           AND (@Risk             IS NULL OR Risk         = @Risk)

           /* Flag filters – defaults are used for filtering */
           AND ActiveFlag        = @ActiveFlag
           AND SystemDeleteFlag  = @SystemDeleteFlag

           /* CreatedDateTime range pattern (if supplied) */
           AND (@CreatedDateTime IS NULL OR (CreatedDateTime >= @CreatedDateTime AND CreatedDateTime < DATEADD(day,1,@CreatedDateTime)));
    END TRY
    BEGIN CATCH
        /* Log error to DbError table */
        INSERT INTO dbo.DbError (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER()   AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE()    AS ErrorState,
            ERROR_PROCEDURE()AS ErrorProcedure,
            ERROR_LINE()     AS ErrorLine,
            ERROR_MESSAGE()  AS ErrorMessage;
        THROW;   -- Re‑throw the original error
    END CATCH;
END
GO
