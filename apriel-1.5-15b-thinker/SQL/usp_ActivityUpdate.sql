/*****************************************************************************************
*  Procedure: usp_ActivityUpdate
*  Purpose : Update an existing Activity row with optimistic lock verification.
*            All columns are supplied except the creation‑audit fields.
*****************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityUpdate
(
    @ActivityId        UNIQUEIDENTIFIER,
    @ProjectId         UNIQUEIDENTIFIER,
    @ProjectMemberId   UNIQUEIDENTIFIER,
    @Name              NVARCHAR(128),
    @Description       NVARCHAR(4000),
    @StartDate         DATE = NULL,
    @TargetDate        DATE = NULL,
    @EndDate           DATE = NULL,
    @ProgressStatus    TINYINT = NULL,
    @ActivityPoints    SMALLINT = NULL,
    @Priority          TINYINT = NULL,
    @Risk              TINYINT = NULL,
    @Tags              NVARCHAR(200) = NULL,
    @ActiveFlag        TINYINT,                     -- NOT NULL
    @SystemDeleteFlag  CHAR(1),                     -- NOT NULL (N or Y)
    @UpdatedDateTime   DATETIME2(7) = NULL,
    @UpdatedByUser     NVARCHAR(100) = NULL,
    @UpdatedByProgram  NVARCHAR(100) = NULL,
    @SystemTimestamp   TIMESTAMP
)
AS
BEGIN
    SET NOCOUNT ON;

    /* ------------------- Validation ------------------------------------------------- */
    IF @ActivityId IS NULL               THEN RAISERROR(50001,'@ActivityId cannot be NULL.',0);
    IF @ProjectId IS NULL                THEN RAISERROR(50001,'@ProjectId cannot be NULL.',0);
    IF @ProjectMemberId IS NULL          THEN RAISERROR(50001,'@ProjectMemberId cannot be NULL.',0);
    IF @Name IS NULL                     THEN RAISERROR(50001,'@Name cannot be NULL.',0);
    IF @Description IS NULL              THEN RAISERROR(50001,'@Description cannot be NULL.',0);
    IF @ActiveFlag IS NULL               THEN RAISERROR(50001,'@ActiveFlag cannot be NULL.',0);
    IF @SystemDeleteFlag IS NULL         THEN RAISERROR(50001,'@SystemDeleteFlag cannot be NULL.',0);

    /* Length checks */
    IF LEN(@Name) > 128                  THEN RAISERROR(50002,'@Name exceeds column length (128).',0);
    IF LEN(@Description) > 4000          THEN RAISERROR(50002,'@Description exceeds column length (4000).',0);
    IF LEN(@Tags) > 200                  THEN RAISERROR(50002,'@Tags exceeds column length (200).',0);

    /* Flag checks */
    IF @ActiveFlag NOT IN (0,1)          THEN RAISERROR(50003,'@ActiveFlag must be 0 or 1.',0);
    IF @SystemDeleteFlag NOT IN ('N','Y') THEN RAISERROR(50003,'@SystemDeleteFlag must be N or Y.',0);

    /* Default audit values if they are omitted */
    IF @UpdatedDateTime IS NULL      SET @UpdatedDateTime   = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL        SET @UpdatedByUser     = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL     SET @UpdatedByProgram  = APP_NAME();

    /* ------------------- Optimistic lock check ------------------------------------ */
    SELECT @CurrentTS = SystemTimestamp
    FROM dbo.Activity
    WHERE ActivityId = @ActivityId;

    IF @CurrentTS IS NULL
        THEN RAISERROR(50004,'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',16);
    ELSE IF @CurrentTS <> @SystemTimestamp
        THEN RAISERROR(50004,'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',16);

    /* ------------------- UPDATE ---------------------------------------------------- */
    UPDATE dbo.Activity
    SET ProjectId         = @ProjectId,
        ProjectMemberId   = @ProjectMemberId,
        Name              = @Name,
        Description       = @Description,
        StartDate         = ISNULL(@StartDate,StartDate),
        TargetDate        = ISNULL(@TargetDate,TargetDate),
        EndDate           = ISNULL(@EndDate,EndDate),
        ProgressStatus    = ISNULL(@ProgressStatus,ProgressStatus),
        ActivityPoints    = ISNULL(@ActivityPoints,ActivityPoints),
        Priority          = ISNULL(@Priority,Priority),
        Risk              = ISNULL(@Risk,Risk),
        Tags              = @Tags,
        ActiveFlag        = @ActiveFlag,
        SystemDeleteFlag  = @SystemDeleteFlag,
        UpdatedDateTime   = @UpdatedDateTime,
        UpdatedByUser     = @UpdatedByUser,
        UpdatedByProgram  = @UpdatedByProgram,
        SystemTimestamp   = @SystemTimestamp;

    /* ------------------- TRY…CATCH wrapper ---------------------------------------- */
    BEGIN TRY
        /* The UPDATE statement above is already inside the try block. */
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
        RAISERROR('50000',16,1,'Error occurred during UPDATE operation.');
    END CATCH;
END; /* usp_ActivityUpdate */
GO
