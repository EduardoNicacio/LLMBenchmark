/*****************************************************************************************
*  Procedure: usp_ActivityInsert
*  Purpose : Insert a new Activity row.
*            All columns are supplied **except** the audit‑only fields (UpdatedDateTime,
*            UpdatedByUser, UpdatedByProgram, SystemTimestamp). CreatedDateTime,
*            CreatedByUser and CreatedByProgram must be provided.
*****************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityInsert
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
    @CreatedDateTime   DATETIME2(7),
    @CreatedByUser     NVARCHAR(100),
    @CreatedByProgram  NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    /* ------------------- Validation ------------------------------------------------- */
    IF @ActivityId IS NULL                THEN RAISERROR(50001,'@ActivityId cannot be NULL.',0);
    IF @ProjectId IS NULL                 THEN RAISERROR(50001,'@ProjectId cannot be NULL.',0);
    IF @ProjectMemberId IS NULL           THEN RAISERROR(50001,'@ProjectMemberId cannot be NULL.',0);
    IF @Name IS NULL                      THEN RAISERROR(50001,'@Name cannot be NULL.',0);
    IF @Description IS NULL               THEN RAISERROR(50001,'@Description cannot be NULL.',0);
    IF @ActiveFlag IS NULL                THEN RAISERROR(50001,'@ActiveFlag cannot be NULL.',0);
    IF @SystemDeleteFlag IS NULL          THEN RAISERROR(50001,'@SystemDeleteFlag cannot be NULL.',0);
    IF @CreatedDateTime IS NULL           THEN RAISERROR(50001,'@CreatedDateTime cannot be NULL.',0);
    IF @CreatedByUser IS NULL             THEN RAISERROR(50001,'@CreatedByUser cannot be NULL.',0);
    IF @CreatedByProgram IS NULL          THEN RAISERROR(50001,'@CreatedByProgram cannot be NULL.',0);

    /* Length checks */
    IF LEN(@Name) > 128                  THEN RAISERROR(50002,'@Name exceeds column length (128).',0);
    IF LEN(@Description) > 4000          THEN RAISERROR(50002,'@Description exceeds column length (4000).',0);
    IF LEN(@Tags) > 200                  THEN RAISERROR(50002,'@Tags exceeds column length (200).',0);

    /* Flag checks */
    IF @ActiveFlag NOT IN (0,1)          THEN RAISERROR(50003,'@ActiveFlag must be 0 or 1.',0);
    IF @SystemDeleteFlag NOT IN ('N','Y') THEN RAISERROR(50003,'@SystemDeleteFlag must be N or Y.',0);

    /* ------------------- INSERT ---------------------------------------------------- */
    INSERT INTO dbo.Activity
        (ActivityId, ProjectId, ProjectMemberId, Name, Description,
         StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints,
         Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag,
         CreatedDateTime, CreatedByUser, CreatedByProgram)
    VALUES
        (@ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
         @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
         @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
         @CreatedDateTime, @CreatedByUser, @CreatedByProgram);

    /* ------------------- TRY…CATCH wrapper ---------------------------------------- */
    BEGIN TRY
        /* The INSERT statement above is already inside the try block. */
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
        RAISERROR('50000',16,1,'Error occurred during INSERT operation.');
    END CATCH;
END; /* usp_ActivityInsert */
GO
